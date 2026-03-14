# Use terraform fmt and validate

> Run `terraform fmt` / `tofu fmt` and `terraform validate` / `tofu validate` on every change, enforced by pre-commit hooks and CI.

## Rules

- Run `terraform fmt -recursive` (or `tofu fmt -recursive`) to format all files consistently
- Run `terraform validate` (or `tofu validate`) to catch syntax and configuration errors early
- Use `terraform fmt -check` (or `tofu fmt -check`) in CI to fail on unformatted code
- Integrate both into pre-commit hooks
- Validate before every commit and in every CI pipeline run
- Both `terraform` and `tofu` CLIs produce compatible formatting -- pick one per project and stay consistent

## Example

```bash
# Format all Terraform/OpenTofu files
terraform fmt -recursive
# or: tofu fmt -recursive

# Check if formatting is needed (for CI)
terraform fmt -check -recursive
# or: tofu fmt -check -recursive

# Validate configuration
terraform validate
# or: tofu validate

# Pre-commit hook example
#!/bin/bash
terraform fmt -check
terraform validate
```

```hcl
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.81.0
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
```
