# Use Smart Pointers Appropriately

> Use `Box`, `Rc`, `Arc`, `RefCell`, and other smart pointers when ownership patterns require indirection or shared ownership.

## Rules

- Use `Box<T>` for heap allocation and recursive types
- Use `Rc<T>` for shared ownership in single-threaded contexts
- Use `Arc<T>` for shared ownership across threads
- Use `RefCell<T>` for interior mutability with runtime borrow checking
- Use `Mutex<T>` or `RwLock<T>` for thread-safe interior mutability
- Combine `Arc<Mutex<T>>` for shared mutable state across threads
- Avoid smart pointers when simple references suffice

## Example

```rust
use std::rc::Rc;
use std::sync::{Arc, Mutex};
use std::cell::RefCell;

// Box for heap allocation
fn box_example() {
    // Large data on heap instead of stack
    let large_data = Box::new([0u8; 1_000_000]);

    // Recursive types require indirection
    enum List {
        Cons(i32, Box<List>),
        Nil,
    }

    let list = List::Cons(1, Box::new(List::Cons(2, Box::new(List::Nil))));
}

// Rc for shared ownership (single-threaded)
fn rc_example() {
    let data = Rc::new(vec![1, 2, 3]);

    let reference1 = Rc::clone(&data); // Increment reference count
    let reference2 = Rc::clone(&data);

    println!("Reference count: {}", Rc::strong_count(&data)); // 3

    // All references can read the data
    println!("{:?}", reference1);
    println!("{:?}", reference2);
} // When last Rc drops, data is deallocated

// Arc for shared ownership (multi-threaded)
use std::thread;

fn arc_example() {
    let data = Arc::new(vec![1, 2, 3]);

    let mut handles = vec![];

    for _ in 0..3 {
        let data_clone = Arc::clone(&data);
        let handle = thread::spawn(move || {
            println!("{:?}", data_clone);
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }
}

// RefCell for interior mutability (single-threaded)
fn refcell_example() {
    let data = RefCell::new(vec![1, 2, 3]);

    // Borrow mutably at runtime
    data.borrow_mut().push(4);

    // Borrow immutably
    println!("{:?}", data.borrow());

    // Runtime panic if borrowing rules violated
    // let mut_ref = data.borrow_mut();
    // let immut_ref = data.borrow(); // PANIC: already borrowed mutably
}

// Arc<Mutex<T>> for shared mutable state across threads
fn shared_state() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter_clone = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter_clone.lock().unwrap();
            *num += 1;
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Result: {}", *counter.lock().unwrap()); // 10
}

// RwLock for read-heavy workloads
fn rwlock_example() {
    let data = Arc::new(RwLock::new(vec![1, 2, 3]));

    // Multiple readers
    let data1 = Arc::clone(&data);
    let handle1 = thread::spawn(move || {
        let vec = data1.read().unwrap();
        println!("{:?}", vec);
    });

    let data2 = Arc::clone(&data);
    let handle2 = thread::spawn(move || {
        let vec = data2.read().unwrap();
        println!("{:?}", vec);
    });

    // One writer (exclusive)
    let data3 = Arc::clone(&data);
    let handle3 = thread::spawn(move || {
        let mut vec = data3.write().unwrap();
        vec.push(4);
    });

    handle1.join().unwrap();
    handle2.join().unwrap();
    handle3.join().unwrap();
}

// When NOT to use smart pointers
// Bad: unnecessary Box
fn bad_example(data: Box<Vec<i32>>) {
    // Just use &Vec<i32> or &[i32]
}

// Good: simple reference
fn good_example(data: &[i32]) {
    // More flexible, no heap allocation needed
}

// Combining smart pointers
struct Node {
    data: i32,
    children: RefCell<Vec<Rc<Node>>>,
}

impl Node {
    fn new(data: i32) -> Rc<Self> {
        Rc::new(Node {
            data,
            children: RefCell::new(vec![]),
        })
    }

    fn add_child(&self, child: Rc<Node>) {
        self.children.borrow_mut().push(child);
    }
}
```
