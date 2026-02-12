# Avoid Goroutine Leaks

> Always ensure goroutines can exit properly to prevent resource leaks and memory growth.

## Rules

- Never start a goroutine without knowing when and how it will stop
- Use context for cancellation signals to goroutines
- Close channels to signal goroutine completion
- Use WaitGroups to wait for goroutines to finish
- Ensure blocked goroutines have a way to unblock
- Test for goroutine leaks using runtime.NumGoroutine()
- Use select with context.Done() in goroutine loops

## Example

```go
// Bad: goroutine leak - never exits
func leakyFunction() {
    ch := make(chan int)
    go func() {
        for {
            // This goroutine never exits!
            val := <-ch
            process(val)
        }
    }()
    // ch is never closed, goroutine blocks forever
}

// Good: goroutine exits properly
func properFunction(ctx context.Context) {
    ch := make(chan int)

    go func() {
        defer close(ch)
        for {
            select {
            case <-ctx.Done():
                return // Goroutine exits cleanly
            case val := <-ch:
                process(val)
            }
        }
    }()
}

// Using WaitGroup to wait for goroutines
func processItems(items []Item) error {
    var wg sync.WaitGroup
    errCh := make(chan error, len(items))

    for _, item := range items {
        wg.Add(1)
        go func(i Item) {
            defer wg.Done()
            if err := processItem(i); err != nil {
                errCh <- err
            }
        }(item)
    }

    // Wait for all goroutines
    wg.Wait()
    close(errCh)

    // Check for errors
    for err := range errCh {
        if err != nil {
            return err
        }
    }
    return nil
}

// Proper cleanup pattern
type Worker struct {
    ctx    context.Context
    cancel context.CancelFunc
    wg     sync.WaitGroup
}

func NewWorker() *Worker {
    ctx, cancel := context.WithCancel(context.Background())
    return &Worker{
        ctx:    ctx,
        cancel: cancel,
    }
}

func (w *Worker) Start() {
    w.wg.Add(1)
    go func() {
        defer w.wg.Done()
        for {
            select {
            case <-w.ctx.Done():
                return
            default:
                // Do work
            }
        }
    }()
}

func (w *Worker) Stop() {
    w.cancel()     // Signal goroutines to stop
    w.wg.Wait()    // Wait for them to finish
}
```
