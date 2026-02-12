# Follow Standard Project Layout

> Organize code using the community-standard project layout for maintainability and discoverability.

## Rules

- Use `/cmd` for main applications (each subdirectory is a binary)
- Use `/internal` for private application code that shouldn't be imported
- Use `/pkg` for public library code that can be imported by external projects
- Put tests in the same package (or `_test` package for black-box tests)
- Use `/api` for API definitions (OpenAPI, protobuf, GraphQL schemas)
- Use `/configs` for configuration file templates
- Keep `main.go` minimal; put logic in packages

## Example

```
myproject/
├── cmd/
│   ├── server/
│   │   └── main.go          # Server entry point
│   └── cli/
│       └── main.go          # CLI tool entry point
├── internal/
│   ├── user/
│   │   ├── user.go          # User domain logic
│   │   ├── user_test.go
│   │   └── repository.go
│   ├── auth/
│   │   └── auth.go
│   └── database/
│       └── postgres.go
├── pkg/
│   └── api/
│       └── client.go        # Public API client
├── api/
│   └── openapi.yaml         # API specification
├── configs/
│   └── config.yaml          # Config template
├── scripts/
│   └── migrate.sh
├── go.mod
├── go.sum
└── README.md
```

**cmd/server/main.go** - Minimal main:

```go
package main

import (
    "log"
    "os"

    "github.com/username/myproject/internal/server"
)

func main() {
    cfg, err := loadConfig()
    if err != nil {
        log.Fatal(err)
    }

    srv := server.New(cfg)
    if err := srv.Start(); err != nil {
        log.Fatal(err)
    }
}
```

**internal/user/user.go** - Business logic:

```go
// Package user provides user management functionality.
package user

type User struct {
    ID    string
    Name  string
    Email string
}

type Service struct {
    repo Repository
}

func NewService(repo Repository) *Service {
    return &Service{repo: repo}
}

func (s *Service) GetUser(id string) (*User, error) {
    return s.repo.Get(id)
}

// Repository defines user storage operations.
type Repository interface {
    Get(id string) (*User, error)
    Save(user *User) error
}
```

**internal/user/user_test.go** - Tests in same package:

```go
package user

import "testing"

func TestService_GetUser(t *testing.T) {
    // Test implementation
}
```

**pkg/api/client.go** - Public library code:

```go
// Package api provides a client for the MyProject API.
package api

// Client is safe for external projects to import
type Client struct {
    baseURL string
}

func NewClient(baseURL string) *Client {
    return &Client{baseURL: baseURL}
}
```

**Benefits:**

- Clear separation of concerns
- `internal/` prevents external imports
- Multiple binaries in one repo
- Standard layout recognized by tools
- Easy for new developers to navigate
