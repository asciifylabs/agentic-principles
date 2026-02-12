# Follow Effective Go Guidelines

> Adhere to the conventions and idioms in Effective Go and Go Code Review Comments for consistent, idiomatic code.

## Rules

- Use MixedCaps or mixedCaps for names, not underscores
- Name interfaces with "-er" suffix for single-method interfaces
- Use short variable names in small scopes (i, j, k for loops)
- Name getters without "Get" prefix (Balance() not GetBalance())
- Keep package names short, lowercase, single-word when possible
- Use doc comments starting with the name being documented
- Organize imports: standard library, blank line, third-party packages

## Example

```go
// Bad: non-idiomatic naming and structure
func Get_User_Name(user_id int) string {
    var user_name string
    // ...
    return user_name
}

// Good: idiomatic Go
// Package balance provides account balance operations.
package balance

import (
    "fmt"
    "time"
)

// Account represents a bank account.
type Account struct {
    id      string
    balance int64
}

// Balance returns the current account balance.
// Note: no "Get" prefix
func (a *Account) Balance() int64 {
    return a.balance
}

// Deposit adds funds to the account.
func (a *Account) Deposit(amount int64) error {
    if amount <= 0 {
        return fmt.Errorf("amount must be positive")
    }
    a.balance += amount
    return nil
}

// Short variable names in small scopes
func sumBalances(accounts []*Account) int64 {
    var total int64
    for _, a := range accounts {
        total += a.Balance()
    }
    return total
}
```
