# Follow PEP 8 Style Guide

> Adhere to PEP 8 style conventions for consistent, readable Python code that follows community standards.

## Rules

- Use 4 spaces for indentation (never tabs)
- Limit lines to 88 characters (Black formatter default) or 79 (PEP 8 strict)
- Use `snake_case` for functions and variables, `PascalCase` for classes, `UPPER_CASE` for constants
- Use 2 blank lines between top-level definitions, 1 blank line between methods
- Import order: standard library, third-party, local (separated by blank lines)
- Use Black formatter and Ruff linter to automatically enforce style
- Configure pre-commit hooks to run formatters before each commit

## Example

```python
# Bad: inconsistent style
import os,sys
from myapp import helpers

class myClass:
  def doSomething(self,x,y):
      return x+y

# Good: PEP 8 compliant
import os
import sys

from myapp import helpers


class MyClass:
    """A class that does something."""

    def do_something(self, x: int, y: int) -> int:
        """Add two numbers together."""
        return x + y
```

**pyproject.toml:**

```toml
[tool.black]
line-length = 88
target-version = ['py310']

[tool.ruff]
line-length = 88
select = ["E", "F", "I"]
```
