# Optimize Token Usage

> Minimize token consumption without sacrificing output quality — every wasted token costs money and adds latency.

## Rules

- Measure token usage per feature and endpoint — identify which prompts are the most expensive and optimize those first
- Use the cheapest model that meets quality requirements for each task — route simple tasks to smaller models, complex tasks to larger ones
- Trim unnecessary whitespace, boilerplate, and verbose instructions from prompts — brevity improves both cost and focus
- Set `max_tokens` appropriately for each call — do not use the maximum when you expect short responses
- Cache responses for identical or semantically similar inputs to avoid redundant API calls
- Batch multiple small requests into single calls when the API supports it
- Compress context by summarizing long documents before including them in prompts — a 500-token summary beats a 10K-token dump
- Monitor cost per user, per feature, and per request to detect runaway spending early and allocate budgets accurately

## Example

```python
# Bad: wasteful token usage
def classify(text):
    return client.messages.create(
        model="claude-opus-4-6",  # Overkill for classification
        max_tokens=4096,  # Only need a single word
        messages=[{
            "role": "user",
            "content": f"""Please carefully analyze the following text and determine
            what category it belongs to. Consider all possibilities and provide
            a detailed explanation of your reasoning before giving the final
            classification.\n\nText: {text}"""
        }],
    ).content[0].text

# Good: optimized token usage
def classify(text: str) -> str:
    return client.messages.create(
        model="claude-haiku-4-5-20251001",  # Fast, cheap model for simple task
        max_tokens=20,  # Classification is a short response
        system="Classify text into exactly one category: billing, technical, general. Return only the category name.",
        messages=[{"role": "user", "content": text}],
    ).content[0].text
```
