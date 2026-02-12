# Use Comprehensions Appropriately

> Prefer list/dict/set comprehensions over loops for simple transformations, but use regular loops for complex logic.

## Rules

- Use comprehensions for simple map and filter operations that fit on one readable line
- Switch to regular loops when logic becomes complex or nested
- Prefer generator expressions for large datasets to save memory
- Use dict comprehensions for transforming dictionaries
- Avoid deeply nested comprehensions (more than 2 levels)
- Never sacrifice readability for brevity; loops are perfectly fine
- Use walrus operator `:=` in comprehensions to avoid duplicate computation (Python 3.8+)

## Example

```python
# Bad: complex logic in comprehension
results = [
    process(x) for x in data
    if x.active and x.status == "valid"
    and x.timestamp > cutoff
    and validate(x)
]

# Good: use a loop for complex logic
results = []
for x in data:
    if not x.active:
        continue
    if x.status != "valid" or x.timestamp <= cutoff:
        continue
    if not validate(x):
        continue
    results.append(process(x))

# Good: simple transformations
squares = [x ** 2 for x in range(10)]
active_users = [u for u in users if u.is_active]
name_map = {u.id: u.name for u in users}

# Good: generator for large datasets
total = sum(x ** 2 for x in range(1_000_000))  # Memory efficient

# Good: walrus operator to avoid duplicate work
if results := [x for x in data if (processed := process(x)) is not None]:
    use_results(results)
```
