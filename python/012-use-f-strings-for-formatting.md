# Use f-strings for Formatting

> Use f-strings (formatted string literals) for string formatting instead of %-formatting or `.format()` for cleaner, faster code.

## Rules

- Always use f-strings for string interpolation in Python 3.6+
- Avoid old-style %-formatting (`"Hello %s" % name`) unless maintaining legacy code
- Avoid `.format()` method unless you need to separate format string from values
- Use f-string debugging syntax `f"{variable=}"` to print variable name and value
- Format numbers, dates, and floats inline: `f"{value:.2f}"`, `f"{dt:%Y-%m-%d}"`
- Use raw f-strings `fr"..."` or `rf"..."` when combining with regex patterns
- For extremely large or dynamic strings, consider `str.join()` instead

## Example

```python
# Bad: old-style formatting
name = "Alice"
age = 30
message = "Hello %s, you are %d years old" % (name, age)
price = "Price: $%.2f" % 19.99

# Bad: .format() method
message = "Hello {}, you are {} years old".format(name, age)

# Good: f-strings
message = f"Hello {name}, you are {age} years old"
price = f"Price: ${19.99:.2f}"

# Good: f-string debugging (Python 3.8+)
x = 10
y = 20
print(f"{x=}, {y=}, {x+y=}")  # Output: x=10, y=20, x+y=30

# Good: formatting numbers and dates
from datetime import datetime
pi = 3.14159
now = datetime.now()
print(f"Pi to 2 decimals: {pi:.2f}")
print(f"Today: {now:%Y-%m-%d %H:%M}")

# Good: multiline f-strings
report = f"""
User Report:
  Name: {user.name}
  Status: {user.status}
  Last login: {user.last_login:%Y-%m-%d}
"""
```
