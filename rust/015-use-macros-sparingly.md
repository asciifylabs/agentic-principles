# Use Macros Sparingly

> Use macros only when functions and generics are insufficient; prefer simple, maintainable code over macro magic.

## Rules

- Use functions or generics first; macros as last resort
- Use declarative macros (`macro_rules!`) for simple patterns
- Use procedural macros for derive, attributes, and function-like macros
- Document macro inputs and outputs clearly
- Keep macros simple and focused on one task
- Use `cargo expand` to inspect macro expansions
- Test macros thoroughly with various inputs

## Example

```rust
// When NOT to use macros
// Bad: macro for simple function
macro_rules! add {
    ($a:expr, $b:expr) => {
        $a + $b
    };
}

// Good: just use a function
fn add(a: i32, b: i32) -> i32 {
    a + b
}

// When macros are appropriate
// Good: reducing boilerplate for similar code
macro_rules! impl_from_str {
    ($type:ty) => {
        impl std::str::FromStr for $type {
            type Err = String;

            fn from_str(s: &str) -> Result<Self, Self::Err> {
                s.parse().map_err(|e| format!("Parse error: {}", e))
            }
        }
    };
}

impl_from_str!(UserId);
impl_from_str!(OrderId);

// Declarative macro with repetition
macro_rules! vec_of_strings {
    ($($x:expr),* $(,)?) => {
        vec![$($x.to_string()),*]
    };
}

let strings = vec_of_strings!["hello", "world"];

// Pattern matching in macros
macro_rules! calculate {
    (add $a:expr, $b:expr) => {
        $a + $b
    };
    (sub $a:expr, $b:expr) => {
        $a - $b
    };
    (mul $a:expr, $b:expr) => {
        $a * $b
    };
}

let result = calculate!(add 10, 5);
let result = calculate!(mul 10, 5);

// Custom derive procedural macro
// In separate crate: my-derive
use proc_macro::TokenStream;
use quote::quote;
use syn;

#[proc_macro_derive(Builder)]
pub fn derive_builder(input: TokenStream) -> TokenStream {
    let input = syn::parse_macro_input!(input as syn::DeriveInput);
    let name = &input.ident;

    let expanded = quote! {
        impl #name {
            pub fn builder() -> #name Builder {
                #name Builder::default()
            }
        }
    };

    TokenStream::from(expanded)
}

// Usage
#[derive(Builder)]
struct User {
    name: String,
    age: u32,
}

let user = User::builder()
    .name("Alice".to_string())
    .age(30)
    .build();

// Attribute macro
#[proc_macro_attribute]
pub fn log_calls(attr: TokenStream, item: TokenStream) -> TokenStream {
    let input = syn::parse_macro_input!(item as syn::ItemFn);
    let name = &input.sig.ident;

    let expanded = quote! {
        #input

        // Log function calls
        println!("Calling {}", stringify!(#name));
    };

    TokenStream::from(expanded)
}

// Usage
#[log_calls]
fn my_function() {
    println!("Function body");
}

// Debugging macros
// Use cargo expand to see macro output
// $ cargo install cargo-expand
// $ cargo expand

// Testing macros
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_vec_of_strings() {
        let result = vec_of_strings!["a", "b", "c"];
        assert_eq!(result, vec!["a", "b", "c"]);
    }

    #[test]
    fn test_calculate_macro() {
        assert_eq!(calculate!(add 5, 3), 8);
        assert_eq!(calculate!(sub 10, 3), 7);
        assert_eq!(calculate!(mul 4, 5), 20);
    }
}

// Built-in macros to use
println!("Print with newline");
eprintln!("Print to stderr");
format!("Create formatted string: {}", value);
vec![1, 2, 3];
assert_eq!(a, b);
assert!(condition);
panic!("Unrecoverable error");
todo!("Not yet implemented");
unimplemented!("Function stub");
unreachable!("Should never reach here");
dbg!(variable); // Debug print

// Conditional compilation
#[cfg(target_os = "linux")]
fn platform_specific() {
    // Linux-specific code
}

#[cfg(test)]
mod tests {
    // Test-only code
}
```

**When to use macros:**

- Reducing repetitive boilerplate (derive macros)
- Domain-specific languages (DSLs)
- Conditional compilation
- Generating code at compile time

**When NOT to use macros:**

- Simple logic that functions can handle
- Type conversions (use traits)
- Code organization (use modules)
- Runtime behavior (use functions)
