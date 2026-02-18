# Implement Function Calling Safely

> When giving LLMs access to tools and functions, validate every argument, enforce permissions, and limit scope — the model decides what to call, but your code must enforce what is allowed.

## Rules

- Validate all function arguments from the model against strict schemas before execution — never trust the model's output as safe input
- Implement an allowlist of callable functions — never let the model invoke arbitrary functions or system commands
- Apply the principle of least privilege: each tool should have the minimum permissions needed for its purpose
- Sanitize function arguments that will be used in database queries, file paths, shell commands, or network requests
- Set execution timeouts for tool calls to prevent runaway operations
- Log every function call with its arguments, result, and execution time for auditability
- Implement confirmation flows for destructive or irreversible actions (delete, send, purchase) — require human approval
- Handle function call errors gracefully and return structured error messages the model can understand and react to
- Limit the number of sequential function calls per turn to prevent infinite tool-calling loops

## Example

```python
# Bad: executing arbitrary function calls from the model
def handle_tool_call(name, args):
    func = globals()[name]  # Dangerous: model can call ANY function
    return func(**args)

# Good: allowlisted tools with validation and limits
from pydantic import BaseModel, Field

class SearchArgs(BaseModel):
    query: str = Field(max_length=200)
    limit: int = Field(default=10, ge=1, le=50)

class SendEmailArgs(BaseModel):
    to: str = Field(pattern=r"^[^@]+@[^@]+\.[^@]+$")
    subject: str = Field(max_length=200)
    body: str = Field(max_length=5000)

ALLOWED_TOOLS = {
    "search_docs": {"fn": search_docs, "schema": SearchArgs, "needs_confirmation": False},
    "send_email": {"fn": send_email, "schema": SendEmailArgs, "needs_confirmation": True},
}
MAX_TOOL_CALLS_PER_TURN = 10

def handle_tool_call(name: str, raw_args: dict, call_count: int) -> dict:
    if call_count >= MAX_TOOL_CALLS_PER_TURN:
        return {"error": "Maximum tool calls reached for this turn"}

    if name not in ALLOWED_TOOLS:
        return {"error": f"Unknown tool: {name}"}

    tool = ALLOWED_TOOLS[name]

    try:
        validated_args = tool["schema"](**raw_args)
    except ValidationError as e:
        return {"error": f"Invalid arguments: {e}"}

    if tool["needs_confirmation"]:
        return {"status": "awaiting_confirmation", "tool": name, "args": validated_args.dict()}

    result = tool["fn"](**validated_args.dict())
    logger.info("tool_executed", tool=name, args=validated_args.dict())
    return {"result": result}
```
