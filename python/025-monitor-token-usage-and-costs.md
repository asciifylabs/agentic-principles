# Monitor Token Usage and Costs

> Track token consumption and API costs to stay within budgets and optimize spending on LLM API calls.

## Rules

- Log token usage for every API call (prompt tokens, completion tokens, total)
- Calculate and track estimated costs based on model pricing
- Implement budget limits and alerts when approaching thresholds
- Use callbacks or decorators to automatically track usage across the application
- Aggregate usage metrics by user, feature, or endpoint for cost allocation
- Monitor and optimize expensive prompts by reducing token count
- Use cheaper models for simple tasks and expensive models only when needed

## Example

```python
# Bad: no tracking of costs
def call_llm(prompt):
    return openai.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}]
    )
# No idea how much this costs!

# Good: basic token tracking
import logging
from openai import OpenAI

logger = logging.getLogger(__name__)

# GPT-4 pricing (as of 2024)
PRICING = {
    "gpt-4": {"input": 0.03 / 1000, "output": 0.06 / 1000},
    "gpt-3.5-turbo": {"input": 0.0015 / 1000, "output": 0.002 / 1000}
}

def call_llm_with_tracking(prompt: str, model: str = "gpt-4") -> tuple[str, dict]:
    """Call LLM and track usage."""
    client = OpenAI()

    response = client.chat.completions.create(
        model=model,
        messages=[{"role": "user", "content": prompt}]
    )

    usage = response.usage
    cost = (
        usage.prompt_tokens * PRICING[model]["input"] +
        usage.completion_tokens * PRICING[model]["output"]
    )

    metrics = {
        "model": model,
        "prompt_tokens": usage.prompt_tokens,
        "completion_tokens": usage.completion_tokens,
        "total_tokens": usage.total_tokens,
        "estimated_cost": cost
    }

    logger.info("LLM API call", extra=metrics)

    return response.choices[0].message.content, metrics

# Better: usage tracking with aggregation
from dataclasses import dataclass, field
from datetime import datetime
import threading

@dataclass
class UsageTracker:
    """Track and aggregate LLM usage."""
    total_tokens: int = 0
    total_cost: float = 0.0
    calls_by_model: dict[str, int] = field(default_factory=dict)
    lock: threading.Lock = field(default_factory=threading.Lock)

    def record(self, model: str, tokens: int, cost: float) -> None:
        """Record usage from an API call."""
        with self.lock:
            self.total_tokens += tokens
            self.total_cost += cost
            self.calls_by_model[model] = self.calls_by_model.get(model, 0) + 1

    def report(self) -> dict:
        """Generate usage report."""
        with self.lock:
            return {
                "total_tokens": self.total_tokens,
                "total_cost_usd": round(self.total_cost, 4),
                "calls_by_model": self.calls_by_model.copy()
            }

tracker = UsageTracker()

def call_llm_tracked(prompt: str, model: str = "gpt-4") -> str:
    """Call LLM with automatic usage tracking."""
    content, metrics = call_llm_with_tracking(prompt, model)

    tracker.record(
        model=metrics["model"],
        tokens=metrics["total_tokens"],
        cost=metrics["estimated_cost"]
    )

    return content

# Best: decorator with budget limits
class BudgetExceededError(Exception):
    """Raised when API budget is exceeded."""
    pass

def with_budget(max_cost_usd: float):
    """Decorator to enforce budget limits."""
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            report = tracker.report()
            if report["total_cost_usd"] >= max_cost_usd:
                raise BudgetExceededError(
                    f"Budget exceeded: ${report['total_cost_usd']:.4f} >= ${max_cost_usd}"
                )
            return func(*args, **kwargs)
        return wrapper
    return decorator

@with_budget(max_cost_usd=10.0)
def expensive_operation(prompt: str) -> str:
    """Operation with budget protection."""
    return call_llm_tracked(prompt, model="gpt-4")

# Usage: monitor costs
result = call_llm_tracked("Explain quantum computing")
print(tracker.report())
# Output: {'total_tokens': 523, 'total_cost_usd': 0.0234, 'calls_by_model': {'gpt-4': 1}}
```
