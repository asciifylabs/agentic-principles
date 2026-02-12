# Use Dataclasses

> Use `@dataclass` or Pydantic models for data structures instead of plain classes or dictionaries to get automatic methods and validation.

## Rules

- Use `@dataclass` from the standard library for simple data containers
- Use Pydantic models when you need validation, serialization, or API schemas
- Prefer dataclasses over plain classes with `__init__` boilerplate
- Use `frozen=True` for immutable dataclasses that should be hashable
- Use `field(default_factory=...)` for mutable default values
- Leverage Pydantic for configuration management and API request/response models
- Use type hints on all fields for documentation and type checking

## Example

```python
# Bad: plain class with boilerplate
class User:
    def __init__(self, id, name, email, age=None):
        self.id = id
        self.name = name
        self.email = email
        self.age = age

    def __repr__(self):
        return f"User(id={self.id}, name={self.name})"

# Good: using dataclass
from dataclasses import dataclass, field

@dataclass
class User:
    id: int
    name: str
    email: str
    age: int | None = None
    tags: list[str] = field(default_factory=list)

# Better: using Pydantic for validation
from pydantic import BaseModel, EmailStr, Field

class User(BaseModel):
    id: int = Field(..., gt=0)
    name: str = Field(..., min_length=1)
    email: EmailStr
    age: int | None = Field(None, ge=0, le=150)
    tags: list[str] = Field(default_factory=list)

# Automatic validation
try:
    user = User(id=0, name="", email="invalid")
except ValueError as e:
    print(e)  # Validation errors with details
```
