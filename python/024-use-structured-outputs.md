# Use Structured Outputs

> Use JSON mode, function calling, or Pydantic schemas to get reliable, parseable responses instead of parsing free-form text.

## Rules

- Use structured output modes (JSON mode, function calling) when available
- Define clear schemas with Pydantic models for validation and parsing
- Prefer structured outputs over regex parsing of natural language responses
- Handle validation errors gracefully and retry with clarified prompts
- Use schema descriptions to guide the model toward correct output format
- Implement fallback parsing for when structured outputs fail
- Version your schemas and handle schema evolution

## Example

```python
# Bad: parsing unstructured text
def extract_person(text):
    response = llm.complete(f"Extract person's name and age from: {text}")
    # Now parse "John Doe is 30 years old" or "Name: John, Age: 30" or...
    # Fragile and error-prone!

# Good: using JSON mode with Pydantic
from pydantic import BaseModel, Field
from openai import OpenAI
import json

class Person(BaseModel):
    """Structured person data."""
    name: str = Field(..., description="Full name of the person")
    age: int = Field(..., ge=0, le=150, description="Age in years")
    email: str | None = Field(None, description="Email address if available")

def extract_person(text: str) -> Person:
    """Extract person data with structured output."""
    client = OpenAI()

    response = client.chat.completions.create(
        model="gpt-4-turbo-preview",
        response_format={"type": "json_object"},
        messages=[
            {
                "role": "system",
                "content": f"Extract person information. Return JSON matching schema: {Person.schema_json()}"
            },
            {
                "role": "user",
                "content": text
            }
        ]
    )

    data = json.loads(response.choices[0].message.content)
    return Person(**data)  # Validates against schema

# Better: using function calling for guaranteed structure
def extract_person_with_function_calling(text: str) -> Person:
    """Extract person using function calling."""
    client = OpenAI()

    tools = [{
        "type": "function",
        "function": {
            "name": "record_person",
            "description": "Record information about a person",
            "parameters": {
                "type": "object",
                "properties": {
                    "name": {"type": "string", "description": "Full name"},
                    "age": {"type": "integer", "description": "Age in years"},
                    "email": {"type": "string", "description": "Email address"}
                },
                "required": ["name", "age"]
            }
        }
    }]

    response = client.chat.completions.create(
        model="gpt-4-turbo-preview",
        messages=[{"role": "user", "content": f"Extract person info: {text}"}],
        tools=tools,
        tool_choice={"type": "function", "function": {"name": "record_person"}}
    )

    function_args = json.loads(
        response.choices[0].message.tool_calls[0].function.arguments
    )
    return Person(**function_args)

# Best: using Anthropic structured outputs (tools)
from anthropic import Anthropic

def extract_person_anthropic(text: str) -> Person:
    """Extract person using Anthropic tool use."""
    client = Anthropic()

    response = client.messages.create(
        model="claude-3-5-sonnet-20241022",
        max_tokens=1024,
        tools=[{
            "name": "record_person",
            "description": "Record structured person information",
            "input_schema": {
                "type": "object",
                "properties": {
                    "name": {"type": "string", "description": "Full name"},
                    "age": {"type": "integer", "description": "Age in years"},
                    "email": {"type": "string", "description": "Email if available"}
                },
                "required": ["name", "age"]
            }
        }],
        messages=[{"role": "user", "content": f"Extract: {text}"}]
    )

    tool_use = next(
        block for block in response.content
        if block.type == "tool_use"
    )

    return Person(**tool_use.input)

# Usage with error handling
try:
    person = extract_person("John Doe, 30 years old, john@example.com")
    print(f"Extracted: {person.name}, age {person.age}")
except ValidationError as e:
    logger.error(f"Invalid person data: {e}")
```
