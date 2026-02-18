# Handle LLM Failures Gracefully

> Expect LLM API calls to fail — implement retries with exponential backoff, model fallbacks, circuit breakers, and graceful degradation to keep your application reliable.

## Rules

- Implement exponential backoff with jitter for retryable errors (429 rate limits, 500/503 server errors) — never retry in a tight loop
- Set reasonable timeouts for LLM API calls — a 60-second hang is worse than a fast failure with fallback
- Configure model fallbacks: if the primary model is unavailable or too slow, fall back to a cheaper or faster alternative
- Use circuit breakers to stop calling a failing API endpoint — prevent cascade failures and unnecessary cost
- Distinguish between retryable errors (rate limits, transient server errors) and non-retryable errors (invalid request, authentication failure)
- Return meaningful error messages to users when AI features are degraded — never show raw API errors
- Implement request hedging for latency-sensitive paths: send parallel requests to multiple models, use the first response
- Log all failures and retries with enough context to diagnose patterns (model, error code, attempt count, latency)

## Example

```python
import time
import random
from functools import wraps

# Bad: no error handling
def ask(prompt):
    return client.messages.create(
        model="claude-sonnet-4-5-20250929",
        messages=[{"role": "user", "content": prompt}],
    ).content[0].text

# Good: retry with backoff and model fallback
FALLBACK_MODELS = ["claude-sonnet-4-5-20250929", "claude-haiku-4-5-20251001"]

def ask_with_resilience(prompt: str, max_retries: int = 3) -> str:
    """Call LLM with retries, backoff, and model fallback."""
    for model in FALLBACK_MODELS:
        for attempt in range(max_retries):
            try:
                response = client.messages.create(
                    model=model,
                    max_tokens=1024,
                    messages=[{"role": "user", "content": prompt}],
                )
                return response.content[0].text

            except RateLimitError:
                wait = (2 ** attempt) + random.uniform(0, 1)
                logger.warning("rate_limited", model=model, attempt=attempt, wait=wait)
                time.sleep(wait)

            except (ServerError, TimeoutError) as e:
                logger.warning("llm_error", model=model, attempt=attempt, error=str(e))
                if attempt == max_retries - 1:
                    logger.error("model_exhausted", model=model)
                    break  # Try next model

            except (AuthenticationError, BadRequestError):
                raise  # Non-retryable — fail immediately

    raise LLMUnavailableError("All models and retries exhausted")
```
