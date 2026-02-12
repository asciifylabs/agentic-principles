# Use Traits for Shared Behavior

> Define traits to specify shared behavior and enable polymorphism through trait objects and generics.

## Rules

- Use traits to define shared interfaces across types
- Implement standard library traits (`Debug`, `Clone`, `Display`, etc.)
- Use trait bounds to constrain generic types
- Prefer trait bounds over trait objects when performance matters
- Use `dyn Trait` for trait objects with dynamic dispatch
- Implement custom traits for domain-specific behavior
- Use associated types in traits for type-level programming

## Example

```rust
// Define a custom trait
pub trait Summary {
    fn summarize(&self) -> String;

    // Default implementation
    fn preview(&self) -> String {
        format!("{}...", &self.summarize()[..50])
    }
}

// Implement trait for types
pub struct Article {
    pub title: String,
    pub content: String,
}

impl Summary for Article {
    fn summarize(&self) -> String {
        format!("{}: {}", self.title, self.content)
    }
}

pub struct Tweet {
    pub username: String,
    pub content: String,
}

impl Summary for Tweet {
    fn summarize(&self) -> String {
        format!("@{}: {}", self.username, self.content)
    }

    // Override default implementation
    fn preview(&self) -> String {
        format!("@{}...", self.username)
    }
}

// Function with trait bound
fn print_summary<T: Summary>(item: &T) {
    println!("{}", item.summarize());
}

// Multiple trait bounds
fn process<T: Summary + Clone>(item: &T) {
    let copy = item.clone();
    println!("{}", copy.summarize());
}

// Where clause for complex bounds
fn complex_function<T, U>(t: &T, u: &U)
where
    T: Summary + Clone,
    U: Summary + Display,
{
    // Function body
}

// Trait objects for dynamic dispatch
fn print_summaries(items: Vec<Box<dyn Summary>>) {
    for item in items {
        println!("{}", item.summarize());
    }
}

// Usage with trait objects
let summaries: Vec<Box<dyn Summary>> = vec![
    Box::new(Article {
        title: "News".to_string(),
        content: "Content".to_string(),
    }),
    Box::new(Tweet {
        username: "user".to_string(),
        content: "Tweet".to_string(),
    }),
];
print_summaries(summaries);

// Associated types in traits
pub trait Iterator {
    type Item;

    fn next(&mut self) -> Option<Self::Item>;
}

pub struct Counter {
    count: u32,
}

impl Iterator for Counter {
    type Item = u32;

    fn next(&mut self) -> Option<Self::Item> {
        self.count += 1;
        Some(self.count)
    }
}

// Derive common traits
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Point {
    x: i32,
    y: i32,
}

// Implement Display manually
use std::fmt;

impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

// Trait with associated functions
pub trait Factory {
    fn create() -> Self;
}

impl Factory for Point {
    fn create() -> Self {
        Point { x: 0, y: 0 }
    }
}

// Usage
let point = Point::create();
```
