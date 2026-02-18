# Detect and Mitigate Bias

> Actively test for and mitigate demographic, cultural, and representational bias in AI outputs — biased systems cause real harm and erode user trust.

## Rules

- Test AI outputs across demographic groups: vary names, genders, ethnicities, and cultural contexts in evaluation datasets to surface differential treatment
- Measure bias quantitatively: compare output distributions, sentiment scores, and recommendation rates across protected groups
- Use bias detection tools and scorers (Fairlearn, AI Fairness 360, custom bias classifiers) to automate bias checks in CI/CD
- Review training data and few-shot examples for representational balance — biased inputs produce biased outputs
- Implement bias-aware prompt design: instruct the model to avoid assumptions based on names, genders, or cultural backgrounds
- Establish a bias review process: have diverse reviewers evaluate AI outputs for harmful stereotypes before launch
- Monitor production outputs for bias drift over time — initial testing is not enough, patterns change with usage
- Document known bias limitations of your system and communicate them to users when relevant
- When bias is detected, fix it at the source (data, prompt, model selection) rather than adding post-processing filters as a band-aid

## Example

```python
# Bad: no bias testing
def screen_resume(resume_text):
    return llm.complete(f"Rate this candidate 1-10: {resume_text}")

# Good: bias-aware evaluation
BIAS_TEST_VARIANTS = [
    {"name": "James Smith", "gender": "male"},
    {"name": "Maria Garcia", "gender": "female"},
    {"name": "Wei Chen", "gender": "neutral"},
    {"name": "Aisha Johnson", "gender": "female"},
]

def test_for_bias(prompt_template: str, variants: list[dict]) -> dict:
    """Test prompt for demographic bias."""
    scores_by_group = {}

    for variant in variants:
        prompt = prompt_template.format(**variant)
        score = float(llm.complete(prompt))
        group = variant.get("gender", "unknown")
        scores_by_group.setdefault(group, []).append(score)

    # Calculate disparity
    group_means = {g: sum(s) / len(s) for g, s in scores_by_group.items()}
    max_disparity = max(group_means.values()) - min(group_means.values())

    result = {
        "group_means": group_means,
        "max_disparity": max_disparity,
        "passed": max_disparity < 1.0,  # Threshold for acceptable disparity
    }

    if not result["passed"]:
        logger.warning("bias_detected", **result)

    return result
```
