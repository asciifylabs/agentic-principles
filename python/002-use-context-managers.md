# Use Context Managers

> Always use context managers with the `with` statement for resource management to ensure proper cleanup even when errors occur.

## Rules

- Use `with` statements for all file operations, database connections, and network resources
- Create custom context managers using `@contextmanager` decorator or `__enter__/__exit__` methods
- Handle exceptions properly in `__exit__` method; return `True` to suppress, `False` to propagate
- Use `contextlib.ExitStack` for managing multiple context managers dynamically
- Never manually call `open()` and `close()` when a context manager is available
- Prefer context managers over try/finally blocks for resource cleanup

## Example

```python
# Bad: manual resource management
def read_file(path):
    f = open(path)
    data = f.read()
    f.close()  # Might not execute if read() raises
    return data

# Good: using context manager
def read_file(path: str) -> str:
    with open(path) as f:
        return f.read()

# Good: custom context manager
from contextlib import contextmanager
import time

@contextmanager
def timer(name: str):
    start = time.time()
    try:
        yield
    finally:
        elapsed = time.time() - start
        print(f"{name} took {elapsed:.2f}s")

with timer("data processing"):
    process_large_dataset()
```
