# Implement LLM Observability

> Trace every LLM call with inputs, outputs, latency, token usage, and cost — you cannot debug, optimize, or improve what you cannot see.

## Rules

- Log every LLM API call with: model, prompt (or hash), completion, token counts, latency, and estimated cost
- Use distributed tracing to connect LLM calls to the user requests that triggered them — assign a trace ID across the full request lifecycle
- Track quality metrics over time: user satisfaction signals, output validation pass rates, retrieval relevance scores
- Monitor for regressions after prompt changes, model updates, or configuration changes
- Set alerts on anomalies: sudden spikes in token usage, increased error rates, latency degradation, or cost overruns
- Use structured logging (JSON) with consistent field names across all LLM interactions for queryability
- Store prompt-completion pairs for debugging and evaluation — but redact PII and sensitive data before storage
- Integrate with observability platforms (Langfuse, LangSmith, Arize, OpenTelemetry) rather than building custom solutions

## Example

```python
# Bad: no observability
def ask(question):
    return client.messages.create(
        model="claude-sonnet-4-5-20250929",
        messages=[{"role": "user", "content": question}],
    ).content[0].text

# Good: structured observability for every LLM call
import time
import structlog

logger = structlog.get_logger("llm")

def ask(question: str, trace_id: str | None = None) -> str:
    start = time.monotonic()
    model = "claude-sonnet-4-5-20250929"

    try:
        response = client.messages.create(
            model=model,
            max_tokens=1024,
            messages=[{"role": "user", "content": question}],
        )

        duration_ms = (time.monotonic() - start) * 1000
        usage = response.usage

        logger.info(
            "llm.call.success",
            trace_id=trace_id,
            model=model,
            input_tokens=usage.input_tokens,
            output_tokens=usage.output_tokens,
            duration_ms=round(duration_ms, 2),
            stop_reason=response.stop_reason,
        )

        return response.content[0].text

    except Exception as e:
        duration_ms = (time.monotonic() - start) * 1000
        logger.error(
            "llm.call.failure",
            trace_id=trace_id,
            model=model,
            error=str(e),
            duration_ms=round(duration_ms, 2),
        )
        raise
```
