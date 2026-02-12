# Write Benchmarks for Performance

> Use Go's built-in benchmarking to measure and optimize performance with real data.

## Rules

- Write benchmark functions with signature `func BenchmarkXxx(b *testing.B)`
- Run the loop `b.N` times (framework adjusts N for reliable timings)
- Use `b.ResetTimer()` to exclude setup code from measurements
- Use `b.ReportAllocs()` to track memory allocations
- Run benchmarks with `go test -bench=. -benchmem`
- Use `benchstat` to compare benchmark results
- Profile with `-cpuprofile` and `-memprofile` for deep analysis

## Example

```go
// File: string_test.go
package mypackage

import "testing"

// Basic benchmark
func BenchmarkStringConcatenation(b *testing.B) {
    for i := 0; i < b.N; i++ {
        result := "hello" + " " + "world"
        _ = result
    }
}

// Benchmark with setup
func BenchmarkMapLookup(b *testing.B) {
    m := make(map[string]int)
    for i := 0; i < 1000; i++ {
        m[fmt.Sprintf("key%d", i)] = i
    }

    b.ResetTimer() // Exclude setup time

    for i := 0; i < b.N; i++ {
        _ = m["key500"]
    }
}

// Benchmark with memory reporting
func BenchmarkBufferGrowth(b *testing.B) {
    b.ReportAllocs() // Report allocations

    for i := 0; i < b.N; i++ {
        var buf bytes.Buffer
        for j := 0; j < 100; j++ {
            buf.WriteString("test")
        }
        _ = buf.String()
    }
}

// Table-driven benchmarks
func BenchmarkFibonacci(b *testing.B) {
    benchmarks := []struct {
        name  string
        input int
    }{
        {"Fib10", 10},
        {"Fib20", 20},
        {"Fib30", 30},
    }

    for _, bm := range benchmarks {
        b.Run(bm.name, func(b *testing.B) {
            for i := 0; i < b.N; i++ {
                Fibonacci(bm.input)
            }
        })
    }
}

// Parallel benchmarks
func BenchmarkConcurrentMap(b *testing.B) {
    m := &sync.Map{}

    b.RunParallel(func(pb *testing.PB) {
        for pb.Next() {
            m.Store("key", "value")
            m.Load("key")
        }
    })
}
```

**Running benchmarks:**

```bash
# Run all benchmarks
go test -bench=.

# Run specific benchmark
go test -bench=BenchmarkStringConcatenation

# Include memory statistics
go test -bench=. -benchmem

# Run for longer (more accurate)
go test -bench=. -benchtime=10s

# CPU profile
go test -bench=. -cpuprofile=cpu.prof
go tool pprof cpu.prof

# Memory profile
go test -bench=. -memprofile=mem.prof
go tool pprof mem.prof

# Compare benchmarks with benchstat
go test -bench=. -count=10 > old.txt
# Make changes...
go test -bench=. -count=10 > new.txt
benchstat old.txt new.txt
```

**Example output:**

```
BenchmarkStringConcatenation-8     50000000    25.3 ns/op    0 B/op    0 allocs/op
BenchmarkMapLookup-8              100000000    11.2 ns/op    0 B/op    0 allocs/op
BenchmarkBufferGrowth-8             2000000   856 ns/op    2048 B/op    2 allocs/op
```

**Interpretation:**

- `-8`: GOMAXPROCS value
- `50000000`: iterations (b.N)
- `25.3 ns/op`: time per operation
- `0 B/op`: bytes allocated per operation
- `0 allocs/op`: allocations per operation
