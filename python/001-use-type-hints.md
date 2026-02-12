# Use Type Hints

> Always use type hints to make code self-documenting, enable static type checking, and catch bugs before runtime.

## Rules

- Annotate all function parameters and return types with type hints
- Use `Optional[T]` for values that can be None, or use `T | None` in Python 3.10+
- Use generics like `list[str]`, `dict[str, int]` for container types (3.9+)
- Use `Protocol` from typing for structural subtyping (duck typing with types)
- Configure mypy in your project and run it in CI/CD pipelines
- Use `TypeAlias` for complex type expressions to improve readability
- Avoid using `Any` unless absolutely necessary; it defeats type checking

## Example

```python
# Bad: no type hints
def process_users(users, filter_active):
    result = []
    for user in users:
        if filter_active and user["active"]:
            result.append(user["name"])
    return result

# Good: with type hints
from typing import TypeAlias

UserDict: TypeAlias = dict[str, str | bool]

def process_users(
    users: list[UserDict],
    filter_active: bool = False
) -> list[str]:
    result: list[str] = []
    for user in users:
        if filter_active and user.get("active"):
            result.append(str(user["name"]))
    return result
```

**mypy.ini:**

```ini
[mypy]
python_version = 3.10
warn_return_any = True
warn_unused_configs = True
disallow_untyped_defs = True
```
