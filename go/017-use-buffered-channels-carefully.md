# Use Buffered Channels Carefully

> Use unbuffered channels by default; add buffering only when you have a specific reason and understand the implications.

## Rules

- Default to unbuffered channels (`make(chan T)`)
- Use buffered channels to decouple sender and receiver speeds
- Size buffers based on measurable performance needs, not guesswork
- Remember that buffered channels can hide synchronization issues
- Buffered channels don't prevent goroutine leaks
- Document why a channel is buffered and how the size was chosen
- Use buffered channels for bounded queues and rate limiting

## Example

```go
// Default: unbuffered channel (synchronous)
ch := make(chan int)

// Unbuffered: sender blocks until receiver reads
go func() {
    ch <- 42 // Blocks until someone reads
}()
value := <-ch // Unblocks sender

// Buffered channel: sender blocks only when buffer is full
buffered := make(chan int, 10)
buffered <- 1 // Doesn't block (buffer has space)
buffered <- 2 // Doesn't block
// ... can send up to 10 values without blocking

// Good: bounded worker queue
func processJobs(jobs []Job) {
    // Buffer size = number of workers
    // Prevents unbounded memory growth
    jobCh := make(chan Job, 100)
    results := make(chan Result, 100)

    // Start workers
    for i := 0; i < 10; i++ {
        go worker(jobCh, results)
    }

    // Send jobs (blocks when buffer full)
    go func() {
        defer close(jobCh)
        for _, job := range jobs {
            jobCh <- job
        }
    }()

    // Collect results
    for i := 0; i < len(jobs); i++ {
        <-results
    }
}

// Good: rate limiting with buffered channel
type RateLimiter struct {
    tokens chan struct{}
}

func NewRateLimiter(rate int) *RateLimiter {
    rl := &RateLimiter{
        tokens: make(chan struct{}, rate),
    }

    // Fill bucket with tokens
    for i := 0; i < rate; i++ {
        rl.tokens <- struct{}{}
    }

    // Refill tokens periodically
    go func() {
        ticker := time.NewTicker(time.Second / time.Duration(rate))
        defer ticker.Stop()
        for range ticker.C {
            select {
            case rl.tokens <- struct{}{}:
            default: // Bucket full
            }
        }
    }()

    return rl
}

func (rl *RateLimiter) Wait() {
    <-rl.tokens // Blocks until token available
}

// Bad: buffer size based on guess
ch := make(chan int, 1000) // Why 1000? Arbitrary!

// Good: buffer size based on system constraints
const maxConcurrentRequests = 10
requestCh := make(chan Request, maxConcurrentRequests)

// Buffered channels don't prevent leaks
// Bad: goroutine still leaks even with buffered channel
func leak() {
    ch := make(chan int, 1)
    go func() {
        for {
            val := <-ch // Still blocks forever if channel not closed
            process(val)
        }
    }()
}

// Good: proper cleanup
func noLeak(ctx context.Context) {
    ch := make(chan int, 1)
    go func() {
        for {
            select {
            case <-ctx.Done():
                return // Goroutine exits
            case val := <-ch:
                process(val)
            }
        }
    }()
}
```
