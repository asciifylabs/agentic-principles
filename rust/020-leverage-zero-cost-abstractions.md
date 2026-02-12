# Leverage Zero-Cost Abstractions

> Use Rust's high-level abstractions knowing they compile to efficient low-level code with no runtime overhead.

## Rules

- Use iterators instead of manual loops (same performance, better readability)
- Trust that generics have zero runtime cost (monomorphization)
- Use enums and pattern matching freely (optimized away)
- Leverage trait abstractions without worrying about virtual dispatch overhead
- Use newtype patterns for type safety at no runtime cost
- Prefer high-level code; the compiler optimizes it to machine code
- Profile before optimizing; don't assume abstractions are slow

## Example

```rust
// Iterators vs loops - same performance
// Both compile to identical machine code

// Manual loop
fn sum_manual(numbers: &[i32]) -> i32 {
    let mut sum = 0;
    for i in 0..numbers.len() {
        sum += numbers[i];
    }
    sum
}

// Iterator (zero-cost abstraction)
fn sum_iterator(numbers: &[i32]) -> i32 {
    numbers.iter().sum()
}

// Complex iterator chains - still zero cost
fn process_data(numbers: &[i32]) -> Vec<i32> {
    numbers
        .iter()
        .filter(|&&x| x > 0)
        .map(|&x| x * 2)
        .take(10)
        .collect()
}

// Generics - monomorphization (separate copy per type)
// No runtime overhead, no dynamic dispatch
fn print_value<T: std::fmt::Display>(value: T) {
    println!("{}", value);
}

// Compiler generates specialized versions:
// print_value::<i32>(42)       - one version for i32
// print_value::<String>(s)     - one version for String

// Newtype pattern - zero runtime cost
struct UserId(u64);
struct OrderId(u64);

fn process_user(id: UserId) {
    // Type safety at compile time, zero cost at runtime
    // UserId and u64 have identical memory layout
}

// Can't mix up IDs due to type system
let user_id = UserId(42);
let order_id = OrderId(100);
// process_user(order_id); // ERROR: type mismatch

// Enums - optimized memory layout
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
}

// Compiler optimizes to smallest possible size
// Pattern matching compiles to jump tables or switches
fn handle_message(msg: Message) {
    match msg {
        Message::Quit => quit(),
        Message::Move { x, y } => move_to(x, y),
        Message::Write(s) => write_message(s),
    }
}

// Option and Result - zero cost
// Compiler optimizes null pointer checks
fn divide(a: i32, b: i32) -> Option<i32> {
    if b == 0 {
        None
    } else {
        Some(a / b)
    }
}

// match on Option compiles to efficient null check
fn use_result(result: Option<i32>) {
    match result {
        Some(value) => println!("{}", value),
        None => println!("No value"),
    }
}

// Static dispatch (zero cost)
trait Calculate {
    fn calculate(&self, x: i32) -> i32;
}

struct Doubler;
impl Calculate for Doubler {
    fn calculate(&self, x: i32) -> i32 {
        x * 2
    }
}

// Monomorphized - compiler knows exact type
fn process<C: Calculate>(calc: &C, value: i32) {
    let result = calc.calculate(value);
    // Direct call, no vtable lookup
}

// Dynamic dispatch (has small cost)
fn process_dyn(calc: &dyn Calculate, value: i32) {
    let result = calc.calculate(value);
    // Virtual call through vtable
}

// Inline functions - zero overhead
#[inline]
fn add(a: i32, b: i32) -> i32 {
    a + b
}

// #[inline(always)] for critical hot paths
#[inline(always)]
fn critical_function() {
    // This will always be inlined
}

// Const evaluation - computed at compile time
const BUFFER_SIZE: usize = 1024 * 1024;
const MAX_USERS: usize = compute_max_users();

const fn compute_max_users() -> usize {
    1000 * 100  // Computed at compile time
}

// Smart pointers - efficient
// Box<T> is just a pointer (size of usize)
fn use_box() {
    let value = Box::new(42);  // Heap allocation
    // Single pointer on stack, no overhead
}

// Rc<T> is pointer + reference count
// Arc<T> is pointer + atomic reference count

// Trait objects - when you need dynamic dispatch
fn process_shapes(shapes: Vec<Box<dyn Shape>>) {
    for shape in shapes {
        shape.draw();  // Dynamic dispatch
    }
}
// Use when you need heterogeneous collections
// Small cost: vtable lookup per call

// Benchmarking to verify zero cost
#[cfg(test)]
mod benches {
    use super::*;

    #[bench]
    fn bench_manual_loop(b: &mut test::Bencher) {
        let numbers: Vec<i32> = (1..1000).collect();
        b.iter(|| sum_manual(&numbers));
    }

    #[bench]
    fn bench_iterator(b: &mut test::Bencher) {
        let numbers: Vec<i32> = (1..1000).collect();
        b.iter(|| sum_iterator(&numbers));
    }
    // Results should be identical or very close
}

// Closure optimization
fn apply_operation<F>(numbers: &[i32], op: F) -> Vec<i32>
where
    F: Fn(i32) -> i32,
{
    numbers.iter().map(|&x| op(x)).collect()
}

// Closure inlined - no function call overhead
let doubled = apply_operation(&[1, 2, 3], |x| x * 2);

// Match optimization
fn categorize(value: i32) -> &'static str {
    match value {
        0..=10 => "small",
        11..=100 => "medium",
        _ => "large",
    }
    // Compiles to efficient range checks
}

// Type state pattern - compile-time guarantees
struct Unlocked;
struct Locked;

struct Door<State> {
    state: PhantomData<State>,
}

impl Door<Unlocked> {
    fn lock(self) -> Door<Locked> {
        Door { state: PhantomData }
    }
}

impl Door<Locked> {
    fn unlock(self) -> Door<Unlocked> {
        Door { state: PhantomData }
    }
}

// Type system prevents invalid operations
// PhantomData has zero size - no runtime cost
```

**Key takeaways:**

- Write idiomatic, high-level code
- Compiler optimizes abstractions to machine code
- Use iterators, generics, and enums freely
- Profile first, optimize later
- Trust the compiler's optimizer
- Zero-cost doesn't mean zero assembly - it means no overhead vs hand-written low-level code
