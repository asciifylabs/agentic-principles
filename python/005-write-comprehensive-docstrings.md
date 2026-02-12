# Write Comprehensive Docstrings

> Document all modules, classes, and functions with clear docstrings following Google or NumPy style conventions.

## Rules

- Write docstrings for all public modules, classes, methods, and functions
- Use triple-quoted strings (`"""docstring"""`) even for one-line docstrings
- Follow Google or NumPy docstring format consistently across the project
- Include parameters, return types, exceptions raised, and usage examples
- Use imperative mood ("Return" not "Returns") for function descriptions
- Keep first line as a brief summary; add detailed explanation after a blank line
- Use Sphinx or MkDocs to generate documentation from docstrings

## Example

```python
# Bad: no docstring
def calculate_discount(price, discount_percent, membership_level):
    if membership_level == "gold":
        discount_percent += 10
    return price * (1 - discount_percent / 100)

# Good: comprehensive docstring
def calculate_discount(
    price: float,
    discount_percent: float,
    membership_level: str = "standard"
) -> float:
    """Calculate final price after applying discount.

    Applies the base discount percentage to the price, with an additional
    10% discount for gold members.

    Args:
        price: Original price before discount
        discount_percent: Base discount percentage (0-100)
        membership_level: Customer membership tier (standard/gold)

    Returns:
        Final price after discount applied

    Raises:
        ValueError: If price is negative or discount_percent is not in 0-100 range

    Example:
        >>> calculate_discount(100.0, 20.0, "gold")
        70.0
    """
    if price < 0 or not 0 <= discount_percent <= 100:
        raise ValueError("Invalid price or discount percentage")

    if membership_level == "gold":
        discount_percent += 10

    return price * (1 - discount_percent / 100)
```
