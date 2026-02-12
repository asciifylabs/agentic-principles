# Prefer Iterators Over Loops

> Use iterator methods and functional patterns instead of manual loops for more concise and often faster code.

## Rules

- Use iterator methods (`.map()`, `.filter()`, `.fold()`) over for loops
- Chain iterator methods for complex transformations
- Iterators are zero-cost abstractions (compile to same code as loops)
- Use `.collect()` to consume iterators into collections
- Use `.iter()` for borrowing, `.into_iter()` for consuming
- Avoid `.collect()` when not needed; iterators are lazy
- Use iterator adapters for efficient data processing

## Example

```rust
// Bad: manual loop
let numbers = vec![1, 2, 3, 4, 5];
let mut doubled = Vec::new();
for n in &numbers {
    doubled.push(n * 2);
}

// Good: iterator map
let doubled: Vec<_> = numbers.iter()
    .map(|n| n * 2)
    .collect();

// Bad: manual filtering and summing
let mut sum = 0;
for n in &numbers {
    if n % 2 == 0 {
        sum += n;
    }
}

// Good: iterator chain
let sum: i32 = numbers.iter()
    .filter(|n| *n % 2 == 0)
    .sum();

// Complex transformations with iterator chains
let result: Vec<_> = vec!["1", "2", "three", "4"]
    .iter()
    .filter_map(|s| s.parse::<i32>().ok())  // Parse, skip errors
    .map(|n| n * 2)                          // Double
    .filter(|n| n > &2)                      // Keep > 2
    .collect();

// fold for custom accumulation
let sum = numbers.iter().fold(0, |acc, x| acc + x);

// find for early termination
let first_even = numbers.iter().find(|&&n| n % 2 == 0);

// any/all for boolean checks
let has_even = numbers.iter().any(|&n| n % 2 == 0);
let all_positive = numbers.iter().all(|&n| n > 0);

// Borrowing vs consuming
let vec = vec![1, 2, 3];

// iter() - borrows elements
for item in vec.iter() {
    println!("{}", item); // &i32
}
// vec still valid here

// into_iter() - consumes vec
for item in vec.into_iter() {
    println!("{}", item); // i32
}
// vec moved, no longer valid

// Avoid unnecessary collect
// Bad: intermediate collection
let result = numbers.iter()
    .map(|n| n * 2)
    .collect::<Vec<_>>();  // Allocates Vec
let sum: i32 = result.iter().sum();

// Good: stay lazy
let sum: i32 = numbers.iter()
    .map(|n| n * 2)
    .sum();  // No intermediate allocation

// Efficient processing with take/skip
let first_five: Vec<_> = (1..)
    .take(5)
    .collect();

let skip_first: Vec<_> = numbers.iter()
    .skip(2)
    .collect();

// enumerate for indices
for (index, value) in numbers.iter().enumerate() {
    println!("{}: {}", index, value);
}

// zip for parallel iteration
let names = vec!["Alice", "Bob"];
let ages = vec![30, 25];

for (name, age) in names.iter().zip(ages.iter()) {
    println!("{} is {}", name, age);
}

// Custom iterators
struct Counter {
    count: u32,
}

impl Iterator for Counter {
    type Item = u32;

    fn next(&mut self) -> Option<Self::Item> {
        self.count += 1;
        if self.count <= 5 {
            Some(self.count)
        } else {
            None
        }
    }
}

let sum: u32 = Counter { count: 0 }.sum();
```
