# Never Hardcode Secrets

> Keep all secrets, credentials, API keys, and tokens out of source code — use environment variables, secret managers, or vault services instead.

## Rules

- Never commit passwords, API keys, tokens, private keys, or connection strings to version control
- Use environment variables or a dedicated secrets manager (HashiCorp Vault, AWS Secrets Manager, Azure Key Vault, etc.) for all sensitive values
- Add `.env`, `*.pem`, `*.key`, `credentials.json`, and similar files to `.gitignore` before the first commit
- Use pre-commit hooks (e.g., `git-secrets`, `detect-secrets`, `gitleaks`) to block accidental secret commits
- Rotate any secret that has ever been committed to a repository — treat it as compromised
- Use distinct secrets per environment (development, staging, production) — never share secrets across environments
- Provide a `.env.example` or `.env.template` file with placeholder values (never real secrets) to document required variables
- Store secrets encrypted at rest — never in plain text config files, databases, or logs

## Example

```python
# Bad: hardcoded secret
DATABASE_URL = "postgresql://admin:s3cretP@ss@db.example.com/mydb"
API_KEY = "sk-live-abc123def456"

# Good: read from environment
import os

DATABASE_URL = os.environ["DATABASE_URL"]
API_KEY = os.environ["API_KEY"]
```

```javascript
// Bad: hardcoded token
const token = "ghp_xxxxxxxxxxxxxxxxxxxx";

// Good: read from environment
const token = process.env.GITHUB_TOKEN;
if (!token) throw new Error("GITHUB_TOKEN environment variable is required");
```

```gitignore
# .gitignore - always exclude secret files
.env
.env.local
.env.production
*.pem
*.key
credentials.json
service-account.json
```
