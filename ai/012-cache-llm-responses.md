# Cache LLM Responses

> Cache LLM responses at multiple levels — exact match, semantic similarity, and prompt caching — to reduce cost, latency, and redundant API calls.

## Rules

- Implement exact-match caching: hash the full request (model, system prompt, messages, parameters) and return cached responses for identical requests
- Use semantic caching for inputs that are different in wording but identical in meaning — embed the query and check similarity against cached entries
- Set appropriate TTL (time-to-live) for cached responses based on how quickly the underlying data changes
- Cache at the right granularity: cache final responses for user-facing features, cache intermediate results (embeddings, retrieved chunks) for pipeline stages
- Use provider-level prompt caching (Anthropic prompt caching, OpenAI cached prompts) for repeated system prompts and few-shot examples
- Invalidate caches when prompts change, models update, or source data is refreshed
- Monitor cache hit rates and measure the cost savings — low hit rates suggest the cache is not worth the complexity
- Never cache responses that contain user-specific PII or time-sensitive information without proper scoping

## Example

```python
import hashlib
import json

# Bad: no caching — identical questions hit the API every time
def ask(question):
    return llm.complete(question)

# Good: multi-level caching
class LLMCache:
    def __init__(self, redis_client, embedding_fn, similarity_threshold=0.95):
        self.redis = redis_client
        self.embed = embedding_fn
        self.threshold = similarity_threshold

    def _exact_key(self, model: str, messages: list) -> str:
        payload = json.dumps({"model": model, "messages": messages}, sort_keys=True)
        return f"llm:exact:{hashlib.sha256(payload.encode()).hexdigest()}"

    def get_or_call(self, model: str, messages: list, call_fn) -> str:
        # Level 1: exact match
        key = self._exact_key(model, messages)
        cached = self.redis.get(key)
        if cached:
            logger.info("cache_hit", level="exact")
            return cached.decode()

        # Level 2: semantic similarity
        query = messages[-1]["content"]
        similar = self._find_semantic_match(query)
        if similar:
            logger.info("cache_hit", level="semantic")
            return similar

        # Cache miss — call the API
        response = call_fn(model=model, messages=messages)
        self.redis.setex(key, 3600, response)  # 1-hour TTL
        self._store_semantic(query, response)
        return response
```
