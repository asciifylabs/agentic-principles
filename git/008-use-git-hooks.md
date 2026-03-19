# Use Git Hooks for Automation

> Leverage git hooks to enforce code quality and prevent bad commits before they enter the repository.

## Rules

- Use pre-commit hooks to run linters, formatters, and tests before commits
- Use commit-msg hooks to enforce conventional commit message format
- Use pre-push hooks to run full test suites before pushing
- Share hook configurations via tools like pre-commit, husky, or lefthook
- Never skip hooks with `--no-verify` unless there is a documented reason
- Keep hooks fast to avoid slowing down the development workflow
- Document required hooks in the project README or CONTRIBUTING guide

## Example

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-merge-conflict

  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks
```

```bash
# Install pre-commit hooks
pre-commit install
pre-commit install --hook-type commit-msg

# Run hooks against all files
pre-commit run --all-files
```
