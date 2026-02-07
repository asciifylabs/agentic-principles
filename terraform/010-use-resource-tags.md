# Use Resource Tags Consistently

> Tag every resource with a standard set of metadata for cost tracking, automation, and governance.

## Rules

- Define a standard tagging strategy and enforce it
- Use a `locals` block or module for common tags
- Always include: Environment, Project, ManagedBy, CostCenter
- Apply tags to all taggable resources
- Use `default_tags` at the provider level when possible
- Merge resource-specific tags with common tags

## Example

```hcl
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    CostCenter  = var.cost_center
    Team        = "Platform"
  }
}

resource "aws_instance" "web" {
  # ... configuration

  tags = merge(
    local.common_tags,
    {
      Name = "web-server-${var.environment}"
      Role = "web"
    }
  )
}

# Provider-level default tags
provider "aws" {
  default_tags {
    tags = local.common_tags
  }
}
```
