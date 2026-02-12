# Use Interfaces for Abstraction

> Define interfaces at the point of use, keep them small, and leverage Go's implicit interface satisfaction for flexible code.

## Rules

- Define interfaces in the package that uses them, not where they're implemented
- Keep interfaces small (1-3 methods is ideal)
- Accept interfaces, return concrete types
- Use the smallest interface that meets your needs
- Leverage implicit interface satisfaction (no explicit "implements" needed)
- Name single-method interfaces with "-er" suffix (Reader, Writer, Closer)
- Use interface composition for complex behaviors

## Example

```go
// Bad: large interface defined in implementation package
type Database interface {
    Connect() error
    Query() error
    Insert() error
    Update() error
    Delete() error
    Close() error
}

// Good: small interfaces defined at point of use
type UserReader interface {
    GetUser(id string) (*User, error)
}

type UserWriter interface {
    SaveUser(user *User) error
}

// Function accepts small interface
func ProcessUser(reader UserReader, id string) error {
    user, err := reader.GetUser(id)
    if err != nil {
        return err
    }
    // Process user...
    return nil
}

// Concrete type can satisfy interface without explicit declaration
type PostgresDB struct {
    // fields...
}

func (db *PostgresDB) GetUser(id string) (*User, error) {
    // Implementation
}
// PostgresDB automatically satisfies UserReader

// Interface composition
type UserRepository interface {
    UserReader
    UserWriter
}
```
