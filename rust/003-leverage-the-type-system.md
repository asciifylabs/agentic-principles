# Leverage the Type System

> Use Rust's powerful type system to encode invariants and prevent bugs at compile time.

## Rules

- Use newtypes to wrap primitives and add type safety
- Use enums to represent state and alternatives
- Make invalid states unrepresentable
- Use zero-sized types for compile-time guarantees
- Leverage traits to define shared behavior
- Use the type system to enforce business rules
- Prefer compile-time errors over runtime errors

## Example

```rust
// Bad: primitives don't prevent mistakes
fn transfer(from: u64, to: u64, amount: f64) {
    // Can accidentally swap from/to
    // Amount could be negative
}

// Good: newtypes for type safety
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct UserId(u64);

#[derive(Debug, Clone, Copy, PartialEq)]
struct Amount(u64); // Stored in cents

impl Amount {
    fn new(cents: u64) -> Self {
        Amount(cents)
    }

    fn from_dollars(dollars: f64) -> Self {
        Amount((dollars * 100.0) as u64)
    }
}

fn transfer(from: UserId, to: UserId, amount: Amount) {
    // Type system prevents swapping from/to with amount
    // Amount cannot be negative
}

// Make invalid states unrepresentable with enums
// Bad: can be in invalid state
struct Connection {
    connected: bool,
    socket: Option<TcpStream>,
}

// Good: enum enforces valid states
enum Connection {
    Disconnected,
    Connected { socket: TcpStream },
}

impl Connection {
    fn send(&mut self, data: &[u8]) -> Result<(), Error> {
        match self {
            Connection::Connected { socket } => socket.write_all(data),
            Connection::Disconnected => Err(Error::NotConnected),
        }
    }
}

// Use enums for state machines
enum Order {
    Pending { items: Vec<Item> },
    Confirmed { items: Vec<Item>, total: Amount },
    Shipped { tracking_number: String },
    Delivered,
}

impl Order {
    fn confirm(self) -> Result<Order, Error> {
        match self {
            Order::Pending { items } => {
                let total = calculate_total(&items)?;
                Ok(Order::Confirmed { items, total })
            }
            _ => Err(Error::InvalidState),
        }
    }
}

// Zero-sized types for compile-time guarantees
struct Validated;
struct Unvalidated;

struct Email<State = Unvalidated> {
    address: String,
    _state: PhantomData<State>,
}

impl Email<Unvalidated> {
    fn new(address: String) -> Self {
        Email {
            address,
            _state: PhantomData,
        }
    }

    fn validate(self) -> Result<Email<Validated>, Error> {
        if self.address.contains('@') {
            Ok(Email {
                address: self.address,
                _state: PhantomData,
            })
        } else {
            Err(Error::InvalidEmail)
        }
    }
}

impl Email<Validated> {
    fn send(&self, msg: &str) {
        // Can only call send on validated emails!
    }
}
```
