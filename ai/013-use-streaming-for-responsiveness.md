# Use Streaming for Responsiveness

> Stream LLM responses token-by-token to reduce perceived latency — users should see output appearing immediately, not wait for the full response.

## Rules

- Use streaming for all user-facing LLM interactions — the difference between 0ms and 3-second time-to-first-token is the difference between fluid and broken UX
- Implement proper backpressure handling: if the client disconnects, cancel the upstream LLM request to avoid wasted cost
- Accumulate the full streamed response server-side for logging, caching, and validation — do not rely solely on client-side assembly
- Handle stream interruptions gracefully: detect partial responses and either retry or inform the user
- Use Server-Sent Events (SSE) or WebSockets to stream from your backend to the client — do not poll
- Apply output guardrails on the accumulated response, not individual tokens — per-token filtering is noisy and unreliable
- Set streaming timeouts: if no tokens arrive within a reasonable window (10-30 seconds), abort and handle the failure
- For batch processing or background jobs where no user is waiting, use non-streaming calls for simpler error handling

## Example

```typescript
// Bad: blocking call — user stares at a spinner for 5+ seconds
app.post("/chat", async (req, res) => {
  const response = await client.messages.create({
    model: "claude-sonnet-4-5-20250929",
    max_tokens: 1024,
    messages: req.body.messages,
  });
  res.json({ text: response.content[0].text });
});

// Good: streaming with SSE for immediate feedback
app.post("/chat", async (req, res) => {
  res.setHeader("Content-Type", "text/event-stream");
  res.setHeader("Cache-Control", "no-cache");
  res.setHeader("Connection", "keep-alive");

  let fullResponse = "";

  const stream = client.messages.stream({
    model: "claude-sonnet-4-5-20250929",
    max_tokens: 1024,
    messages: req.body.messages,
  });

  stream.on("text", (text) => {
    fullResponse += text;
    res.write(`data: ${JSON.stringify({ text })}\n\n`);
  });

  stream.on("end", () => {
    // Log the complete response server-side
    logger.info("stream_complete", { tokens: fullResponse.length });
    res.write(`data: ${JSON.stringify({ done: true })}\n\n`);
    res.end();
  });

  // Cancel on client disconnect
  req.on("close", () => {
    stream.abort();
  });
});
```
