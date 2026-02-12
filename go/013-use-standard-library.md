# Use Standard Library Packages

> Leverage Go's extensive standard library before reaching for third-party dependencies.

## Rules

- Prefer standard library packages over third-party alternatives when suitable
- Use `net/http` for HTTP clients and servers
- Use `encoding/json` and `encoding/xml` for serialization
- Use `context` for cancellation and timeouts
- Use `time` package for all time operations
- Use `crypto` packages for cryptographic operations
- Learn standard library interfaces: io.Reader, io.Writer, error

## Example

```go
// HTTP server with standard library
import (
    "encoding/json"
    "log"
    "net/http"
    "time"
)

type User struct {
    ID   string `json:"id"`
    Name string `json:"name"`
}

func handleGetUser(w http.ResponseWriter, r *http.Request) {
    user := User{ID: "123", Name: "Alice"}

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(user)
}

func main() {
    mux := http.NewServeMux()
    mux.HandleFunc("/users", handleGetUser)

    server := &http.Server{
        Addr:         ":8080",
        Handler:      mux,
        ReadTimeout:  10 * time.Second,
        WriteTimeout: 10 * time.Second,
    }

    log.Fatal(server.ListenAndServe())
}

// HTTP client with standard library
func fetchUser(ctx context.Context, id string) (*User, error) {
    req, err := http.NewRequestWithContext(
        ctx,
        "GET",
        fmt.Sprintf("https://api.example.com/users/%s", id),
        nil,
    )
    if err != nil {
        return nil, err
    }

    resp, err := http.DefaultClient.Do(req)
    if err != nil {
        return nil, err
    }
    defer resp.Body.Close()

    if resp.StatusCode != http.StatusOK {
        return nil, fmt.Errorf("unexpected status: %d", resp.StatusCode)
    }

    var user User
    if err := json.NewDecoder(resp.Body).Decode(&user); err != nil {
        return nil, err
    }

    return &user, nil
}

// File operations with standard library
func copyFile(src, dst string) error {
    source, err := os.Open(src)
    if err != nil {
        return err
    }
    defer source.Close()

    destination, err := os.Create(dst)
    if err != nil {
        return err
    }
    defer destination.Close()

    _, err = io.Copy(destination, source)
    return err
}

// Sorting with standard library
type ByAge []User

func (a ByAge) Len() int           { return len(a) }
func (a ByAge) Less(i, j int) bool { return a[i].Age < a[j].Age }
func (a ByAge) Swap(i, j int)      { a[i], a[j] = a[j], a[i] }

func sortUsers(users []User) {
    sort.Sort(ByAge(users))
}
```
