# Handle Panics Appropriately

> Use panic only for truly unrecoverable errors; prefer returning errors for expected failure cases.

## Rules

- Use errors, not panics, for expected failure cases
- Panic only for programming errors (nil dereference, out of bounds)
- Recover from panics only at package boundaries (HTTP handlers, workers)
- Never recover from panics to hide bugs
- Use `recover()` in deferred functions to catch panics
- Log panics with stack traces before recovering
- Convert panics to errors at API boundaries

## Example

```go
// Bad: panic for expected errors
func GetUser(id string) *User {
    user, err := db.Query(id)
    if err != nil {
        panic(err) // DON'T: use panic for normal errors
    }
    return user
}

// Good: return errors for expected failures
func GetUser(id string) (*User, error) {
    user, err := db.Query(id)
    if err != nil {
        return nil, fmt.Errorf("failed to get user: %w", err)
    }
    return user, nil
}

// Acceptable: panic for programming errors
func divide(a, b int) int {
    if b == 0 {
        panic("divide by zero") // Programming error
    }
    return a / b
}

// Good: recover at package boundaries
func SafeHandler(handler http.HandlerFunc) http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        defer func() {
            if err := recover(); err != nil {
                log.Printf("panic recovered: %v\n%s", err, debug.Stack())
                http.Error(w, "Internal Server Error", 500)
            }
        }()

        handler(w, r)
    }
}

// Good: recover in worker goroutines
func worker(jobs <-chan Job) {
    defer func() {
        if r := recover(); r != nil {
            log.Printf("worker panic: %v\n%s", r, debug.Stack())
            // Worker can continue processing other jobs
        }
    }()

    for job := range jobs {
        processJob(job)
    }
}

// Convert panic to error at API boundary
func SafeCall(fn func()) (err error) {
    defer func() {
        if r := recover(); r != nil {
            err = fmt.Errorf("panic: %v", r)
        }
    }()

    fn()
    return nil
}

// Don't recover to hide bugs
// Bad:
func processData(data []byte) {
    defer func() {
        recover() // Silently swallows bugs!
    }()
    // buggy code...
}

// Good: let it panic to expose bugs during development
func processData(data []byte) {
    // If this panics, we want to know about it
    // Fix the bug, don't hide it
}
```
