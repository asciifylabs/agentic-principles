# Manage Dependencies Properly

> Use modern dependency management tools and lock files to ensure reproducible builds and avoid version conflicts.

## Rules

- Use `requirements.txt` for simple projects, Poetry or PDM for complex projects
- Always pin dependencies with exact versions in production (`==` not `>=`)
- Use separate requirements files: `requirements.txt`, `requirements-dev.txt`, `requirements-test.txt`
- Generate lock files to ensure reproducible builds across environments
- Specify Python version requirements in `pyproject.toml` or `README.md`
- Regularly update dependencies and check for security vulnerabilities with tools like `pip-audit`
- Use dependency groups in Poetry to separate dev, test, and production dependencies

## Example

```bash
# Bad: unpinned dependencies
requests
flask
numpy

# Good: pinned dependencies with hashes
# requirements.txt
requests==2.31.0 \
    --hash=sha256:942c5a758f98d56f5a05c4
flask==3.0.0 \
    --hash=sha256:ceb27b0af3823b722842c8e3
numpy==1.26.2 \
    --hash=sha256:3ab67b7b2e0c82e8a9a

# Generate requirements with hashes
pip freeze > requirements.txt
pip-compile --generate-hashes requirements.in

# Good: using Poetry
# pyproject.toml
[tool.poetry.dependencies]
python = "^3.10"
requests = "^2.31.0"
flask = "^3.0.0"

[tool.poetry.group.dev.dependencies]
pytest = "^7.4.0"
black = "^23.0.0"
mypy = "^1.5.0"
```

**Best practices:**

```bash
# Install from lock file
pip install -r requirements.txt

# Or with Poetry
poetry install --no-root

# Check for vulnerabilities
pip-audit

# Update dependencies safely
pip list --outdated
poetry update --dry-run
```
