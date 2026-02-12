# Use Pattern Matching

> Leverage Rust's powerful pattern matching for expressive, safe, and exhaustive conditional logic.

## Rules

- Use `match` for exhaustive pattern matching on enums
- Use `if let` for matching single patterns
- Use `while let` for loops with pattern matching
- Use `let` bindings with patterns for destructuring
- Use `@` bindings to capture values while matching
- Use guards for additional conditions in match arms
- Compiler enforces exhaustiveness; handle all cases

## Example

```rust
// Exhaustive enum matching
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(u8, u8, u8),
}

fn process_message(msg: Message) {
    match msg {
        Message::Quit => println!("Quit"),
        Message::Move { x, y } => println!("Move to ({}, {})", x, y),
        Message::Write(text) => println!("Write: {}", text),
        Message::ChangeColor(r, g, b) => println!("Color: rgb({}, {}, {})", r, g, b),
    }
    // Compiler ensures all variants handled
}

// Match with Option
fn divide(a: i32, b: i32) -> Option<i32> {
    if b == 0 {
        None
    } else {
        Some(a / b)
    }
}

match divide(10, 2) {
    Some(result) => println!("Result: {}", result),
    None => println!("Cannot divide by zero"),
}

// if let for single pattern
if let Some(result) = divide(10, 2) {
    println!("Result: {}", result);
}

// while let for loops
let mut stack = vec![1, 2, 3];
while let Some(top) = stack.pop() {
    println!("{}", top);
}

// Destructuring in let bindings
let point = (3, 5);
let (x, y) = point;

let user = User {
    name: "Alice".to_string(),
    age: 30,
};
let User { name, age } = user;

// Match with guards
fn categorize(n: i32) -> &'static str {
    match n {
        n if n < 0 => "negative",
        0 => "zero",
        n if n < 10 => "small positive",
        n if n < 100 => "medium positive",
        _ => "large positive",
    }
}

// @ bindings to capture and match
enum Status {
    Active { user_id: u64 },
    Inactive,
}

match status {
    Status::Active { user_id: id @ 100..=999 } => {
        println!("VIP user {}", id);
    }
    Status::Active { user_id } => {
        println!("Regular user {}", user_id);
    }
    Status::Inactive => println!("Inactive"),
}

// Match with references
let reference = &Some(5);
match reference {
    Some(val) => println!("Got: {}", val),
    None => println!("None"),
}

// Destructuring references
match reference {
    &Some(val) => println!("Got: {}", val),
    &None => println!("None"),
}

// Multiple patterns with |
match number {
    1 | 2 | 3 => println!("Small"),
    4 | 5 | 6 => println!("Medium"),
    _ => println!("Large"),
}

// Range patterns
match age {
    0..=12 => println!("Child"),
    13..=19 => println!("Teenager"),
    20..=65 => println!("Adult"),
    _ => println!("Senior"),
}

// Nested patterns
match event {
    Event::Message(Message::Write(text)) => println!("Write: {}", text),
    Event::Message(_) => println!("Other message"),
    Event::Quit => println!("Quit"),
}

// Ignoring values
let (x, _, z) = (1, 2, 3); // Ignore middle value
let (first, .., last) = (1, 2, 3, 4, 5); // Ignore middle values

match some_value {
    Some(_) => println!("Has value"),
    None => println!("None"),
}

// Match Result
match file_operation() {
    Ok(data) => process(data),
    Err(e) => eprintln!("Error: {}", e),
}
```
