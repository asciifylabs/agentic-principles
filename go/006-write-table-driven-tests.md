# Write Table-Driven Tests

> Use table-driven tests to test multiple scenarios efficiently and maintain readable test code.

## Rules

- Define test cases in a slice of structs with inputs and expected outputs
- Use subtests with `t.Run()` for each test case
- Name test cases descriptively to aid debugging
- Use `t.Helper()` in test helper functions
- Test both success and error cases
- Use `testdata/` directory for test fixtures
- Run tests with race detector: `go test -race`

## Example

```go
// Bad: repetitive test code
func TestAdd(t *testing.T) {
    result := Add(2, 3)
    if result != 5 {
        t.Errorf("expected 5, got %d", result)
    }

    result = Add(0, 0)
    if result != 0 {
        t.Errorf("expected 0, got %d", result)
    }
    // ... more repetition
}

// Good: table-driven test
func TestAdd(t *testing.T) {
    tests := []struct {
        name string
        a, b int
        want int
    }{
        {"positive numbers", 2, 3, 5},
        {"zeros", 0, 0, 0},
        {"negative numbers", -1, -2, -3},
        {"mixed signs", 5, -3, 2},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got := Add(tt.a, tt.b)
            if got != tt.want {
                t.Errorf("Add(%d, %d) = %d, want %d",
                    tt.a, tt.b, got, tt.want)
            }
        })
    }
}

// Table-driven test with error cases
func TestParseUser(t *testing.T) {
    tests := []struct {
        name    string
        input   string
        want    *User
        wantErr bool
    }{
        {
            name:  "valid user",
            input: `{"name":"Alice","age":30}`,
            want:  &User{Name: "Alice", Age: 30},
        },
        {
            name:    "invalid json",
            input:   `{invalid`,
            wantErr: true,
        },
        {
            name:    "missing field",
            input:   `{"name":"Bob"}`,
            wantErr: true,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := ParseUser(tt.input)
            if (err != nil) != tt.wantErr {
                t.Errorf("ParseUser() error = %v, wantErr %v", err, tt.wantErr)
                return
            }
            if !tt.wantErr && !reflect.DeepEqual(got, tt.want) {
                t.Errorf("ParseUser() = %v, want %v", got, tt.want)
            }
        })
    }
}
```
