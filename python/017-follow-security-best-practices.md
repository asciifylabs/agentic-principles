# Follow Security Best Practices

> Validate inputs, avoid injection vulnerabilities, and handle secrets properly to prevent common security issues.

## Rules

- Never trust user input; validate and sanitize all external data
- Use parameterized queries for SQL to prevent SQL injection
- Avoid `eval()`, `exec()`, and `pickle` with untrusted data
- Never hardcode secrets; use environment variables or secret management services
- Use cryptographic libraries (cryptography, secrets) instead of rolling your own
- Keep dependencies updated and scan for vulnerabilities with `pip-audit` or Snyk
- Use HTTPS for all external API calls
- Implement proper authentication and authorization checks
- Log security events but never log sensitive data (passwords, tokens, PII)

## Example

```python
# Bad: SQL injection vulnerability
def get_user(username):
    query = f"SELECT * FROM users WHERE name = '{username}'"
    return db.execute(query)

# Bad: command injection
import os
def backup_file(filename):
    os.system(f"cp {filename} /backup/")  # Shell injection risk

# Good: parameterized query
def get_user(username: str) -> User | None:
    query = "SELECT * FROM users WHERE name = ?"
    return db.execute(query, (username,))

# Good: safe subprocess usage
import subprocess
from pathlib import Path

def backup_file(filename: Path) -> None:
    """Safely backup a file."""
    if not filename.exists():
        raise ValueError(f"File not found: {filename}")

    subprocess.run(
        ["cp", str(filename), "/backup/"],
        check=True,
        capture_output=True
    )

# Good: secrets management
import os
from cryptography.fernet import Fernet

# Load from environment, not hardcoded
API_KEY = os.getenv("API_KEY")
if not API_KEY:
    raise ValueError("API_KEY environment variable not set")

# Good: secure random generation
import secrets

# Not random.random() or random.randint()
token = secrets.token_urlsafe(32)
secure_int = secrets.randbelow(100)

# Good: input validation with Pydantic
from pydantic import BaseModel, validator, EmailStr

class UserInput(BaseModel):
    email: EmailStr
    age: int

    @validator('age')
    def validate_age(cls, v):
        if not 0 <= v <= 150:
            raise ValueError('Age must be between 0 and 150')
        return v
```
