# Use Struct Embedding Over Inheritance

> Use struct embedding and composition instead of inheritance to share behavior and extend types.

## Rules

- Embed types to promote their methods to the outer type
- Use embedding for "has-a" relationships, not "is-a"
- Embedded fields can be accessed directly or explicitly
- Embedding interfaces allows compile-time checks
- Prefer composition over complex embedding hierarchies
- Name embedded fields when you need explicit control
- Use embedding to satisfy interfaces automatically

## Example

```go
// Bad: trying to use inheritance (not supported in Go)
// This doesn't exist in Go!

// Good: struct embedding
type Engine struct {
    Power int
}

func (e *Engine) Start() {
    fmt.Println("Engine starting...")
}

// Car embeds Engine
type Car struct {
    Engine // Embedded field
    Brand  string
}

func main() {
    car := Car{
        Engine: Engine{Power: 200},
        Brand:  "Toyota",
    }

    // Can call embedded methods directly
    car.Start() // Promoted from Engine

    // Can also access explicitly
    car.Engine.Start()

    // Access embedded fields
    fmt.Println(car.Power) // Promoted from Engine
}

// Embedding interfaces for compile-time checks
type Reader interface {
    Read(p []byte) (n int, err error)
}

type MyReader struct {
    Reader // Must implement Reader interface
}

// Extending functionality with embedding
type Logger struct {
    mu  sync.Mutex
    out io.Writer
}

func (l *Logger) Log(msg string) {
    l.mu.Lock()
    defer l.mu.Unlock()
    fmt.Fprintf(l.out, "%s: %s\n", time.Now().Format(time.RFC3339), msg)
}

// TimedLogger embeds Logger and adds timing
type TimedLogger struct {
    *Logger
}

func (tl *TimedLogger) LogWithDuration(msg string, duration time.Duration) {
    tl.Log(fmt.Sprintf("%s (took %v)", msg, duration))
}

// Named embedded fields for explicit control
type Server struct {
    http.Server           // Anonymous embedding
    config      *Config   // Named field
}

func (s *Server) Start() {
    // Access embedded Server methods
    s.ListenAndServe()
}
```
