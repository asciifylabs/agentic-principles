# Use Streaming for Large Outputs

> Stream LLM responses instead of waiting for complete responses to improve user experience and handle large outputs efficiently.

## Rules

- Use streaming for LLM responses to show progress and reduce perceived latency
- Process chunks incrementally as they arrive instead of buffering everything
- Handle streaming errors gracefully (connection drops, incomplete responses)
- Use async streaming for better performance in web applications
- Display partial results to users immediately for better UX
- Implement timeout handling for streaming connections
- Close streaming connections properly to avoid resource leaks

## Example

```python
# Bad: waiting for complete response
from openai import OpenAI

client = OpenAI()

response = client.chat.completions.create(
    model="gpt-4",
    messages=[{"role": "user", "content": "Write a long story"}]
)
print(response.choices[0].message.content)  # User waits for entire response

# Good: streaming response
from openai import OpenAI

client = OpenAI()

stream = client.chat.completions.create(
    model="gpt-4",
    messages=[{"role": "user", "content": "Write a long story"}],
    stream=True
)

for chunk in stream:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="", flush=True)

# Better: async streaming with error handling
import asyncio
from anthropic import AsyncAnthropic

async def stream_response(prompt: str) -> str:
    """Stream LLM response with error handling."""
    client = AsyncAnthropic()
    full_response = []

    try:
        async with client.messages.stream(
            model="claude-3-5-sonnet-20241022",
            max_tokens=1024,
            messages=[{"role": "user", "content": prompt}]
        ) as stream:
            async for text in stream.text_stream:
                print(text, end="", flush=True)
                full_response.append(text)

        return "".join(full_response)

    except asyncio.TimeoutError:
        print("\n[Stream timeout - partial response]")
        return "".join(full_response)
    except Exception as e:
        print(f"\n[Stream error: {e}]")
        raise

# Usage
asyncio.run(stream_response("Explain quantum computing"))

# Best: streaming in web application with SSE
from fastapi import FastAPI
from fastapi.responses import StreamingResponse
from anthropic import Anthropic

app = FastAPI()

@app.get("/chat")
async def chat_stream(prompt: str):
    """Server-sent events endpoint for streaming."""

    async def generate():
        client = Anthropic()
        with client.messages.stream(
            model="claude-3-5-sonnet-20241022",
            max_tokens=1024,
            messages=[{"role": "user", "content": prompt}]
        ) as stream:
            for text in stream.text_stream:
                yield f"data: {text}\n\n"

    return StreamingResponse(
        generate(),
        media_type="text/event-stream"
    )
```
