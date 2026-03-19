# Follow Security Best Practices

> Write Go code that is resistant to common vulnerabilities including injection, path traversal, and data exposure.

## Rules

- Use `crypto/rand` for random values, never `math/rand` for security-sensitive operations
- Sanitize and validate all user input before use
- Use parameterized queries with `database/sql`; never concatenate SQL strings
- Validate file paths with `filepath.Clean` and ensure they stay within expected directories
- Set timeouts on all HTTP clients and servers to prevent resource exhaustion
- Use `html/template` (not `text/template`) for HTML output to prevent XSS
- Run `gosec` in CI to catch security issues automatically
- Pin dependencies and audit with `govulncheck`

## Example

```go
// Bad: insecure random, path traversal, SQL injection
import "math/rand"

func handler(w http.ResponseWriter, r *http.Request) {
    token := fmt.Sprintf("%d", rand.Int())
    file := r.URL.Query().Get("file")
    data, _ := os.ReadFile("/data/" + file)
    db.Query("SELECT * FROM users WHERE name = '" + r.URL.Query().Get("name") + "'")
}

// Good: secure practices
import "crypto/rand"

func handler(w http.ResponseWriter, r *http.Request) {
    // Secure random
    token := make([]byte, 32)
    crypto_rand.Read(token)

    // Path traversal prevention
    file := filepath.Clean(r.URL.Query().Get("file"))
    fullPath := filepath.Join("/data", file)
    if !strings.HasPrefix(fullPath, "/data/") {
        http.Error(w, "forbidden", http.StatusForbidden)
        return
    }

    // Parameterized query
    rows, err := db.QueryContext(ctx,
        "SELECT * FROM users WHERE name = $1",
        r.URL.Query().Get("name"),
    )
}
```

```bash
# Run security scanner
gosec ./...

# Check for known vulnerabilities in dependencies
govulncheck ./...
```
