# Use Lifetimes When Necessary

> Add lifetime annotations when the compiler needs help understanding reference validity, but let lifetime elision work when possible.

## Rules

- Let the compiler infer lifetimes when possible (lifetime elision)
- Add explicit lifetimes when holding references in structs
- Use `'static` for references that live for the entire program
- Name lifetimes descriptively when there are multiple
- Understand the three lifetime elision rules
- Use lifetime bounds with generics when needed
- Keep lifetime relationships simple and understandable

## Example

```rust
// Lifetime elision - compiler infers lifetimes
// No annotation needed for simple cases
fn first_word(s: &str) -> &str {
    s.split_whitespace().next().unwrap_or("")
}

// Explicit lifetime when needed
// Multiple input lifetimes, unclear which output relates to
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

// Struct with lifetime
struct User<'a> {
    name: &'a str,
    email: &'a str,
}

impl<'a> User<'a> {
    fn new(name: &'a str, email: &'a str) -> Self {
        Self { name, email }
    }

    // Method with lifetime
    fn name(&self) -> &str {
        self.name  // Elided lifetime: same as &'a str
    }
}

// Multiple lifetimes
struct Context<'a, 'b> {
    data: &'a str,
    config: &'b Config,
}

fn process<'a, 'b>(ctx: &Context<'a, 'b>) -> &'a str {
    ctx.data
}

// 'static lifetime - lives for entire program
const CONSTANT: &'static str = "I live forever";

fn get_static_str() -> &'static str {
    "This is a 'static str literal"
}

// Lifetime bounds with generics
fn process_data<'a, T>(data: &'a T) -> &'a T
where
    T: std::fmt::Debug,
{
    println!("{:?}", data);
    data
}

// Complex lifetime relationships
struct Parser<'a> {
    input: &'a str,
    position: usize,
}

impl<'a> Parser<'a> {
    fn new(input: &'a str) -> Self {
        Parser { input, position: 0 }
    }

    // Output lifetime tied to self
    fn peek(&self) -> Option<&'a str> {
        if self.position < self.input.len() {
            Some(&self.input[self.position..])
        } else {
            None
        }
    }
}

// Lifetime elision rules
// 1. Each reference parameter gets its own lifetime
// 2. If one input lifetime, it's assigned to all output lifetimes
// 3. If &self or &mut self, its lifetime is assigned to outputs

// Rule 1 & 2: one input lifetime
fn example1(s: &str) -> &str {  // Elided
    s
}
// Expands to:
fn example1_explicit<'a>(s: &'a str) -> &'a str {
    s
}

// Rule 3: self lifetime
impl User {
    fn name(&self) -> &str {  // Elided
        &self.name
    }
}
// Expands to:
impl User {
    fn name<'a>(&'a self) -> &'a str {
        &self.name
    }
}

// When explicit lifetimes are needed
// Different output lifetime relationships
fn choose<'a, 'b>(
    first: &'a str,
    _second: &'b str,
    use_first: bool,
) -> &'a str {
    // Output only related to first parameter
    if use_first {
        first
    } else {
        first  // Can't return second due to lifetime
    }
}

// Lifetime subtyping
fn parse_until<'a, 'b>(input: &'a str, delimiter: &'b str) -> &'a str
where
    'a: 'b,  // 'a outlives 'b
{
    // Implementation
    input
}

// Common lifetime errors
// Error: returning reference to local variable
fn dangle() -> &String {
    let s = String::from("hello");
    &s  // ERROR: s dropped here
}

// Fix: return owned value
fn no_dangle() -> String {
    let s = String::from("hello");
    s  // OK: ownership transferred
}

// Error: conflicting lifetimes
fn problematic<'a>(x: &'a str, y: &str) -> &'a str {
    // Cannot mix 'a and elided lifetime
    if x.len() > y.len() {
        x
    } else {
        y  // ERROR: y has different lifetime
    }
}

// Fix: same lifetime for both
fn fixed<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y  // OK: both have 'a
    }
}
```
