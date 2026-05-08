---
name: go-principles
description: "Go engineering standards for .go, go.mod, and go.sum files. Use for Go implementation, tests, concurrency, dependencies, linting, or code review."
license: MIT
paths: ["**/*.go", "**/go.mod", "**/go.sum", "**/go.work"]
globs: ["**/*.go", "**/go.mod", "**/go.sum", "**/go.work"]
metadata:
  asciify-source: asciify-skills
  asciify-category: go
---

# Go Principles

Use this skill as standing guidance for this domain. Apply the checklist first; read the detailed reference only when the task is substantial, risky, unfamiliar, or review-oriented.

## Operating Rules

- Prefer the repository's existing conventions, toolchain, and CI commands over generic defaults.
- Make the smallest coherent change that satisfies the request while preserving behavior.
- Treat tests, linting, dependency hygiene, and security review as part of completion.
- If a principle conflicts with higher-priority repository instructions or an explicit user request, follow the higher-priority instruction and call out the tradeoff.

## Core Checklist

- Use Go modules and keep `go.mod`, `go.sum`, and `go.work` intentional and tidy.
- Prefer simple, idiomatic code: small interfaces, explicit errors, clear package boundaries, and no unnecessary abstractions.
- Thread `context.Context` through I/O, RPC, database, and goroutine lifecycles.
- Avoid goroutine leaks; every goroutine should have a cancellation or completion path.
- Wrap errors with context and handle them explicitly; reserve panics for truly unrecoverable states.
- Use table-driven tests, race tests for concurrent code, and benchmarks only for meaningful performance questions.
- Keep public APIs documented and backward-compatible unless a breaking change is intentional.
- Run vulnerability checks for dependencies and avoid package-level mutable state in production code.

## Validation

Run applicable checks when they exist in the project; if a tool is missing, report that it was skipped.

- `gofmt -w` on changed Go files
- `go test ./...`
- `go vet ./...`
- `golangci-lint run ./...` and `govulncheck ./...` when configured or security-sensitive

## Detailed Reference

For the complete principle set with examples and edge cases, read [references/principles.md](references/principles.md) when deeper guidance is useful.
