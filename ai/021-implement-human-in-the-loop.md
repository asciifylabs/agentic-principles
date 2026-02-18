# Implement Human-in-the-Loop

> Design AI systems with human oversight at critical decision points — automated AI should escalate to humans when confidence is low, stakes are high, or actions are irreversible.

## Rules

- Identify high-stakes decisions in your application and require human confirmation before the AI acts on them
- Implement confidence thresholds: when model confidence is below a defined threshold, route to human review instead of auto-acting
- Design clear escalation paths: the system should explain why it is escalating and what input it needs from the human
- Provide humans with the AI's reasoning, confidence score, and relevant context — do not ask them to review outputs blind
- Track human override rates: if humans frequently override the AI, the model or prompt needs improvement
- Implement approval workflows for content generation, moderation decisions, and automated communications
- Allow humans to provide feedback that improves future AI performance — close the feedback loop
- Never remove human oversight to improve throughput — optimize the review interface instead
- Log all human decisions alongside the AI's original recommendation for training data and audit purposes

## Example

```python
# Bad: fully automated with no human oversight
def process_refund(request):
    decision = llm.decide(f"Should we refund? {request}")
    if "yes" in decision.lower():
        execute_refund(request)  # No human check for any amount

# Good: confidence-based human escalation
@dataclass
class AIDecision:
    action: str
    confidence: float
    reasoning: str

CONFIDENCE_THRESHOLD = 0.85
AUTO_APPROVE_LIMIT = 50.00  # Auto-approve refunds under $50

def process_refund(request: dict) -> dict:
    decision = analyze_refund_request(request)

    # Auto-approve: high confidence AND low value
    if decision.confidence >= CONFIDENCE_THRESHOLD and request["amount"] <= AUTO_APPROVE_LIMIT:
        execute_refund(request)
        logger.info("refund_auto_approved", confidence=decision.confidence)
        return {"status": "approved", "method": "auto"}

    # Escalate: low confidence OR high value
    review = create_human_review(
        request=request,
        ai_decision=decision,
        reason="low_confidence" if decision.confidence < CONFIDENCE_THRESHOLD else "high_value",
    )
    logger.info("refund_escalated", confidence=decision.confidence, amount=request["amount"])
    return {"status": "pending_review", "review_id": review.id}
```
