# Follow Rust API Guidelines

> Adhere to Rust API Guidelines for consistent, idiomatic, and ergonomic APIs.

## Rules

- Use `snake_case` for functions, variables, modules; `CamelCase` for types
- Name getters without `get_` prefix (`.name()` not `.get_name()`)
- Use `_mut` suffix for mutable variants (`.iter()` and `.iter_mut()`)
- Return borrowed data from getters, not owned clones
- Implement common traits: `Debug`, `Clone`, `Default`, `PartialEq`
- Use `IntoIterator` for types that can be iterated
- Accept `impl Trait` or generics for flexibility in parameters

## Example

```rust
// Bad: non-idiomatic naming
pub struct UserData {
    user_id: u64,
    user_name: String,
}

impl UserData {
    pub fn get_name(&self) -> String {
        self.user_name.clone() // Unnecessary clone
    }

    pub fn GetId(&self) -> u64 { // Wrong case
        self.user_id
    }
}

// Good: idiomatic naming and borrowing
pub struct User {
    id: u64,
    name: String,
}

impl User {
    pub fn new(id: u64, name: String) -> Self {
        Self { id, name }
    }

    // Getter without get_ prefix
    pub fn name(&self) -> &str {
        &self.name // Return borrowed data
    }

    pub fn id(&self) -> u64 {
        self.id
    }
}

// Implement common traits
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Point {
    pub x: i32,
    pub y: i32,
}

impl Default for Point {
    fn default() -> Self {
        Self { x: 0, y: 0 }
    }
}

// Mutable and immutable variants
pub struct Container {
    items: Vec<String>,
}

impl Container {
    pub fn iter(&self) -> impl Iterator<Item = &String> {
        self.items.iter()
    }

    pub fn iter_mut(&mut self) -> impl Iterator<Item = &mut String> {
        self.items.iter_mut()
    }
}

// Accept impl Trait for flexibility
pub fn process_items(items: impl IntoIterator<Item = String>) {
    for item in items {
        println!("{}", item);
    }
}

// Can be called with Vec, array, iterator, etc.
process_items(vec!["a".to_string(), "b".to_string()]);
process_items(["a".to_string(), "b".to_string()]);

// Builder pattern for complex construction
pub struct Config {
    host: String,
    port: u16,
    timeout: Duration,
}

impl Config {
    pub fn builder() -> ConfigBuilder {
        ConfigBuilder::default()
    }
}

pub struct ConfigBuilder {
    host: String,
    port: u16,
    timeout: Duration,
}

impl Default for ConfigBuilder {
    fn default() -> Self {
        Self {
            host: "localhost".to_string(),
            port: 8080,
            timeout: Duration::from_secs(30),
        }
    }
}

impl ConfigBuilder {
    pub fn host(mut self, host: impl Into<String>) -> Self {
        self.host = host.into();
        self
    }

    pub fn port(mut self, port: u16) -> Self {
        self.port = port;
        self
    }

    pub fn build(self) -> Config {
        Config {
            host: self.host,
            port: self.port,
            timeout: self.timeout,
        }
    }
}

// Usage
let config = Config::builder()
    .host("example.com")
    .port(443)
    .build();
```
