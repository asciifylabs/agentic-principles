# Validate and Sanitize All Inputs

> Treat all external input as untrusted — validate format, type, length, and range at system boundaries before processing.

## Rules

- Validate all inputs at the system boundary: HTTP request bodies, query parameters, headers, file uploads, CLI arguments, environment variables
- Use an allowlist approach (accept known-good) rather than a denylist approach (reject known-bad)
- Validate data type, length, range, and format before any processing
- Reject invalid input immediately with a clear error — do not attempt to "fix" malformed data silently
- Use schema validation libraries (Zod, Joi, Pydantic, JSON Schema) rather than hand-written validation
- Sanitize strings that will be rendered in HTML, SQL, shell commands, or other interpreted contexts
- Validate file uploads: check MIME type, file extension, file size, and content (not just the extension)
- Never trust client-side validation alone — always re-validate on the server
- Normalize unicode and encoding before validation to prevent bypass attacks
- Set maximum sizes for all inputs: request bodies, query strings, headers, uploaded files

## Example

```typescript
// Good: schema validation with Zod
import { z } from "zod";

const CreateUserSchema = z.object({
  email: z.string().email().max(254),
  name: z.string().min(1).max(100).trim(),
  age: z.number().int().min(13).max(150),
  role: z.enum(["user", "admin"]),
});

function createUser(input: unknown) {
  const validated = CreateUserSchema.parse(input); // throws on invalid
  return db.users.create(validated);
}
```

```python
# Good: Pydantic validation
from pydantic import BaseModel, EmailStr, Field

class CreateUser(BaseModel):
    email: EmailStr
    name: str = Field(min_length=1, max_length=100)
    age: int = Field(ge=13, le=150)
    role: Literal["user", "admin"]

@app.post("/users")
def create_user(user: CreateUser):
    # Input is already validated and typed
    return db.create_user(user)
```
