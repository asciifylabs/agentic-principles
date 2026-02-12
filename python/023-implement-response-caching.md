# Implement Response Caching

> Cache LLM API responses to reduce costs, improve latency, and avoid redundant API calls for identical inputs.

## Rules

- Cache API responses based on prompt hash to avoid duplicate calls
- Use TTL (time-to-live) for cache entries to allow for model improvements
- Implement cache warming for common queries at application startup
- Use persistent caching (Redis, files) for production, memory for development
- Include model version in cache key to invalidate cache on model changes
- Set appropriate cache sizes and eviction policies
- Log cache hit/miss rates to monitor effectiveness

## Example

```python
# Bad: no caching, repeated API calls
def get_completion(prompt):
    return openai.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}]
    )

# Every call costs money, even for identical prompts

# Good: simple in-memory caching
import hashlib
import functools
from typing import Any

@functools.lru_cache(maxsize=128)
def get_completion_cached(prompt: str) -> str:
    """Get completion with LRU cache."""
    response = openai.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}]
    )
    return response.choices[0].message.content

# Better: Redis caching with TTL
import json
import hashlib
import redis
from datetime import timedelta

class LLMCache:
    """Redis-backed cache for LLM responses."""

    def __init__(self, redis_client: redis.Redis, ttl: timedelta = timedelta(days=7)):
        self.redis = redis_client
        self.ttl = ttl

    def _make_key(self, model: str, prompt: str, **kwargs) -> str:
        """Generate cache key from parameters."""
        cache_input = json.dumps({
            "model": model,
            "prompt": prompt,
            **kwargs
        }, sort_keys=True)
        return f"llm_cache:{hashlib.sha256(cache_input.encode()).hexdigest()}"

    def get(self, model: str, prompt: str, **kwargs) -> str | None:
        """Get cached response."""
        key = self._make_key(model, prompt, **kwargs)
        cached = self.redis.get(key)
        if cached:
            return json.loads(cached)
        return None

    def set(self, response: str, model: str, prompt: str, **kwargs) -> None:
        """Cache response with TTL."""
        key = self._make_key(model, prompt, **kwargs)
        self.redis.setex(
            key,
            self.ttl,
            json.dumps(response)
        )

# Usage
cache = LLMCache(redis.Redis(host="localhost", port=6379))

def get_completion_with_cache(prompt: str) -> str:
    """Get completion with Redis caching."""
    # Check cache first
    cached = cache.get(model="gpt-4", prompt=prompt)
    if cached:
        logger.info("Cache hit", extra={"prompt_hash": hashlib.sha256(prompt.encode()).hexdigest()[:8]})
        return cached

    # Call API
    logger.info("Cache miss, calling API")
    response = openai.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}]
    )
    result = response.choices[0].message.content

    # Cache for future use
    cache.set(result, model="gpt-4", prompt=prompt)
    return result

# Best: decorator for automatic caching
def llm_cache(ttl: timedelta = timedelta(days=7)):
    """Decorator for LLM function caching."""
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            cache_key = f"llm:{func.__name__}:{hash((args, tuple(kwargs.items())))}"
            cached = redis_client.get(cache_key)

            if cached:
                return json.loads(cached)

            result = func(*args, **kwargs)
            redis_client.setex(cache_key, ttl, json.dumps(result))
            return result
        return wrapper
    return decorator

@llm_cache(ttl=timedelta(hours=24))
def summarize_document(document: str) -> str:
    """Automatically cached summarization."""
    # This will be cached for 24 hours
    return get_completion(f"Summarize: {document}")
```
