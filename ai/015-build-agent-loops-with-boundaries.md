# Build Agent Loops with Boundaries

> Design AI agent loops with explicit termination conditions, step limits, cost caps, and human escalation paths — unbounded agents are a reliability and cost risk.

## Rules

- Set a maximum number of iterations (steps) for every agent loop — never allow unbounded execution
- Implement a cost ceiling: track cumulative token usage per agent run and halt when the budget is exhausted
- Define explicit termination conditions beyond "the model says it's done" — use task-specific completion checks
- Implement a dead-loop detector: if the agent repeats the same action or makes no progress for N consecutive steps, break the loop
- Add human escalation paths: when the agent is stuck, uncertain, or about to take a high-risk action, pause and ask for input
- Log every agent step with the reasoning, action taken, and observation received — the full trace is essential for debugging
- Use structured state management: pass explicit state objects between steps instead of relying solely on conversation history
- Isolate agent execution: run agents in sandboxed environments with limited file system, network, and process access

## Example

```python
# Bad: unbounded agent loop
def agent(task):
    while True:
        action = llm.decide(task)
        if action == "done":  # Model can hallucinate "done" or never say it
            break
        result = execute(action)
        task += f"\nResult: {result}"

# Good: bounded agent loop with safety controls
@dataclass
class AgentState:
    task: str
    steps: list[dict] = field(default_factory=list)
    total_tokens: int = 0

class AgentConfig:
    max_steps: int = 20
    max_cost_usd: float = 1.0
    stall_threshold: int = 3  # Max repeated actions before breaking

def run_agent(task: str, config: AgentConfig = AgentConfig()) -> AgentState:
    state = AgentState(task=task)
    recent_actions = []

    for step in range(config.max_steps):
        # Cost check
        if estimate_cost(state.total_tokens) > config.max_cost_usd:
            logger.warning("agent_budget_exhausted", step=step)
            break

        action, tokens = plan_next_action(state)
        state.total_tokens += tokens

        # Stall detection
        recent_actions.append(action.name)
        if len(recent_actions) > config.stall_threshold:
            recent_actions = recent_actions[-config.stall_threshold:]
            if len(set(recent_actions)) == 1:
                logger.warning("agent_stalled", repeated_action=action.name)
                break

        # Execute with safety check
        if action.risk_level == "high":
            if not get_human_approval(action):
                break

        result = execute_action(action)
        state.steps.append({"action": action, "result": result, "step": step})

        if action.name == "complete" and verify_completion(state):
            break

    return state
```
