# Design Multi-Agent Systems Carefully

> Architect multi-agent systems with clear role boundaries, explicit communication protocols, and centralized state management — complexity grows exponentially with each additional agent.

## Rules

- Give each agent a single, well-defined responsibility — avoid agents with overlapping or ambiguous roles
- Define explicit communication protocols between agents: structured message formats, clear handoff conventions, and typed interfaces
- Use a centralized orchestrator or event bus for coordination — do not let agents call each other in ad-hoc chains
- Implement shared state management: use a common state store that agents read from and write to, with conflict resolution rules
- Set global resource limits: total token budget, maximum wall-clock time, and maximum number of agent invocations per request
- Design for partial failure: if one agent fails, the system should degrade gracefully rather than cascade-fail
- Log the full agent interaction trace: which agent acted, what it received, what it produced, and how long it took
- Start simple: use a single agent with tools before introducing multi-agent architectures — add agents only when a single agent demonstrably cannot handle the complexity
- Test agent interactions in isolation (unit) and together (integration) — multi-agent bugs often emerge from interaction patterns, not individual agent failures

## Example

```python
# Bad: agents calling each other in an ad-hoc chain
def research(query):
    summary = summarizer_agent(query)
    facts = fact_checker_agent(summary)  # What if summarizer fails?
    return writer_agent(facts)  # No coordination, no error handling

# Good: orchestrated multi-agent system with clear roles
from dataclasses import dataclass, field
from enum import Enum

class AgentRole(Enum):
    RESEARCHER = "researcher"
    ANALYZER = "analyzer"
    WRITER = "writer"

@dataclass
class AgentMessage:
    from_agent: AgentRole
    content: str
    metadata: dict = field(default_factory=dict)

@dataclass
class TaskState:
    query: str
    research: str | None = None
    analysis: str | None = None
    draft: str | None = None
    errors: list[str] = field(default_factory=list)

def orchestrate(query: str, max_tokens: int = 10000) -> TaskState:
    """Centralized orchestrator with error handling and budget tracking."""
    state = TaskState(query=query)
    tokens_used = 0

    # Step 1: Research
    try:
        result, tokens = run_agent(AgentRole.RESEARCHER, state)
        state.research = result
        tokens_used += tokens
    except AgentError as e:
        state.errors.append(f"Research failed: {e}")
        return state  # Cannot proceed without research

    # Step 2: Analysis (can proceed without, but degraded)
    if tokens_used < max_tokens:
        try:
            result, tokens = run_agent(AgentRole.ANALYZER, state)
            state.analysis = result
            tokens_used += tokens
        except AgentError as e:
            state.errors.append(f"Analysis failed: {e}")

    # Step 3: Writing
    if tokens_used < max_tokens:
        result, tokens = run_agent(AgentRole.WRITER, state)
        state.draft = result

    logger.info("orchestration_complete", tokens=tokens_used, errors=len(state.errors))
    return state
```
