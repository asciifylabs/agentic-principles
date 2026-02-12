# Handle Errors Explicitly

> Always check and handle errors explicitly; never ignore them. This is fundamental to Go's error handling philosophy.

## Rules

- Always check the error value returned from functions
- Never use `_` to discard errors unless you have a very good reason
- Return errors up the call stack or handle them immediately
- Wrap errors with context using `fmt.Errorf` with `%w` verb
- Use `errors.Is()` and `errors.As()` for error comparison
- Create custom error types for domain-specific errors
- Log errors with sufficient context before returning

## Example

```go
// Bad: ignoring errors
file, _ := os.Open("file.txt")
data, _ := io.ReadAll(file)

// Good: explicit error handling
func readConfig(path string) ([]byte, error) {
    file, err := os.Open(path)
    if err != nil {
        return nil, fmt.Errorf("failed to open config: %w", err)
    }
    defer file.Close()

    data, err := io.ReadAll(file)
    if err != nil {
        return nil, fmt.Errorf("failed to read config: %w", err)
    }

    return data, nil
}

// Custom error type
type ValidationError struct {
    Field string
    Err   error
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation failed for %s: %v", e.Field, e.Err)
}

// Error checking with errors.Is
if err := saveData(); err != nil {
    if errors.Is(err, fs.ErrNotExist) {
        // Handle file not found specifically
    }
    return err
}
```
