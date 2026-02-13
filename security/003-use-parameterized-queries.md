# Use Parameterized Queries

> Prevent SQL and NoSQL injection by always using parameterized queries or prepared statements — never concatenate user input into query strings.

## Rules

- Always use parameterized queries (also called prepared statements or bound parameters) for all database queries
- Never concatenate or interpolate user input directly into SQL, NoSQL, or ORM query strings
- Use your language's database driver parameterization: `?` placeholders, `$1` positional params, or named params (`:name`)
- When using ORMs, use the ORM's built-in query builder methods — avoid raw query strings with interpolation
- For dynamic queries (e.g., variable column names or table names), use an allowlist of permitted values — never accept raw input
- Apply the same principle to NoSQL databases: use driver-provided query builders, not string-concatenated filters
- Review any raw SQL usage in code reviews — flag concatenation as a security defect

## Example

```python
# Bad: string concatenation (SQL injection vulnerable)
cursor.execute(f"SELECT * FROM users WHERE email = '{email}'")

# Good: parameterized query
cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
```

```javascript
// Bad: template literal in query (SQL injection vulnerable)
db.query(`SELECT * FROM users WHERE id = ${userId}`);

// Good: parameterized query
db.query("SELECT * FROM users WHERE id = $1", [userId]);
```

```go
// Bad: fmt.Sprintf in query
db.Query(fmt.Sprintf("SELECT * FROM users WHERE name = '%s'", name))

// Good: parameterized query
db.Query("SELECT * FROM users WHERE name = $1", name)
```
