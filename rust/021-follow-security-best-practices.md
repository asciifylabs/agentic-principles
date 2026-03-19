# Follow Security Best Practices

> Write Rust code that leverages the type system and ecosystem tools to prevent common security vulnerabilities.

## Rules

- Use `cargo audit` to check dependencies for known vulnerabilities
- Minimize `unsafe` blocks; document safety invariants with `// SAFETY:` comments
- Validate and sanitize all external input before processing
- Use parameterized queries with `sqlx` or `diesel`; never build SQL with `format!`
- Use `secrecy::Secret<T>` to prevent accidental logging of sensitive values
- Set timeouts on all network operations to prevent resource exhaustion
- Use `cargo-deny` to enforce license compliance and ban problematic crates
- Pin dependencies with `Cargo.lock` and review updates before merging

## Example

```rust
// Bad: SQL injection, no input validation, secret in logs
fn get_user(name: &str) -> Result<User> {
    let query = format!("SELECT * FROM users WHERE name = '{}'", name);
    let password = "hunter2";
    log::info!("Authenticating with password: {}", password);
    db.query(&query)
}

// Good: parameterized query, input validation, secret protection
use secrecy::{ExposeSecret, Secret};
use sqlx::query_as;

fn get_user(pool: &PgPool, name: &str) -> Result<User> {
    // Validate input
    if name.len() > 255 || name.contains('\0') {
        return Err(Error::InvalidInput("invalid username"));
    }

    // Parameterized query
    query_as!(User, "SELECT * FROM users WHERE name = $1", name)
        .fetch_one(pool)
        .await
}

fn authenticate(password: Secret<String>) -> Result<()> {
    // Secret is redacted in Debug/Display output
    log::info!("Authenticating user"); // password not logged
    verify_hash(password.expose_secret())
}
```

```bash
# Audit dependencies for vulnerabilities
cargo audit

# Check for banned crates, duplicate deps, license issues
cargo deny check
```
