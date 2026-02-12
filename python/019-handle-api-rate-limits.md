# Handle API Rate Limits

> Implement exponential backoff and retry logic to handle rate limits gracefully and avoid overwhelming APIs.

## Rules

- Always handle HTTP 429 (Too Many Requests) responses from APIs
- Implement exponential backoff with jitter for retries
- Use libraries like `tenacity` or `backoff` for robust retry logic
- Respect `Retry-After` headers when provided by the API
- Track rate limit headers (X-RateLimit-Remaining, X-RateLimit-Reset)
- Implement client-side rate limiting to stay under API quotas
- Use queues or task schedulers for high-volume API calls

## Example

```python
# Bad: no retry logic
import requests

def call_api(prompt):
    response = requests.post(
        "https://api.openai.com/v1/chat/completions",
        json={"model": "gpt-4", "messages": [{"role": "user", "content": prompt}]}
    )
    return response.json()  # Fails on rate limit

# Good: using tenacity for retries
from tenacity import (
    retry,
    stop_after_attempt,
    wait_exponential,
    retry_if_exception_type
)
import requests
from requests.exceptions import HTTPError

class RateLimitError(Exception):
    """Raised when API rate limit is hit."""
    pass

@retry(
    retry=retry_if_exception_type(RateLimitError),
    wait=wait_exponential(multiplier=1, min=2, max=60),
    stop=stop_after_attempt(5)
)
def call_api_with_retry(prompt: str) -> dict:
    """Call API with automatic retry on rate limits."""
    response = requests.post(
        "https://api.openai.com/v1/chat/completions",
        headers={"Authorization": f"Bearer {API_KEY}"},
        json={
            "model": "gpt-4",
            "messages": [{"role": "user", "content": prompt}]
        }
    )

    if response.status_code == 429:
        retry_after = int(response.headers.get("Retry-After", 60))
        raise RateLimitError(f"Rate limited, retry after {retry_after}s")

    response.raise_for_status()
    return response.json()

# Better: with rate limit tracking
import time
from collections import deque

class RateLimiter:
    """Simple token bucket rate limiter."""

    def __init__(self, max_calls: int, period: float):
        self.max_calls = max_calls
        self.period = period
        self.calls = deque()

    def wait_if_needed(self) -> None:
        """Block if rate limit would be exceeded."""
        now = time.time()

        # Remove old calls outside the period
        while self.calls and self.calls[0] < now - self.period:
            self.calls.popleft()

        if len(self.calls) >= self.max_calls:
            sleep_time = self.period - (now - self.calls[0])
            if sleep_time > 0:
                time.sleep(sleep_time)

        self.calls.append(time.time())

# Usage
limiter = RateLimiter(max_calls=10, period=60)  # 10 calls per minute

for prompt in prompts:
    limiter.wait_if_needed()
    result = call_api_with_retry(prompt)
```
