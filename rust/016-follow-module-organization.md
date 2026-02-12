# Follow Module Organization

> Organize code into modules with clear visibility rules for maintainable, well-structured projects.

## Rules

- One module per file or use `mod.rs` for directories
- Use `pub` to export items from modules
- Use `pub(crate)` for crate-internal visibility
- Use `pub(super)` for parent-module visibility
- Organize modules by feature or domain, not by type
- Put unit tests in the same file with `#[cfg(test)]`
- Put integration tests in `tests/` directory

## Example

```
myapp/
├── Cargo.toml
├── src/
│   ├── main.rs
│   ├── lib.rs
│   ├── config/
│   │   ├── mod.rs       # or config.rs
│   │   └── parser.rs
│   ├── database/
│   │   ├── mod.rs
│   │   ├── postgres.rs
│   │   └── migrations.rs
│   ├── models/
│   │   ├── mod.rs
│   │   ├── user.rs
│   │   └── order.rs
│   └── api/
│       ├── mod.rs
│       ├── handlers.rs
│       └── middleware.rs
└── tests/
    ├── integration_test.rs
    └── common/
        └── mod.rs
```

**lib.rs - Crate root:**

```rust
// Public modules
pub mod config;
pub mod models;
pub mod api;

// Private module
mod database;

// Re-export commonly used items
pub use models::{User, Order};
pub use config::Config;

// Crate-internal utilities
pub(crate) mod utils;
```

**models/mod.rs:**

```rust
// Declare submodules
mod user;
mod order;

// Re-export public items
pub use user::User;
pub use order::Order;

// Module-private items
pub(super) fn internal_helper() {
    // Only visible to parent module
}
```

**models/user.rs:**

```rust
// Public struct
#[derive(Debug, Clone)]
pub struct User {
    pub id: u64,
    pub name: String,
    email: String,  // Private field
}

impl User {
    // Public constructor
    pub fn new(id: u64, name: String, email: String) -> Self {
        Self { id, name, email }
    }

    // Public method
    pub fn email(&self) -> &str {
        &self.email
    }

    // Crate-internal method
    pub(crate) fn validate(&self) -> bool {
        !self.name.is_empty() && self.email.contains('@')
    }

    // Private helper
    fn normalize_name(&mut self) {
        self.name = self.name.trim().to_string();
    }
}

// Unit tests in same file
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_user_creation() {
        let user = User::new(1, "Alice".to_string(), "alice@example.com".to_string());
        assert_eq!(user.name, "Alice");
    }

    #[test]
    fn test_validation() {
        let user = User::new(1, "Alice".to_string(), "alice@example.com".to_string());
        assert!(user.validate());
    }
}
```

**database/mod.rs:**

```rust
mod postgres;
mod migrations;

// Conditional compilation
#[cfg(feature = "postgres")]
pub use postgres::PostgresConnection;

#[cfg(feature = "sqlite")]
pub use sqlite::SqliteConnection;

// Trait for database abstraction
pub trait Database {
    fn connect(&self, url: &str) -> Result<Connection, Error>;
    fn execute(&self, query: &str) -> Result<(), Error>;
}
```

**config/mod.rs:**

```rust
mod parser;

use std::path::Path;

#[derive(Debug, Clone)]
pub struct Config {
    pub database_url: String,
    pub port: u16,
}

impl Config {
    pub fn from_file(path: impl AsRef<Path>) -> Result<Self, Error> {
        parser::parse_config_file(path)
    }

    pub(crate) fn validate(&self) -> Result<(), Error> {
        // Validation logic
        Ok(())
    }
}
```

**main.rs:**

```rust
use myapp::{Config, User, api};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Load config
    let config = Config::from_file("config.toml")?;

    // Start server
    api::start_server(config)?;

    Ok(())
}
```

**tests/integration_test.rs:**

```rust
// Integration test
use myapp::{Config, User};

#[test]
fn test_full_workflow() {
    let config = Config::from_file("test_config.toml").unwrap();
    let user = User::new(1, "Alice".to_string(), "alice@example.com".to_string());

    // Test full application workflow
    assert!(user.email().contains('@'));
}
```

**tests/common/mod.rs - Shared test utilities:**

```rust
// Helper functions for integration tests
pub fn setup_test_db() -> Database {
    // Setup code
}

pub fn teardown_test_db(db: Database) {
    // Cleanup code
}
```

**Visibility modifiers:**

```rust
pub fn public_function() {}           // Public to everyone
pub(crate) fn crate_function() {}     // Public within crate
pub(super) fn parent_function() {}    // Public to parent module
fn private_function() {}              // Private to this module

pub struct PublicStruct {
    pub public_field: i32,
    pub(crate) crate_field: i32,
    private_field: i32,
}
```
