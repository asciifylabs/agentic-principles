# Implement Proper Prompt Engineering

> Structure prompts with clear instructions, examples, and templates to get consistent, high-quality outputs from LLMs.

## Rules

- Use system prompts to set context and behavior, user prompts for specific requests
- Separate instructions from data using clear delimiters (XML tags, markdown sections)
- Implement few-shot examples to show the desired output format
- Use prompt templates with variables instead of string concatenation
- Be specific and explicit in instructions; avoid ambiguity
- Structure complex prompts with clear sections: context, task, constraints, format
- Test and iterate on prompts; version control your prompt templates

## Example

```python
# Bad: unclear, unstructured prompt
def summarize(text):
    prompt = f"Summarize this: {text}"
    return llm.complete(prompt)

# Good: structured prompt with clear sections
from string import Template

SUMMARIZE_TEMPLATE = Template("""You are a professional summarizer.

<document>
$document
</document>

Task: Create a concise summary of the document above.

Requirements:
- Maximum 3 sentences
- Focus on key points only
- Use clear, professional language

Summary:""")

def summarize(document: str) -> str:
    """Summarize document with structured prompt."""
    prompt = SUMMARIZE_TEMPLATE.substitute(document=document)
    return llm.complete(prompt)

# Better: using system prompts and few-shot examples
from anthropic import Anthropic

SYSTEM_PROMPT = """You are an expert data extractor. Extract structured information from text.
Always respond with valid JSON matching the requested schema."""

FEW_SHOT_EXAMPLES = [
    {
        "role": "user",
        "content": "Extract name and email from: John Doe (john@example.com)"
    },
    {
        "role": "assistant",
        "content": '{"name": "John Doe", "email": "john@example.com"}'
    }
]

def extract_contact(text: str) -> dict:
    """Extract contact information using few-shot prompting."""
    client = Anthropic()

    messages = FEW_SHOT_EXAMPLES + [
        {"role": "user", "content": f"Extract name and email from: {text}"}
    ]

    response = client.messages.create(
        model="claude-3-5-sonnet-20241022",
        max_tokens=1024,
        system=SYSTEM_PROMPT,
        messages=messages
    )

    return json.loads(response.content[0].text)

# Best: using prompt templates with validation
from pydantic import BaseModel
from typing import Literal

class ExtractionPrompt(BaseModel):
    """Validated prompt template."""
    document: str
    extraction_type: Literal["contact", "product", "event"]
    output_format: str = "json"

    def render(self) -> str:
        """Render validated prompt."""
        return f"""<document>
{self.document}
</document>

Extract {self.extraction_type} information from the document.
Return valid {self.output_format} only."""

prompt = ExtractionPrompt(
    document="Call Jane at 555-0100",
    extraction_type="contact"
)
```
