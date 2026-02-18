# Version Your Prompts

> Treat prompts as code — store them in version control, tag releases, and track changes to ensure reproducibility and safe iteration.

## Rules

- Store all prompts in dedicated files or a prompt registry, never inline as string literals scattered across the codebase
- Use version identifiers (semantic versioning or hashes) for every prompt template deployed to production
- Track prompt changes in version control with meaningful commit messages describing what changed and why
- Maintain a changelog for prompts that affect critical business logic or user-facing outputs
- Deploy prompt updates independently from code changes when possible — use feature flags or config-driven loading
- Run evaluation suites against new prompt versions before promoting them to production
- Keep a rollback path: retain previous prompt versions so you can revert instantly if quality degrades
- Never modify a production prompt without testing — treat prompt changes with the same rigor as code changes

## Example

```python
# Bad: hardcoded prompt buried in application code
def summarize(text):
    response = client.messages.create(
        model="claude-sonnet-4-5-20250929",
        messages=[{"role": "user", "content": f"Summarize: {text}"}],
    )
    return response.content[0].text

# Good: versioned prompt loaded from a registry
PROMPTS = {
    "summarize": {
        "version": "2.1.0",
        "system": "You are a concise summarizer. Output 2-3 sentences max.",
        "template": """<document>
{document}
</document>

Summarize the document above. Focus on key findings and conclusions.""",
    }
}

def summarize(text: str, prompt_version: str = "summarize") -> str:
    prompt = PROMPTS[prompt_version]
    logger.info("prompt_used", version=prompt["version"], name=prompt_version)

    response = client.messages.create(
        model="claude-sonnet-4-5-20250929",
        system=prompt["system"],
        messages=[{"role": "user", "content": prompt["template"].format(document=text)}],
    )
    return response.content[0].text
```
