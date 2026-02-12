# Use Meaningful Variable Names

> Choose clear, descriptive names that convey purpose; balance brevity with clarity based on scope.

## Rules

- Use short names (i, j, k) only in small, obvious scopes like loops
- Use descriptive names for package-level declarations and long-lived variables
- Avoid single-letter variables except for: loop counters, method receivers, common idioms
- Name method receivers consistently (usually 1-2 letters of the type name)
- Avoid stuttering: `user.UserID` should be `user.ID`
- Use common abbreviations sparingly and consistently (ctx, err, msg, num)
- Make exported names self-documenting

## Example

```go
// Bad: unclear names
func p(u *U) error {
    d, err := db.Q(u.i)
    if err != nil {
        return err
    }
    // What is d? What does p do?
    return s(d)
}

// Good: clear names
func ProcessUser(user *User) error {
    data, err := database.Query(user.ID)
    if err != nil {
        return err
    }
    return saveResults(data)
}

// Good: short names in small scopes
for i := 0; i < len(items); i++ {
    fmt.Println(items[i])
}

for _, user := range users {
    processUser(user)
}

// Good: method receiver naming
type UserRepository struct {
    db *sql.DB
}

// Receiver is "ur" (abbrev of UserRepository)
func (ur *UserRepository) GetUser(id string) (*User, error) {
    return ur.db.QueryUser(id)
}

// Or single letter for short type names
type Cache struct {
    items map[string]interface{}
}

func (c *Cache) Get(key string) interface{} {
    return c.items[key]
}

// Avoid stuttering
// Bad:
type UserService struct {
    UserRepository UserRepository
    UserCache      UserCache
}

func (us *UserService) GetUserByUserID(userID string) (*User, error) {
    // Too much repetition
}

// Good:
type UserService struct {
    Repository Repository
    Cache      Cache
}

func (s *UserService) GetByID(id string) (*User, error) {
    // Clear without repetition
}

// Common abbreviations (use consistently)
ctx  context.Context
err  error
msg  string (message)
num  int (number)
buf  bytes.Buffer
resp *http.Response
req  *http.Request

// Good: descriptive package-level names
var (
    ErrUserNotFound      = errors.New("user not found")
    ErrInvalidCredentials = errors.New("invalid credentials")
    DefaultTimeout       = 30 * time.Second
)
```
