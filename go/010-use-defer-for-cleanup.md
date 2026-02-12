# Use Defer for Cleanup

> Use defer statements to ensure resources are properly released, even when errors occur.

## Rules

- Use defer immediately after acquiring a resource (file, lock, connection)
- Defer runs in LIFO order (last defer executes first)
- Be aware that defer has a small performance cost in tight loops
- Deferred functions can access and modify named return values
- Use defer for mutex unlocks, file closes, and connection closes
- Avoid deferring in infinite loops or very tight loops
- Remember that defer arguments are evaluated immediately

## Example

```go
// Bad: manual cleanup, error-prone
func readFile(path string) ([]byte, error) {
    file, err := os.Open(path)
    if err != nil {
        return nil, err
    }

    data, err := io.ReadAll(file)
    file.Close() // Might not run if ReadAll panics!

    return data, err
}

// Good: defer ensures cleanup
func readFile(path string) ([]byte, error) {
    file, err := os.Open(path)
    if err != nil {
        return nil, err
    }
    defer file.Close() // Always executes

    return io.ReadAll(file)
}

// Multiple defers execute in LIFO order
func example() {
    defer fmt.Println("Third")  // Executes first
    defer fmt.Println("Second") // Executes second
    defer fmt.Println("First")  // Executes last
}

// Defer with mutex
type Cache struct {
    mu    sync.RWMutex
    items map[string]string
}

func (c *Cache) Get(key string) (string, bool) {
    c.mu.RLock()
    defer c.mu.RUnlock() // Ensures unlock even if panic

    val, ok := c.items[key]
    return val, ok
}

// Defer can modify named return values
func fetchData() (data []byte, err error) {
    file, err := os.Open("data.txt")
    if err != nil {
        return nil, err
    }
    defer func() {
        if closeErr := file.Close(); closeErr != nil && err == nil {
            err = closeErr // Modify return error
        }
    }()

    return io.ReadAll(file)
}

// Avoid defer in tight loops (performance)
// Bad:
for i := 0; i < 1000000; i++ {
    mu.Lock()
    defer mu.Unlock() // Defers accumulate!
    // work
}

// Good: manual unlock in loop
for i := 0; i < 1000000; i++ {
    mu.Lock()
    // work
    mu.Unlock()
}
```
