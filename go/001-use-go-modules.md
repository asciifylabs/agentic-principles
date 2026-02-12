# Use Go Modules for Dependencies

> Always use Go modules (`go.mod`) for dependency management instead of GOPATH or vendoring.

## Rules

- Initialize modules with `go mod init` in every project
- Use semantic versioning for module versions
- Run `go mod tidy` regularly to clean up unused dependencies
- Commit both `go.mod` and `go.sum` to version control
- Use `go get` to add or update dependencies
- Pin specific versions in production with `go.mod` entries
- Use replace directives only for local development or forks

## Example

```go
// Initialize a new module
// $ go mod init github.com/username/project

// go.mod
module github.com/username/project

go 1.21

require (
    github.com/gin-gonic/gin v1.9.1
    github.com/lib/pq v1.10.9
)

// Update dependencies
// $ go get -u ./...
// $ go mod tidy

// Add a specific version
// $ go get github.com/gin-gonic/gin@v1.9.1

// Use replace for local development
replace github.com/myorg/mylib => ../mylib
```
