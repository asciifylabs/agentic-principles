# Use Few-Shot Examples Strategically

> Provide carefully selected input-output examples in your prompts to steer model behavior — few-shot examples are the most reliable way to demonstrate desired format, style, and reasoning patterns.

## Rules

- Use few-shot examples to demonstrate output format, not just to explain it — showing is more reliable than telling
- Select diverse examples that cover edge cases and variations, not just the happy path
- Order examples from simple to complex — models learn patterns from example progression
- Keep examples consistent: use the same format, style, and level of detail across all examples in a prompt
- Match example complexity to your task: 2-3 examples for simple formatting, 5+ for complex reasoning patterns
- Never use examples from your evaluation dataset as few-shot examples — this inflates performance metrics
- Use dynamic example selection: retrieve the most relevant examples based on the input query rather than using a fixed set
- Test prompts with and without few-shot examples to measure their actual impact — sometimes zero-shot with clear instructions outperforms poorly chosen examples
- Store examples separately from prompt templates so they can be updated independently

## Example

```python
# Bad: vague instruction without examples
def classify_sentiment(text):
    return llm.complete(f"Classify the sentiment as positive, negative, or neutral: {text}")

# Good: few-shot examples demonstrating exact format and edge cases
FEW_SHOT_EXAMPLES = [
    {"role": "user", "content": "Classify sentiment: The product works great, highly recommend!"},
    {"role": "assistant", "content": "positive"},
    {"role": "user", "content": "Classify sentiment: Worst purchase ever. Broke after one day."},
    {"role": "assistant", "content": "negative"},
    {"role": "user", "content": "Classify sentiment: It arrived on time. Does what it says."},
    {"role": "assistant", "content": "neutral"},
    # Edge case: mixed sentiment
    {"role": "user", "content": "Classify sentiment: Love the design but battery life is terrible."},
    {"role": "assistant", "content": "negative"},
]

def classify_sentiment(text: str) -> str:
    messages = FEW_SHOT_EXAMPLES + [
        {"role": "user", "content": f"Classify sentiment: {text}"}
    ]

    return client.messages.create(
        model="claude-haiku-4-5-20251001",
        max_tokens=10,
        system="Classify text sentiment as exactly one of: positive, negative, neutral. Return only the label.",
        messages=messages,
    ).content[0].text.strip()

# Better: dynamic example selection based on input similarity
def classify_with_dynamic_examples(text: str, example_store, k: int = 3) -> str:
    """Select the most relevant few-shot examples for the input."""
    relevant_examples = example_store.find_similar(text, k=k)

    messages = []
    for ex in relevant_examples:
        messages.append({"role": "user", "content": f"Classify sentiment: {ex.input}"})
        messages.append({"role": "assistant", "content": ex.label})
    messages.append({"role": "user", "content": f"Classify sentiment: {text}"})

    return client.messages.create(
        model="claude-haiku-4-5-20251001",
        max_tokens=10,
        system="Classify text sentiment as exactly one of: positive, negative, neutral. Return only the label.",
        messages=messages,
    ).content[0].text.strip()
```
