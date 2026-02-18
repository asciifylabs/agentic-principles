# Implement AI Guardrails

> Apply layered input and output filters to prevent harmful, off-topic, or policy-violating content from entering or leaving your AI system.

## Rules

- Implement both input guardrails (filter user prompts) and output guardrails (filter model responses) — neither alone is sufficient
- Use a layered defense: combine keyword filters, classifier models, and LLM-based judges for defense in depth
- Block prompt injection attempts: detect and reject inputs that try to override system instructions or extract the system prompt
- Filter outputs for harmful content categories relevant to your application: hate speech, violence, sexual content, personal information leakage
- Define a clear content policy document and configure guardrails to enforce it — do not rely on the model's built-in safety alone
- Set confidence thresholds for guardrail classifiers and tune them to balance safety against false positive rates
- Log all guardrail triggers with the flagged content (redacted if needed) for review and threshold tuning
- Use established guardrail frameworks (Guardrails AI, NeMo Guardrails, Bedrock Guardrails) rather than building everything from scratch
- Test guardrails with adversarial inputs regularly — attackers actively probe for bypasses

## Example

```python
# Bad: no guardrails — raw user input to model, raw output to user
def chat(user_input):
    return llm.complete(user_input)

# Good: input and output guardrails with logging
from dataclasses import dataclass

@dataclass
class GuardrailResult:
    passed: bool
    reason: str | None = None

def check_input(text: str) -> GuardrailResult:
    """Check user input for policy violations."""
    # Check for prompt injection patterns
    injection_patterns = ["ignore previous instructions", "reveal your system prompt"]
    if any(pattern in text.lower() for pattern in injection_patterns):
        return GuardrailResult(passed=False, reason="prompt_injection_detected")

    # Use classifier for content safety
    safety_score = content_classifier.score(text)
    if safety_score.harmful > 0.8:
        return GuardrailResult(passed=False, reason=f"harmful_input: {safety_score.category}")

    return GuardrailResult(passed=True)

def check_output(text: str) -> GuardrailResult:
    """Check model output for policy violations."""
    if contains_pii(text):
        return GuardrailResult(passed=False, reason="pii_in_output")
    if contains_system_prompt_leak(text):
        return GuardrailResult(passed=False, reason="system_prompt_leak")
    return GuardrailResult(passed=True)

def chat(user_input: str) -> str:
    input_check = check_input(user_input)
    if not input_check.passed:
        logger.warning("input_guardrail_triggered", reason=input_check.reason)
        return "I can't help with that request."

    response = llm.complete(user_input)

    output_check = check_output(response)
    if not output_check.passed:
        logger.warning("output_guardrail_triggered", reason=output_check.reason)
        return "I'm unable to provide that response."

    return response
```
