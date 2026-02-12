# Write Comprehensive Tests

> Write unit tests, integration tests, and documentation tests to ensure code correctness and maintainability.

## Rules

- Write unit tests in the same file using `#[cfg(test)]` module
- Put integration tests in `tests/` directory
- Use `#[test]` attribute for test functions
- Use `assert!`, `assert_eq!`, and `assert_ne!` for assertions
- Test error cases with `#[should_panic]` or `Result<(), Error>`
- Write documentation tests in doc comments
- Use `cargo test` to run all tests

## Example

```rust
// src/calculator.rs
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

pub fn divide(a: i32, b: i32) -> Result<i32, String> {
    if b == 0 {
        Err("Division by zero".to_string())
    } else {
        Ok(a / b)
    }
}

// Unit tests in same file
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(add(2, 3), 5);
        assert_eq!(add(-1, 1), 0);
        assert_eq!(add(0, 0), 0);
    }

    #[test]
    fn test_divide_success() {
        assert_eq!(divide(10, 2).unwrap(), 5);
        assert_eq!(divide(0, 5).unwrap(), 0);
    }

    #[test]
    fn test_divide_by_zero() {
        assert!(divide(10, 0).is_err());
    }

    // Alternative: test with Result
    #[test]
    fn test_divide_result() -> Result<(), String> {
        assert_eq!(divide(10, 2)?, 5);
        Ok(())
    }

    // Test that should panic
    #[test]
    #[should_panic(expected = "Division by zero")]
    fn test_panics() {
        divide(10, 0).unwrap();
    }

    // Ignored test (run with --ignored)
    #[test]
    #[ignore]
    fn expensive_test() {
        // Long-running test
    }
}
```

**Integration tests:**

```rust
// tests/integration_test.rs
use myapp::Calculator;

#[test]
fn test_calculator_integration() {
    let calc = Calculator::new();
    assert_eq!(calc.compute("2 + 3"), 5);
}

// Test helper module
mod common;

#[test]
fn test_with_helpers() {
    let data = common::setup();
    assert!(data.is_valid());
}
```

**Documentation tests:**

````rust
/// Adds two numbers together.
///
/// # Examples
///
/// ```
/// use myapp::add;
///
/// assert_eq!(add(2, 3), 5);
/// ```
///
/// # Panics
///
/// This function doesn't panic.
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

/// Divides two numbers.
///
/// # Errors
///
/// Returns an error if `b` is zero.
///
/// ```
/// use myapp::divide;
///
/// assert!(divide(10, 2).is_ok());
/// assert!(divide(10, 0).is_err());
/// ```
pub fn divide(a: i32, b: i32) -> Result<i32, Error> {
    if b == 0 {
        return Err(Error::DivisionByZero);
    }
    Ok(a / b)
}
````

**Test organization:**

```rust
// Use test fixtures
#[cfg(test)]
mod tests {
    use super::*;

    fn setup() -> TestData {
        TestData {
            users: vec![
                User::new(1, "Alice"),
                User::new(2, "Bob"),
            ],
        }
    }

    #[test]
    fn test_with_fixture() {
        let data = setup();
        assert_eq!(data.users.len(), 2);
    }
}
```

**Running tests:**

```bash
# Run all tests
cargo test

# Run specific test
cargo test test_add

# Run tests with output
cargo test -- --nocapture

# Run ignored tests
cargo test -- --ignored

# Run tests with specific thread count
cargo test -- --test-threads=1

# Run doc tests only
cargo test --doc
```
