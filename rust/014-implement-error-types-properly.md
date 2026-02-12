# Implement Error Types Properly

> Create custom error types with `thiserror` or `anyhow` for clear, composable error handling.

## Rules

- Use `thiserror` for library error types
- Use `anyhow` for application error handling
- Implement `std::error::Error` trait for custom errors
- Use `#[error]` attribute with `thiserror` for display messages
- Use `#[from]` attribute for automatic error conversions
- Provide context with error chains using `.context()`
- Make errors actionable by including relevant information

## Example

```rust
// Using thiserror for library errors
use thiserror::Error;

#[derive(Error, Debug)]
pub enum ConfigError {
    #[error("Configuration file not found: {path}")]
    FileNotFound { path: String },

    #[error("Invalid configuration: {0}")]
    InvalidConfig(String),

    #[error("Parse error at line {line}: {message}")]
    ParseError { line: usize, message: String },

    #[error(transparent)]
    IoError(#[from] std::io::Error),

    #[error(transparent)]
    ParseIntError(#[from] std::num::ParseIntError),
}

pub fn load_config(path: &str) -> Result<Config, ConfigError> {
    let contents = std::fs::read_to_string(path)
        .map_err(|_| ConfigError::FileNotFound {
            path: path.to_string(),
        })?;

    parse_config(&contents)
}

fn parse_config(contents: &str) -> Result<Config, ConfigError> {
    if contents.is_empty() {
        return Err(ConfigError::InvalidConfig(
            "Config file is empty".to_string(),
        ));
    }

    // Parse and return config...
    Ok(Config::default())
}

// Using anyhow for applications
use anyhow::{Context, Result};

fn run_app() -> Result<()> {
    let config = load_config("config.toml")
        .context("Failed to load configuration")?;

    let connection = connect_database(&config.db_url)
        .context("Failed to connect to database")?;

    process_data(connection)
        .context("Failed to process data")?;

    Ok(())
}

fn main() {
    if let Err(e) = run_app() {
        eprintln!("Error: {:?}", e);
        // Prints full error chain:
        // Error: Failed to load configuration
        // Caused by:
        //     Configuration file not found: config.toml
        std::process::exit(1);
    }
}

// Custom error with context
#[derive(Error, Debug)]
pub enum DatabaseError {
    #[error("Connection failed: {0}")]
    ConnectionFailed(String),

    #[error("Query failed: {query}")]
    QueryFailed {
        query: String,
        #[source]
        source: sqlx::Error,
    },

    #[error("User not found: {id}")]
    UserNotFound { id: u64 },
}

pub async fn get_user(pool: &PgPool, id: u64) -> Result<User, DatabaseError> {
    sqlx::query_as!(User, "SELECT * FROM users WHERE id = $1", id as i64)
        .fetch_one(pool)
        .await
        .map_err(|e| DatabaseError::QueryFailed {
            query: format!("SELECT * FROM users WHERE id = {}", id),
            source: e,
        })?
        .ok_or(DatabaseError::UserNotFound { id })
}

// Error with multiple causes
#[derive(Error, Debug)]
pub enum AppError {
    #[error("Configuration error")]
    Config(#[from] ConfigError),

    #[error("Database error")]
    Database(#[from] DatabaseError),

    #[error("Network error")]
    Network(#[from] reqwest::Error),

    #[error("IO error")]
    Io(#[from] std::io::Error),
}

// Combining errors in application
fn complex_operation() -> Result<(), AppError> {
    // Errors automatically converted to AppError
    let config = load_config("config.toml")?;
    let user = get_user(&pool, 42).await?;
    let response = reqwest::get("https://api.example.com").await?;

    Ok(())
}

// Manual error implementation
#[derive(Debug)]
pub struct ValidationError {
    pub field: String,
    pub message: String,
}

impl std::fmt::Display for ValidationError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "Validation failed for {}: {}", self.field, self.message)
    }
}

impl std::error::Error for ValidationError {}

// Error with backtrace (nightly feature)
use std::backtrace::Backtrace;

#[derive(Debug)]
pub struct DetailedError {
    message: String,
    backtrace: Backtrace,
}

impl DetailedError {
    pub fn new(message: impl Into<String>) -> Self {
        Self {
            message: message.into(),
            backtrace: Backtrace::capture(),
        }
    }
}

impl std::fmt::Display for DetailedError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.message)
    }
}

impl std::error::Error for DetailedError {
    fn backtrace(&self) -> Option<&Backtrace> {
        Some(&self.backtrace)
    }
}
```

**Cargo.toml:**

```toml
[dependencies]
thiserror = "1.0"
anyhow = "1.0"
```
