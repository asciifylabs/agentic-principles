# Manage Context Windows

> Treat context window capacity as a finite, expensive resource — prioritize relevant information, compress history, and never blindly concatenate everything.

## Rules

- Know your model's context window limits and track token usage per request — exceeding the limit silently truncates or errors
- Prioritize recent and relevant context over completeness — a focused 2K-token context outperforms a noisy 100K-token dump
- Implement conversation history management: use a sliding window of recent messages with summarized older history
- Use a hybrid buffer strategy: keep recent exchanges verbatim, summarize older ones, and extract key facts into structured memory
- Place the most important context at the beginning and end of the prompt — models attend more strongly to these positions
- Count tokens before sending requests — use the model's tokenizer, not character counts, for accurate measurement
- Compress repetitive or verbose context before inclusion: deduplicate, summarize, and remove formatting noise
- For multi-turn conversations, periodically compact the context to prevent unbounded growth and escalating costs

## Example

```python
# Bad: blindly appending all messages until context overflows
messages = []
while True:
    user_input = get_input()
    messages.append({"role": "user", "content": user_input})
    response = client.messages.create(model=model, messages=messages)  # Will eventually overflow
    messages.append({"role": "assistant", "content": response.content[0].text})

# Good: managed context with sliding window and summarization
class ContextManager:
    def __init__(self, max_tokens: int = 8000, recent_count: int = 10):
        self.max_tokens = max_tokens
        self.recent_count = recent_count
        self.messages: list[dict] = []
        self.summary: str = ""

    def add_message(self, role: str, content: str) -> None:
        self.messages.append({"role": role, "content": content})

        if len(self.messages) > self.recent_count * 2:
            self._compact()

    def _compact(self) -> None:
        """Summarize older messages to free context space."""
        older = self.messages[:-self.recent_count]
        self.summary = summarize_messages(self.summary, older)
        self.messages = self.messages[-self.recent_count:]

    def get_messages(self) -> list[dict]:
        """Return context-managed message list."""
        result = []
        if self.summary:
            result.append({
                "role": "user",
                "content": f"<conversation_summary>\n{self.summary}\n</conversation_summary>"
            })
            result.append({
                "role": "assistant",
                "content": "Understood, I have the conversation context."
            })
        result.extend(self.messages)
        return result
```
