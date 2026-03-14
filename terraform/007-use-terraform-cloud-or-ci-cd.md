# Use Terraform Cloud, CI/CD, or OpenTofu for Automation

> Automate all Terraform/OpenTofu execution through CI/CD pipelines, Terraform Cloud, or equivalent -- never apply manually.

## Rules

- Use Terraform Cloud/Enterprise, CI/CD pipelines (GitHub Actions, GitLab CI, etc.), or OpenTofu-compatible automation
- Require plan review before apply
- Run `terraform fmt` / `tofu fmt` and `terraform validate` / `tofu validate` in CI
- Use policy as code (Sentinel, OPA) for governance
- Store state remotely and lock during runs
- Never run `terraform apply` or `tofu apply` from a local machine in production

## Example

```yaml
# .github/workflows/terraform.yml — works with both Terraform and OpenTofu
name: Terraform
on:
  pull_request:
    paths:
      - 'terraform/**'
  push:
    branches: [main]
    paths:
      - 'terraform/**'

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      # Use hashicorp/setup-terraform for Terraform
      # or opentofu/setup-opentofu for OpenTofu
      - uses: hashicorp/setup-terraform@v3

      - name: Format Check
        run: terraform fmt -check

      - name: Init
        run: terraform init

      - name: Validate
        run: terraform validate

      - name: Plan
        run: terraform plan

      - name: Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply -auto-approve
```
