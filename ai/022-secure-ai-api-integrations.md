# Secure AI API Integrations

> Treat AI API keys, request payloads, and response data with the same security rigor as any other sensitive system integration — AI APIs are high-value targets.

## Rules

- Store API keys in environment variables or secret managers — never in source code, config files, or client-side bundles
- Use separate API keys per environment (development, staging, production) and per service with scoped permissions
- Proxy all LLM API calls through your backend — never expose AI API keys to the browser or mobile client
- Implement request-level authentication and rate limiting on your AI proxy to prevent abuse and cost attacks
- Validate and sanitize all user inputs before including them in prompts — prevent prompt injection from becoming a data exfiltration vector
- Encrypt sensitive data before including it in prompts if possible — remember that API providers may log requests
- Review your AI provider's data retention and privacy policies — understand what happens to your prompts and completions
- Set spending limits and usage alerts with your AI provider to prevent billing surprises from bugs or attacks
- Rotate API keys on a regular schedule and immediately if a key may have been exposed
- Audit which services and team members have access to production AI API keys

## Example

```typescript
// Bad: API key in client-side code
const response = await fetch("https://api.anthropic.com/v1/messages", {
  headers: { "x-api-key": "sk-ant-EXPOSED_IN_BROWSER" }, // Visible to users!
  body: JSON.stringify({ messages: [{ role: "user", content: userInput }] }),
});

// Good: proxy through your backend with auth and rate limiting
// Client
const response = await fetch("/api/chat", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    Authorization: `Bearer ${sessionToken}`,
  },
  body: JSON.stringify({ message: userInput }),
});

// Server
app.post(
  "/api/chat",
  authenticate,
  rateLimit({ max: 20, window: "1m" }),
  async (req, res) => {
    const { message } = req.body;

    // Validate input
    if (!message || message.length > 10000) {
      return res.status(400).json({ error: "Invalid message" });
    }

    // Call AI API server-side — key never leaves the backend
    const response = await client.messages.create({
      model: "claude-sonnet-4-5-20250929",
      max_tokens: 1024,
      messages: [{ role: "user", content: message }],
    });

    // Log usage per user for cost tracking
    await logUsage(req.user.id, response.usage);

    res.json({ text: response.content[0].text });
  },
);
```
