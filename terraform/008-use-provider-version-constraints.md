# Use Provider Version Constraints

> Pin Terraform and provider versions to ensure reproducible deployments.

## Rules

- Specify required provider versions in the `required_providers` block
- Use version constraints (e.g., `~> 4.0`, `>= 3.0, < 5.0`)
- Pin the Terraform version itself in `required_version`
- Commit the `.terraform.lock.hcl` lock file for exact versions
- Test provider upgrades before applying to production

## Example

```hcl
terraform {
  required_version = ">= 1.0, < 2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  # Allow 4.x but not 5.0
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```
