# Keep Interfaces Small

> Design interfaces with the fewest methods necessary; prefer many small interfaces over large ones.

## Rules

- Ideal interface has 1-2 methods, rarely more than 3
- Follow the "interface segregation principle"
- Compose small interfaces into larger ones when needed
- Use standard library interfaces where possible (io.Reader, io.Writer)
- Name single-method interfaces with "-er" suffix
- Define interfaces at the point of use, not implementation
- Avoid "kitchen sink" interfaces with many unrelated methods

## Example

```go
// Bad: large interface with many methods
type Repository interface {
    GetUser(id string) (*User, error)
    SaveUser(user *User) error
    DeleteUser(id string) error
    GetProduct(id string) (*Product, error)
    SaveProduct(product *Product) error
    DeleteProduct(id string) error
    // ... many more methods
}

// Good: small, focused interfaces
type UserGetter interface {
    GetUser(id string) (*User, error)
}

type UserSaver interface {
    SaveUser(user *User) error
}

type UserDeleter interface {
    DeleteUser(id string) error
}

// Compose interfaces when needed
type UserRepository interface {
    UserGetter
    UserSaver
    UserDeleter
}

// Single-method interfaces (idiomatic)
type Closer interface {
    Close() error
}

type Flusher interface {
    Flush() error
}

// Function accepting small interface
func processUser(getter UserGetter, id string) error {
    user, err := getter.GetUser(id)
    if err != nil {
        return err
    }
    // Only needs GetUser, not all repository methods
    return process(user)
}

// Use standard library interfaces
type Logger interface {
    io.Writer // Embed standard interface
}

func logMessage(w io.Writer, msg string) {
    fmt.Fprintf(w, "[%s] %s\n", time.Now().Format(time.RFC3339), msg)
}

// Benefits: easy to mock, test, and swap implementations
type MockUserGetter struct {
    User *User
    Err  error
}

func (m *MockUserGetter) GetUser(id string) (*User, error) {
    return m.User, m.Err
}

// Test only needs to implement one method
func TestProcessUser(t *testing.T) {
    mock := &MockUserGetter{
        User: &User{ID: "123", Name: "Alice"},
    }

    err := processUser(mock, "123")
    if err != nil {
        t.Fatal(err)
    }
}
```
