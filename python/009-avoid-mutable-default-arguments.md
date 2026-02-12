# Avoid Mutable Default Arguments

> Never use mutable objects (lists, dicts, sets) as default function arguments; use None and create the object inside the function.

## Rules

- Never use `[]`, `{}`, or `set()` as default arguments
- Use `None` as the default and create the mutable object in the function body
- Understand that default arguments are evaluated once at function definition time, not each call
- Use immutable defaults only: `None`, `True`, `False`, numbers, strings, tuples
- This is one of Python's most common gotchas that leads to surprising behavior
- Linters like Ruff and Pylint will warn about mutable default arguments

## Example

```python
# Bad: mutable default argument
def add_item(item: str, items: list[str] = []) -> list[str]:
    items.append(item)
    return items

# This produces unexpected behavior:
first = add_item("apple")   # ["apple"]
second = add_item("banana")  # ["apple", "banana"] - SURPRISE!
# Both calls share the same list object!

# Good: use None and create inside function
def add_item(item: str, items: list[str] | None = None) -> list[str]:
    if items is None:
        items = []
    items.append(item)
    return items

# Now it works correctly:
first = add_item("apple")   # ["apple"]
second = add_item("banana")  # ["banana"]

# Good: another pattern with default factory
def process_data(data: dict[str, str] | None = None) -> dict[str, str]:
    if data is None:
        data = {}
    # Process data...
    return data
```
