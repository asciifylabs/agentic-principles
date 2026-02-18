# Evaluate LLM Outputs Systematically

> Build automated evaluation pipelines with diverse metrics and golden datasets to catch quality regressions before they reach users.

## Rules

- Create a golden evaluation dataset: curated input-output pairs that represent expected behavior across your use cases
- Run evaluations automatically in CI/CD on every prompt change, model update, or configuration change
- Use multiple evaluation methods: exact match for factual outputs, LLM-as-judge for subjective quality, human review for edge cases
- Measure task-specific metrics: accuracy, faithfulness, relevance, completeness, format compliance, and latency
- Track evaluation scores over time to detect gradual quality drift — a single evaluation is a snapshot, trends reveal problems
- Separate evaluation datasets by difficulty: easy cases confirm basic functionality, hard cases test edge cases and robustness
- Include adversarial and boundary-case examples in evaluation sets — normal inputs rarely reveal weaknesses
- Never use the same examples for both few-shot prompting and evaluation — this inflates scores and hides real performance

## Example

```python
# Bad: manual spot-checking
result = llm.complete("What is the capital of France?")
print(result)  # "Paris" — looks good, ship it!

# Good: automated evaluation pipeline
from dataclasses import dataclass

@dataclass
class EvalCase:
    input: str
    expected: str
    category: str

EVAL_DATASET = [
    EvalCase("What is the capital of France?", "Paris", "factual"),
    EvalCase("Summarize: AI is transforming...", None, "summarization"),  # LLM-judged
]

def evaluate_factual(response: str, expected: str) -> float:
    """Exact match score for factual questions."""
    return 1.0 if expected.lower() in response.lower() else 0.0

def evaluate_with_judge(input_text: str, response: str, criteria: str) -> float:
    """Use an LLM judge for subjective quality assessment."""
    judge_response = judge_llm.complete(
        system="Rate the response quality from 0.0 to 1.0. Return only the number.",
        prompt=f"Input: {input_text}\nResponse: {response}\nCriteria: {criteria}",
    )
    return float(judge_response.strip())

def run_evaluation(model_fn) -> dict:
    scores = {"factual": [], "summarization": []}

    for case in EVAL_DATASET:
        response = model_fn(case.input)

        if case.expected:
            score = evaluate_factual(response, case.expected)
        else:
            score = evaluate_with_judge(case.input, response, case.category)

        scores[case.category].append(score)

    return {cat: sum(s) / len(s) for cat, s in scores.items() if s}
```
