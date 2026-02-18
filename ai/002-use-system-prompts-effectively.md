# Use System Prompts Effectively

> Define the model's role, constraints, and output expectations in the system prompt to get consistent, high-quality results across all interactions.

## Rules

- Always use a system prompt to set the model's persona, task boundaries, and output format — never rely on the user message alone
- Place immutable instructions (role, constraints, formatting rules) in the system prompt and variable content in user messages
- Be explicit about what the model should and should not do — vague instructions produce inconsistent results
- Structure complex system prompts with clear sections: role, context, task, constraints, output format
- Use delimiters (XML tags, markdown headers) to separate sections within the system prompt
- Keep system prompts as concise as possible while being unambiguous — every token costs money and dilutes attention
- Test system prompts with adversarial inputs to verify the model follows constraints under pressure
- Document the intent behind each system prompt alongside the prompt itself

## Example

```python
# Bad: no system prompt, all instructions in user message
response = client.messages.create(
    model="claude-sonnet-4-5-20250929",
    messages=[{
        "role": "user",
        "content": "You are a helpful assistant. Be concise. Extract the name and email. John Doe john@example.com"
    }],
)

# Good: clear system prompt with structured sections
SYSTEM_PROMPT = """You are a data extraction specialist.

<constraints>
- Extract only the fields requested — do not infer or fabricate data
- If a field is not present in the input, return null for that field
- Always respond with valid JSON matching the requested schema
- Never include explanations or commentary outside the JSON output
</constraints>

<output_format>
{"name": "string", "email": "string | null"}
</output_format>"""

response = client.messages.create(
    model="claude-sonnet-4-5-20250929",
    max_tokens=256,
    system=SYSTEM_PROMPT,
    messages=[{
        "role": "user",
        "content": "Extract name and email from: John Doe (john@example.com)"
    }],
)
```
