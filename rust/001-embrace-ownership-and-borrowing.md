# Embrace Ownership and Borrowing

> Understand and leverage Rust's ownership system to write memory-safe code without garbage collection.

## Rules

- Each value has exactly one owner at a time
- Use borrowing (`&T`) for read-only access, mutable borrowing (`&mut T`) for write access
- Cannot have mutable and immutable borrows simultaneously
- References must always be valid (no dangling pointers)
- Use `.clone()` explicitly when you need ownership of data
- Prefer borrowing over cloning for performance
- Let the compiler guide you to correct ownership patterns

## Example

```rust
// Bad: trying to use value after move
fn main() {
    let s = String::from("hello");
    take_ownership(s);
    println!("{}", s); // ERROR: s moved
}

fn take_ownership(s: String) {
    println!("{}", s);
}

// Good: borrowing instead of moving
fn main() {
    let s = String::from("hello");
    borrow_value(&s);
    println!("{}", s); // OK: s still owned here
}

fn borrow_value(s: &str) {
    println!("{}", s);
}

// Good: returning ownership
fn main() {
    let s = String::from("hello");
    let s = append_world(s);
    println!("{}", s); // OK: got ownership back
}

fn append_world(mut s: String) -> String {
    s.push_str(" world");
    s
}

// Mutable borrowing
fn main() {
    let mut data = vec![1, 2, 3];
    modify_data(&mut data); // Mutable borrow
    println!("{:?}", data); // [1, 2, 3, 4]
}

fn modify_data(data: &mut Vec<i32>) {
    data.push(4);
}

// Cannot have simultaneous mutable and immutable borrows
fn main() {
    let mut s = String::from("hello");
    let r1 = &s;     // OK: immutable borrow
    let r2 = &s;     // OK: multiple immutable borrows
    // let r3 = &mut s; // ERROR: cannot borrow as mutable while immutably borrowed
    println!("{} {}", r1, r2);

    let r3 = &mut s; // OK: immutable borrows no longer used
    r3.push_str(" world");
}
```
