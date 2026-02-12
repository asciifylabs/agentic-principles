# Use gofmt and Linters

> Run gofmt on all code and use golangci-lint to catch common issues and maintain code quality.

## Rules

- Run `gofmt -w .` before committing (or use `goimports`)
- Configure golangci-lint in `.golangci.yml` with appropriate linters
- Run linters in CI/CD pipelines to block non-compliant code
- Use `go vet` to catch suspicious constructs
- Enable linters: errcheck, gosec, govet, staticcheck, unused
- Address linter warnings; don't blindly disable them
- Use `//nolint` comments sparingly with justification

## Example

```bash
# Format all Go code
gofmt -w .

# Or use goimports (formats + manages imports)
goimports -w .

# Run go vet
go vet ./...

# Install golangci-lint
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Run linters
golangci-lint run
```

**.golangci.yml:**

```yaml
linters:
  enable:
    - errcheck # Check for unchecked errors
    - gosec # Security issues
    - govet # Standard Go vet checks
    - staticcheck # Static analysis
    - unused # Unused code
    - gofmt # Format checking
    - goimports # Import organization
    - misspell # Spelling mistakes

linters-settings:
  errcheck:
    check-blank: true

run:
  timeout: 5m
```

```go
// Justified nolint usage
//nolint:gosec // G304: file path is validated before use
func readFile(path string) ([]byte, error) {
    return os.ReadFile(path)
}
```
