# Use rustfmt and clippy

> Run rustfmt for consistent formatting and clippy for catching common mistakes and suggesting improvements.

## Rules

- Run `cargo fmt` before every commit
- Configure rustfmt in `rustfmt.toml` or `.rustfmt.toml`
- Run `cargo clippy` regularly and fix warnings
- Enable clippy in CI/CD pipelines
- Use `#[allow(clippy::lint_name)]` sparingly with justification
- Configure clippy lints in `Cargo.toml` or `clippy.toml`
- Aim for zero clippy warnings in production code

## Example

**rustfmt.toml:**

```toml
edition = "2021"
max_width = 100
tab_spaces = 4
newline_style = "Unix"
use_small_heuristics = "Default"
```

**Cargo.toml - Clippy configuration:**

```toml
[lints.clippy]
# Deny common mistakes
unwrap_used = "deny"
expect_used = "warn"
panic = "deny"

# Pedantic lints
pedantic = "warn"
nursery = "warn"

# Allow some pedantic lints
module_name_repetitions = "allow"
```

```rust
// Run cargo fmt
// $ cargo fmt

// Run clippy
// $ cargo clippy

// Run clippy with all targets
// $ cargo clippy --all-targets --all-features

// Fix warnings automatically (where possible)
// $ cargo clippy --fix

// CI/CD integration
// $ cargo fmt -- --check  # Fails if not formatted
// $ cargo clippy -- -D warnings  # Treat warnings as errors
```

**Clippy examples:**

```rust
// Clippy warning: use of unwrap
let value = some_option.unwrap(); // Warning: avoid unwrap

// Better: handle the Option
let value = some_option.unwrap_or_default();
// Or use pattern matching
let value = match some_option {
    Some(v) => v,
    None => return Err(Error::MissingValue),
};

// Clippy warning: redundant clone
let s = String::from("hello");
let s2 = s.clone(); // Warning if s is not used after

// Better: move instead of clone
let s2 = s;

// Clippy warning: needless borrow
fn print_str(s: &str) {
    println!("{}", s);
}
print_str(&"hello"); // Warning: &str literal doesn't need &

// Better:
print_str("hello");

// Allow clippy lint with justification
#[allow(clippy::too_many_arguments)]
fn complex_function(
    arg1: u32, arg2: u32, arg3: u32,
    arg4: u32, arg5: u32, arg6: u32,
    arg7: u32, arg8: u32,
) {
    // Justification: Required for backward compatibility
}

// Clippy suggestion: use matches! macro
if let Some(42) = some_value {
    true
} else {
    false
}

// Better:
matches!(some_value, Some(42))

// Clippy suggestion: use if let instead of match
match some_option {
    Some(value) => process(value),
    None => {}
}

// Better:
if let Some(value) = some_option {
    process(value);
}
```

**Common clippy lints:**

- `unwrap_used`: Avoid unwrap() in production
- `expect_used`: Prefer proper error handling
- `panic`: Avoid panic!() in libraries
- `todo`: Remove TODO markers before release
- `dbg_macro`: Remove debug prints
- `print_stdout`: Avoid println! in libraries
