# Use Channels for Communication

> Use channels to communicate between goroutines instead of shared memory with locks.

## Rules

- Follow "Don't communicate by sharing memory; share memory by communicating"
- Use buffered channels only when you understand the implications
- Close channels from the sender, never the receiver
- Use `select` for non-blocking operations and timeouts
- Prefer channels over mutexes for coordinating goroutines
- Use directional channels (`<-chan`, `chan<-`) to clarify intent
- Never close a channel more than once

## Example

```go
// Bad: sharing memory with locks
type Counter struct {
    mu    sync.Mutex
    value int
}

func (c *Counter) Increment() {
    c.mu.Lock()
    c.value++
    c.mu.Unlock()
}

// Good: using channels for communication
func worker(id int, jobs <-chan int, results chan<- int) {
    for job := range jobs {
        // Process job
        results <- job * 2
    }
}

func main() {
    jobs := make(chan int, 100)
    results := make(chan int, 100)

    // Start workers
    for w := 1; w <= 3; w++ {
        go worker(w, jobs, results)
    }

    // Send jobs
    for j := 1; j <= 5; j++ {
        jobs <- j
    }
    close(jobs)

    // Collect results
    for a := 1; a <= 5; a++ {
        <-results
    }
}

// Select for non-blocking operations
func selectExample(ch chan string) {
    select {
    case msg := <-ch:
        fmt.Println("Received:", msg)
    case <-time.After(1 * time.Second):
        fmt.Println("Timeout")
    default:
        fmt.Println("No message")
    }
}

// Pipeline pattern
func generator(nums ...int) <-chan int {
    out := make(chan int)
    go func() {
        defer close(out)
        for _, n := range nums {
            out <- n
        }
    }()
    return out
}

func square(in <-chan int) <-chan int {
    out := make(chan int)
    go func() {
        defer close(out)
        for n := range in {
            out <- n * n
        }
    }()
    return out
}
```
