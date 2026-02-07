# Use Modules for Reusability

> Encapsulate repeated infrastructure patterns into versioned, single-purpose modules.

## Rules

- Create modules for common patterns (VPCs, databases, load balancers)
- Keep modules single-purpose and focused
- Use input variables for customization and outputs for composition
- Version modules for stability
- Store modules in separate repositories or directories
- Never copy-paste resource blocks across projects -- extract a module instead

## Example

```hcl
# modules/network/main.tf
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  # ... other configuration
}

output "vpc_id" {
  value = aws_vpc.main.id
}

# main.tf
module "network" {
  source = "./modules/network"

  vpc_cidr = "10.0.0.0/16"
}
```
