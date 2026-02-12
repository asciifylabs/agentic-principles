# Handle Exceptions Properly

> Catch specific exceptions, provide meaningful context, and ensure proper cleanup to make errors debuggable and systems resilient.

## Rules

- Always catch specific exceptions, never use bare `except:` clauses
- Use `finally` blocks for cleanup code that must run regardless of exceptions
- Re-raise exceptions with additional context using `raise ... from` to preserve the stack trace
- Log exceptions with full context before handling or re-raising
- Never silently ignore exceptions unless explicitly intended (document why)
- Use custom exception classes for domain-specific errors
- Prefer EAFP (Easier to Ask for Forgiveness than Permission) over LBYL (Look Before You Leap)

## Example

```python
# Bad: catching all exceptions without context
def load_config(path):
    try:
        f = open(path)
        return json.load(f)
    except:
        return {}

# Good: specific exceptions with context
import logging
from pathlib import Path
from typing import Any

logger = logging.getLogger(__name__)

class ConfigError(Exception):
    """Raised when configuration cannot be loaded."""
    pass

def load_config(path: Path) -> dict[str, Any]:
    """Load configuration from JSON file."""
    try:
        with open(path) as f:
            return json.load(f)
    except FileNotFoundError as e:
        logger.error(f"Config file not found: {path}")
        raise ConfigError(f"Cannot find config at {path}") from e
    except json.JSONDecodeError as e:
        logger.error(f"Invalid JSON in config: {path}, line {e.lineno}")
        raise ConfigError(f"Invalid JSON in {path}") from e
    except Exception as e:
        logger.exception(f"Unexpected error loading config: {path}")
        raise
```
