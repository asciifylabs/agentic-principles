# Use Arc and Mutex for Shared State

> Use `Arc<Mutex<T>>` or `Arc<RwLock<T>>` for safely sharing mutable state across threads.

## Rules

- Use `Arc` (Atomic Reference Counting) for shared ownership across threads
- Use `Mutex` for exclusive mutable access to shared data
- Use `RwLock` when reads greatly outnumber writes
- Always lock for the shortest duration possible
- Handle lock() unwrap carefully; consider using try_lock()
- Be aware of deadlock risks with multiple locks
- Use channels as an alternative to shared state when possible

## Example

```rust
use std::sync::{Arc, Mutex, RwLock};
use std::thread;

// Basic shared mutable state
fn basic_example() {
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

// Shared application state
struct AppState {
    users: Vec<String>,
    request_count: u64,
}

type SharedState = Arc<Mutex<AppState>>;

fn handle_request(state: SharedState) {
    let mut state = state.lock().unwrap();
    state.request_count += 1;
    println!("Request #{}", state.request_count);
}

fn run_server() {
    let state = Arc::new(Mutex::new(AppState {
        users: vec![],
        request_count: 0,
    }));

    let mut handles = vec![];
    for _ in 0..5 {
        let state_clone = Arc::clone(&state);
        let handle = thread::spawn(move || {
            handle_request(state_clone);
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }
}

// RwLock for read-heavy workloads
fn rwlock_example() {
    let data = Arc::new(RwLock::new(vec![1, 2, 3]));
    let mut handles = vec![];

    // Multiple readers
    for i in 0..5 {
        let data_clone = Arc::clone(&data);
        let handle = thread::spawn(move || {
            let vec = data_clone.read().unwrap();
            println!("Reader {}: {:?}", i, vec);
        });
        handles.push(handle);
    }

    // One writer
    let data_clone = Arc::clone(&data);
    let handle = thread::spawn(move || {
        let mut vec = data_clone.write().unwrap();
        vec.push(4);
        println!("Writer added 4");
    });
    handles.push(handle);

    for handle in handles {
        handle.join().unwrap();
    }
}

// Lock for shortest duration
// Bad: holding lock too long
fn bad_lock_duration(data: Arc<Mutex<Vec<i32>>>) {
    let mut vec = data.lock().unwrap();
    // Long computation while holding lock
    expensive_computation();
    vec.push(1);
}

// Good: release lock during computation
fn good_lock_duration(data: Arc<Mutex<Vec<i32>>>) {
    let result = expensive_computation();

    // Lock only for the update
    let mut vec = data.lock().unwrap();
    vec.push(result);
}

// Avoid deadlocks
// Bad: lock ordering can cause deadlock
fn potential_deadlock(
    data1: Arc<Mutex<i32>>,
    data2: Arc<Mutex<i32>>,
) {
    thread::spawn(move || {
        let _a = data1.lock().unwrap();
        let _b = data2.lock().unwrap(); // Might deadlock
    });

    thread::spawn(move || {
        let _b = data2.lock().unwrap();
        let _a = data1.lock().unwrap(); // Might deadlock
    });
}

// Good: consistent lock ordering
fn no_deadlock(
    data1: Arc<Mutex<i32>>,
    data2: Arc<Mutex<i32>>,
) {
    thread::spawn(move || {
        let _a = data1.lock().unwrap();
        let _b = data2.lock().unwrap();
    });

    thread::spawn(move || {
        let _a = data1.lock().unwrap(); // Same order
        let _b = data2.lock().unwrap();
    });
}

// try_lock to avoid blocking
fn try_lock_example(data: Arc<Mutex<Vec<i32>>>) {
    match data.try_lock() {
        Ok(mut vec) => {
            vec.push(1);
            println!("Acquired lock");
        }
        Err(_) => {
            println!("Lock busy, skipping");
        }
    }
}

// Scope-based locking
fn scoped_lock(data: Arc<Mutex<Vec<i32>>>) {
    {
        let mut vec = data.lock().unwrap();
        vec.push(1);
    } // Lock released here

    // Do other work without holding lock
    do_other_work();
}

// Alternative: use channels instead of shared state
use std::sync::mpsc;

fn channel_alternative() {
    let (tx, rx) = mpsc::channel();

    // Spawner thread
    thread::spawn(move || {
        tx.send(42).unwrap();
    });

    // Receiver thread
    let received = rx.recv().unwrap();
    println!("Received: {}", received);
}

// Real-world example: connection pool
use std::collections::VecDeque;

struct ConnectionPool {
    connections: Arc<Mutex<VecDeque<Connection>>>,
}

impl ConnectionPool {
    fn new(size: usize) -> Self {
        let mut connections = VecDeque::new();
        for _ in 0..size {
            connections.push_back(Connection::new());
        }

        ConnectionPool {
            connections: Arc::new(Mutex::new(connections)),
        }
    }

    fn get(&self) -> Option<Connection> {
        let mut pool = self.connections.lock().unwrap();
        pool.pop_front()
    }

    fn return_connection(&self, conn: Connection) {
        let mut pool = self.connections.lock().unwrap();
        pool.push_back(conn);
    }
}

// Implementing Clone for shared state
impl Clone for ConnectionPool {
    fn clone(&self) -> Self {
        ConnectionPool {
            connections: Arc::clone(&self.connections),
        }
    }
}
```

**When to use what:**

- **Arc<Mutex<T>>**: Shared mutable state, writes common
- **Arc<RwLock<T>>**: Shared state, reads outnumber writes 10:1+
- **Arc<T>**: Shared immutable state
- **Channels**: Message passing, producer-consumer patterns
- **Atomic types**: Simple counters (AtomicU64, AtomicBool)
