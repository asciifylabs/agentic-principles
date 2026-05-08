# Manage Dependencies Properly

> Use modern dependency management tools, `pyproject.toml`, and lock files to ensure reproducible builds and avoid version conflicts.

## Rules

- Use `pyproject.toml` as the default project metadata and tool configuration file
- Prefer a lock-capable workflow such as uv, Poetry, PDM, or pip-tools for applications
- For libraries, define compatible dependency ranges; for applications, deploy from a lock file or hash-pinned requirements
- Keep dependency groups separate for runtime, development, tests, and tooling
- Specify supported Python versions in `requires-python`
- Run vulnerability checks with `pip-audit`, `uv pip audit`, or the project's configured SCA tool
- Update dependencies deliberately through reviewed PRs, not ad hoc local installs

## Example

```bash
# Bad: unpinned dependencies
requests
flask
numpy

# Good: generate locked, hash-pinned requirements
pip-compile --generate-hashes requirements.in

# Good: using pyproject.toml with dependency groups
# pyproject.toml
[project]
requires-python = ">=3.12"
dependencies = [
  "requests>=2.32,<3",
  "flask>=3.0,<4",
]

[dependency-groups]
dev = [
  "pytest",
  "ruff",
  "pyright",
]
```

**Best practices:**

```bash
# Install from lock file
pip install -r requirements.txt

# Or with uv
uv sync --locked

# Or with Poetry / PDM, depending on the project
poetry install --sync
pdm sync --frozen-lockfile

# Check for vulnerabilities
pip-audit
uv pip audit

# Update dependencies safely
uv lock --upgrade-package requests
poetry update --dry-run
```
