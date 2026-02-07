# Use Terraform Cloud or CI/CD for Automation

> Automate all Terraform execution through CI/CD pipelines or Terraform Cloud -- never apply manually.

## Rules

- Use Terraform Cloud/Enterprise or CI/CD pipelines (GitHub Actions, GitLab CI, etc.)
- Require plan review before apply
- Run `terraform fmt` and `terraform validate` in CI
- Use policy as code (Sentinel, OPA) for governance
- Store state remotely and lock during runs
- Never run `terraform apply` from a local machine in production

## Example

```yaml
# .github/workflows/terraform.yml
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
      - uses: hashicorp/setup-terraform@v1

      - name: Terraform Format
        run: terraform fmt -check

      - name: Terraform Init
        run: terraform init

      - name: Terraform Validate
        run: terraform validate

      - name: Terraform Plan
        run: terraform plan

      - name: Terraform Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply -auto-approve
```
