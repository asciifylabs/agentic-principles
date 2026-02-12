# Prefer &str Over String for Parameters

> Accept `&str` in function parameters instead of `String` or `&String` for maximum flexibility.

## Rules

- Use `&str` for function parameters that only read strings
- Use `String` only when the function needs ownership
- Use `&mut String` when the function needs to modify the string
- Never use `&String` as a parameter (use `&str` instead)
- Use `impl AsRef<str>` or `impl Into<String>` for even more flexibility
- Return `String` for owned data, `&str` for borrowed data
- Use `.as_str()` to convert `&String` to `&str`

## Example

```rust
// Bad: takes String (requires ownership)
fn print_message(msg: String) {
    println!("{}", msg);
}
// Caller must give up ownership or clone
let message = String::from("hello");
print_message(message);  // message moved
// print_message(message);  // ERROR: already moved

// Bad: takes &String (unnecessarily specific)
fn print_message(msg: &String) {
    println!("{}", msg);
}
// Can't call with &str
let msg = "hello";
// print_message(&msg);  // ERROR: expected &String

// Good: takes &str (most flexible)
fn print_message(msg: &str) {
    println!("{}", msg);
}
// Works with both &str and &String
print_message("hello");                     // &str literal
print_message(&String::from("hello"));      // &String
print_message(&message);                    // &String
let s = String::from("hello");
print_message(&s);                          // &String
print_message(s.as_str());                  // &str

// When to use String parameter
fn take_ownership(s: String) -> String {
    // Function needs ownership to modify or store
    format!("{} world", s)
}

// When to use &mut String
fn append_world(s: &mut String) {
    s.push_str(" world");
}

// Even more flexible: accept anything string-like
fn print_flexible(msg: impl AsRef<str>) {
    println!("{}", msg.as_ref());
}

print_flexible("hello");               // &str
print_flexible(String::from("hello")); // String
print_flexible(&String::from("hello"));// &String

// For functions that need to store the string
fn store_message(msg: impl Into<String>) -> StoredMessage {
    StoredMessage {
        content: msg.into(),
    }
}

store_message("hello");               // &str -> String
store_message(String::from("hello")); // String

// Return types
// Return &str when returning a reference
fn get_name<'a>(user: &'a User) -> &'a str {
    &user.name
}

// Return String when returning owned data
fn build_greeting(name: &str) -> String {
    format!("Hello, {}!", name)
}

// Pattern: builder that accepts flexible strings
struct ConfigBuilder {
    host: String,
    database: String,
}

impl ConfigBuilder {
    fn host(mut self, host: impl Into<String>) -> Self {
        self.host = host.into();
        self
    }

    fn database(mut self, db: impl Into<String>) -> Self {
        self.database = db.into();
        self
    }

    fn build(self) -> Config {
        Config {
            host: self.host,
            database: self.database,
        }
    }
}

// Usage - very flexible
let config = ConfigBuilder::default()
    .host("localhost")                    // &str
    .database(String::from("mydb"))       // String
    .build();

// Comparing string types
fn compare_strings(a: &str, b: &str) -> bool {
    a == b
}

let s1 = "hello";
let s2 = String::from("hello");
let s3 = "hello".to_string();

assert!(compare_strings(s1, &s2));
assert!(compare_strings(&s2, &s3));

// Converting between types
let owned = String::from("hello");
let borrowed: &str = &owned;
let borrowed2: &str = owned.as_str();

// Common patterns
// Bad: unnecessary cloning
fn process_bad(input: &String) -> String {
    let s = input.clone();  // Unnecessary clone
    s.to_uppercase()
}

// Good: borrow what you need
fn process_good(input: &str) -> String {
    input.to_uppercase()  // No clone needed
}

// Method chaining with strings
fn build_query(table: &str, filter: &str) -> String {
    format!("SELECT * FROM {} WHERE {}", table, filter)
}

// Works with any string type
build_query("users", "active = true");
build_query(&String::from("users"), &String::from("active = true"));
```

**Summary:**

- **&str**: Read-only access, most flexible
- **String**: Need ownership
- **&mut String**: Need to modify in place
- **&String**: Never use (use &str instead)
- **impl Into<String>**: Builder patterns
- **impl AsRef<str>**: Maximum flexibility
