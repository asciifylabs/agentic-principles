# Write Unit Tests with pytest

> Use pytest as your testing framework for clean, powerful tests with minimal boilerplate and excellent tooling.

## Rules

- Use pytest instead of unittest for new projects (cleaner syntax, better fixtures)
- Name test files `test_*.py` or `*_test.py` and functions `test_*`
- Use pytest fixtures for setup and teardown instead of classes
- Use `@pytest.mark.parametrize` to test multiple inputs without repeating code
- Mock external dependencies using `unittest.mock` or `pytest-mock`
- Organize tests in a `tests/` directory mirroring your source structure
- Run tests in CI/CD and aim for >80% code coverage
- Use `pytest-cov` for coverage reports and `pytest-xdist` for parallel execution

## Example

```python
# tests/test_calculator.py

import pytest
from myapp.calculator import add, divide

# Simple test
def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0

# Parametrized test
@pytest.mark.parametrize("a,b,expected", [
    (2, 3, 5),
    (0, 0, 0),
    (-1, 1, 0),
    (100, 200, 300),
])
def test_add_parametrized(a, b, expected):
    assert add(a, b) == expected

# Test exceptions
def test_divide_by_zero():
    with pytest.raises(ZeroDivisionError):
        divide(10, 0)

# Using fixtures
@pytest.fixture
def sample_data():
    """Fixture providing test data."""
    return {"users": [{"id": 1, "name": "Alice"}]}

def test_with_fixture(sample_data):
    assert len(sample_data["users"]) == 1
    assert sample_data["users"][0]["name"] == "Alice"

# Mocking external calls
from unittest.mock import patch

def test_api_call(mocker):
    mock_response = mocker.Mock()
    mock_response.json.return_value = {"status": "ok"}
    mocker.patch("requests.get", return_value=mock_response)

    result = fetch_api_data()
    assert result["status"] == "ok"
```

**pytest.ini:**

```ini
[pytest]
testpaths = tests
python_files = test_*.py
python_functions = test_*
addopts = --cov=myapp --cov-report=html
```
