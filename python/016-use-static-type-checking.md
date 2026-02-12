# Use Static Type Checking

> Run mypy or pyright in CI/CD to catch type errors before runtime and improve code quality.

## Rules

- Configure mypy or pyright in your project and run it in pre-commit hooks and CI/CD
- Enable strict mode gradually: start with basic checks, increase strictness over time
- Use type hints on all public functions and methods
- Add `# type: ignore` comments sparingly and only when necessary (with explanation)
- Use stub files (`.pyi`) for third-party libraries without type hints
- Configure your IDE (VS Code, PyCharm) to show type errors in real-time
- Use `reveal_type()` in mypy to debug complex type inference issues

## Example

```python
# mypy will catch these errors at check time, not runtime

# Error: incompatible types
def greet(name: str) -> str:
    return f"Hello {name}"

result: int = greet("Alice")  # mypy error: Expected int, got str

# Error: missing return
def calculate(x: int) -> int:
    if x > 0:
        return x * 2
    # mypy error: Missing return statement

# Good: properly typed code
from typing import TypedDict

class UserDict(TypedDict):
    id: int
    name: str
    email: str

def process_user(user: UserDict) -> str:
    """Process user and return summary."""
    return f"User {user['name']} ({user['email']})"

# mypy catches dict key errors
user: UserDict = {"id": 1, "name": "Alice"}  # Error: missing 'email'
```

**mypy.ini:**

```ini
[mypy]
python_version = 3.10
warn_return_any = True
warn_unused_configs = True
disallow_untyped_defs = True
disallow_any_unimported = True
no_implicit_optional = True
warn_redundant_casts = True
warn_unused_ignores = True
warn_no_return = True
check_untyped_defs = True
```

**Run in CI:**

```bash
# Pre-commit hook
mypy src/

# Or with pyright
pyright src/
```
