# Avoid Package-Level State

> Minimize mutable package-level variables; prefer explicit dependencies and configuration.

## Rules

- Avoid global variables that hold mutable state
- Use package-level variables only for constants and immutable data
- Pass dependencies explicitly through function parameters or struct fields
- Use `init()` functions sparingly; prefer explicit initialization
- Make configuration explicit rather than relying on global state
- Use dependency injection for better testability
- Package-level variables make testing and concurrency difficult

## Example

```go
// Bad: mutable package-level state
var (
    db     *sql.DB
    cache  *Cache
    config *Config
)

func init() {
    var err error
    db, err = sql.Open("postgres", "connection string")
    if err != nil {
        panic(err)
    }
}

func GetUser(id string) (*User, error) {
    // Uses global db - hard to test
    return queryUser(db, id)
}

// Good: explicit dependencies
type UserService struct {
    db    *sql.DB
    cache *Cache
}

func NewUserService(db *sql.DB, cache *Cache) *UserService {
    return &UserService{
        db:    db,
        cache: cache,
    }
}

func (s *UserService) GetUser(id string) (*User, error) {
    // Uses injected dependencies - easy to test
    return queryUser(s.db, id)
}

// Good: explicit initialization in main
func main() {
    db, err := sql.Open("postgres", os.Getenv("DATABASE_URL"))
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    cache := NewCache()
    userService := NewUserService(db, cache)

    // Use userService...
}

// Package-level constants are fine
const (
    DefaultTimeout = 30 * time.Second
    MaxRetries     = 3
)

// Immutable package-level variables are acceptable
var (
    validStatuses = []string{"active", "inactive", "pending"}
    emailRegex    = regexp.MustCompile(`^[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,}$`)
)

// Good: testable code with dependency injection
type UserRepository interface {
    GetUser(id string) (*User, error)
}

type UserHandler struct {
    repo UserRepository
}

func (h *UserHandler) HandleGetUser(w http.ResponseWriter, r *http.Request) {
    user, err := h.repo.GetUser(r.URL.Query().Get("id"))
    // ...
}

// Easy to test with mock
type MockRepo struct {
    User *User
    Err  error
}

func (m *MockRepo) GetUser(id string) (*User, error) {
    return m.User, m.Err
}

func TestUserHandler(t *testing.T) {
    handler := &UserHandler{
        repo: &MockRepo{User: &User{ID: "123"}},
    }
    // Test handler...
}
```
