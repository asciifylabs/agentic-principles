# Use Terraform Workspaces Carefully

> Use workspaces only for similar, short-lived environments; prefer separate directories for production isolation.

## Rules

- Use workspaces for: temporary environments, feature branches, similar environments
- Prefer separate directories for: production vs non-production, significantly different configurations
- Always use workspace-specific variable files or conditionals
- Reference `terraform.workspace` for environment-specific logic
- Be aware that workspaces share the same backend configuration
- Never rely on workspace names as the sole environment differentiator in production

## Example

```hcl
# Use workspace in configuration
locals {
  environment = terraform.workspace
  instance_count = terraform.workspace == "production" ? 3 : 1
}

# Workspace-specific variables
variable "instance_type" {
  default = {
    default    = "t3.micro"
    staging    = "t3.small"
    production = "t3.medium"
  }
}

resource "aws_instance" "web" {
  count         = local.instance_count
  instance_type = var.instance_type[terraform.workspace]

  tags = {
    Environment = terraform.workspace
  }
}
```
