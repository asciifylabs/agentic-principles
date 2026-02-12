# Use Result and Option for Error Handling

> Use `Result<T, E>` for operations that can fail and `Option<T>` for values that may be absent instead of exceptions or null.

## Rules

- Return `Result<T, E>` from functions that can fail
- Use `Option<T>` for values that may or may not exist
- Use the `?` operator to propagate errors concisely
- Avoid `.unwrap()` in production code; use proper error handling
- Use `.expect()` only when failure is truly impossible
- Implement custom error types with `thiserror` or `anyhow`
- Use pattern matching to handle different error cases

## Example

```rust
use std::fs::File;
use std::io::{self, Read};

// Bad: unwrap panics on error
fn read_file_bad(path: &str) -> String {
    let mut file = File::open(path).unwrap(); // Panics!
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    contents
}

// Good: propagate errors with Result
fn read_file(path: &str) -> Result<String, io::Error> {
    let mut file = File::open(path)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    Ok(contents)
}

// Good: handle errors explicitly
fn main() {
    match read_file("config.txt") {
        Ok(contents) => println!("File contents: {}", contents),
        Err(e) => eprintln!("Failed to read file: {}", e),
    }
}

// Using Option for nullable values
fn find_user(id: u64, users: &[User]) -> Option<&User> {
    users.iter().find(|u| u.id == id)
}

fn main() {
    let users = vec![User { id: 1, name: "Alice" }];

    match find_user(1, &users) {
        Some(user) => println!("Found: {}", user.name),
        None => println!("User not found"),
    }

    // Or use if let
    if let Some(user) = find_user(1, &users) {
        println!("Found: {}", user.name);
    }
}

// Custom error types with thiserror
use thiserror::Error;

#[derive(Error, Debug)]
pub enum ConfigError {
    #[error("File not found: {0}")]
    FileNotFound(String),

    #[error("Parse error: {0}")]
    ParseError(String),

    #[error(transparent)]
    IoError(#[from] std::io::Error),
}

fn load_config(path: &str) -> Result<Config, ConfigError> {
    let contents = std::fs::read_to_string(path)
        .map_err(|_| ConfigError::FileNotFound(path.to_string()))?;

    parse_config(&contents)
        .map_err(|e| ConfigError::ParseError(e.to_string()))
}

// Acceptable: expect with explanation
fn main() {
    let config = std::env::var("CONFIG_PATH")
        .expect("CONFIG_PATH environment variable must be set");
}
```
