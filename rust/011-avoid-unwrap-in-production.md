# Avoid unwrap in Production

> Never use `.unwrap()` or `.expect()` in production code; handle errors explicitly to prevent panics.

## Rules

- Use `.unwrap()` only in examples, tests, or prototypes
- Replace `.unwrap()` with proper error handling using `?` operator
- Use `.unwrap_or()`, `.unwrap_or_else()`, or `.unwrap_or_default()` for safe defaults
- Use pattern matching to handle `Option` and `Result` explicitly
- Use `.expect()` only when failure is truly impossible (with clear message)
- Enable clippy lint `unwrap_used` to catch unwrap usage
- Return `Result` from functions that can fail

## Example

```rust
// Bad: unwrap panics on None or Err
fn process_data(path: &str) -> String {
    let contents = std::fs::read_to_string(path).unwrap(); // Panics on error!
    let data = parse_data(&contents).unwrap(); // Panics on error!
    data.name
}

// Good: propagate errors with ?
fn process_data(path: &str) -> Result<String, Box<dyn std::error::Error>> {
    let contents = std::fs::read_to_string(path)?;
    let data = parse_data(&contents)?;
    Ok(data.name)
}

// Good: provide safe defaults
fn get_config_value(key: &str) -> String {
    std::env::var(key).unwrap_or_else(|_| "default".to_string())
}

fn get_timeout() -> u64 {
    std::env::var("TIMEOUT")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(30) // Safe default
}

// Good: pattern matching for explicit handling
fn find_user(id: u64) -> Option<User> {
    // ...
}

match find_user(42) {
    Some(user) => println!("Found: {}", user.name),
    None => println!("User not found"),
}

// Or with if let
if let Some(user) = find_user(42) {
    println!("Found: {}", user.name);
} else {
    println!("User not found");
}

// Acceptable: expect with clear message when failure is impossible
fn main() {
    let config_path = std::env::var("CONFIG_PATH")
        .expect("CONFIG_PATH must be set"); // OK: clear requirement

    // Parse at compile time - can't fail at runtime
    let addr: SocketAddr = "127.0.0.1:8080"
        .parse()
        .expect("Hard-coded address is valid");
}

// Bad: chaining unwraps
let value = map.get("key").unwrap().parse::<i32>().unwrap();

// Good: early returns with ?
fn get_value(map: &HashMap<String, String>, key: &str) -> Result<i32, Error> {
    let value_str = map.get(key).ok_or(Error::KeyNotFound)?;
    let value = value_str.parse()?;
    Ok(value)
}

// Good: use ok_or to convert Option to Result
fn lookup(key: &str) -> Result<String, Error> {
    database
        .get(key)
        .ok_or(Error::NotFound)?
        .clone()
}

// Safe alternatives to unwrap
// unwrap_or - provide default value
let value = some_option.unwrap_or(0);

// unwrap_or_else - compute default lazily
let value = some_option.unwrap_or_else(|| expensive_computation());

// unwrap_or_default - use Default trait
let vec: Vec<i32> = some_option.unwrap_or_default();

// Cargo.toml - enable clippy lint
[lints.clippy]
unwrap_used = "deny"
expect_used = "warn"

// Handle multiple Results
fn load_config() -> Result<Config, Error> {
    let host = std::env::var("HOST")?;
    let port = std::env::var("PORT")?.parse()?;
    let db_url = std::env::var("DATABASE_URL")?;

    Ok(Config { host, port, db_url })
}
```
