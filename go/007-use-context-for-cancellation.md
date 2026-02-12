# Use Context for Cancellation

> Pass context.Context as the first parameter to functions that perform I/O or long-running operations for proper cancellation and timeout handling.

## Rules

- Pass `context.Context` as the first parameter (by convention)
- Never pass nil context; use `context.Background()` or `context.TODO()` at top level
- Use `context.WithTimeout()` or `context.WithDeadline()` for timeouts
- Use `context.WithCancel()` for manual cancellation
- Check `ctx.Done()` in loops and long-running operations
- Propagate context through the call stack
- Use `context.WithValue()` sparingly, only for request-scoped values

## Example

```go
// Bad: no cancellation support
func fetchData(url string) ([]byte, error) {
    resp, err := http.Get(url)
    if err != nil {
        return nil, err
    }
    defer resp.Body.Close()
    return io.ReadAll(resp.Body)
}

// Good: context for timeout and cancellation
func fetchData(ctx context.Context, url string) ([]byte, error) {
    req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
    if err != nil {
        return nil, err
    }

    resp, err := http.DefaultClient.Do(req)
    if err != nil {
        return nil, err
    }
    defer resp.Body.Close()

    return io.ReadAll(resp.Body)
}

// Usage with timeout
func main() {
    ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
    defer cancel()

    data, err := fetchData(ctx, "https://api.example.com/data")
    if err != nil {
        if errors.Is(err, context.DeadlineExceeded) {
            log.Println("Request timed out")
        }
        log.Fatal(err)
    }
    fmt.Println(string(data))
}

// Check context in loops
func processItems(ctx context.Context, items []Item) error {
    for _, item := range items {
        select {
        case <-ctx.Done():
            return ctx.Err()
        default:
            if err := processItem(ctx, item); err != nil {
                return err
            }
        }
    }
    return nil
}
```
