# Use Build Tags for Conditional Compilation

> Use build tags to include or exclude code based on platform, environment, or features.

## Rules

- Place build tags at the top of files before package declaration
- Use build tags for platform-specific code (\_linux.go, \_windows.go suffixes)
- Use tags for feature flags and optional dependencies
- Document required build tags in README
- Combine tags with AND (space) and OR (comma)
- Use `//go:build` directive (new style) instead of `// +build` (old style)
- Test with different tags: `go build -tags tagname`

## Example

```go
// File: database_postgres.go
//go:build postgres
// +build postgres  // Old style (keep for compatibility with Go <1.17)

package database

import "github.com/lib/pq"

func init() {
    RegisterDriver("postgres", &PostgresDriver{})
}

// File: database_mysql.go
//go:build mysql

package database

import "github.com/go-sql-driver/mysql"

func init() {
    RegisterDriver("mysql", &MySQLDriver{})
}

// File: logger_debug.go
//go:build debug

package logger

func Log(msg string) {
    fmt.Printf("[DEBUG] %s\n", msg)
}

// File: logger_release.go
//go:build !debug

package logger

func Log(msg string) {
    // No-op in release builds
}

// Build with tags:
// $ go build -tags postgres
// $ go build -tags "mysql debug"
```

**Platform-specific files (automatic tags):**

```go
// File: utils_linux.go
//go:build linux

package utils

func PlatformSpecific() string {
    return "Linux"
}

// File: utils_windows.go
//go:build windows

package utils

func PlatformSpecific() string {
    return "Windows"
}

// File: utils_darwin.go
//go:build darwin

package utils

func PlatformSpecific() string {
    return "macOS"
}
```

**Complex tag combinations:**

```go
// Build only on Linux OR Darwin
//go:build linux || darwin

// Build only on Linux AND amd64
//go:build linux && amd64

// Build on everything except Windows
//go:build !windows

// Multiple conditions
//go:build (linux || darwin) && cgo
```

**Integration test tags:**

```go
// File: database_test.go
//go:build integration

package database

import "testing"

func TestDatabaseConnection(t *testing.T) {
    // Requires real database
    // Only runs with: go test -tags integration
}
```

**Feature flags:**

```go
// File: metrics_prometheus.go
//go:build prometheus

package metrics

import "github.com/prometheus/client_golang/prometheus"

type Collector struct {
    // Prometheus implementation
}

// File: metrics_noop.go
//go:build !prometheus

package metrics

type Collector struct {
    // No-op implementation
}
```
