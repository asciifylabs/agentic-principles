# Use Locals for Computed Values

> Place derived values and complex expressions in `locals` blocks to avoid repetition and improve readability.

## Rules

- Use locals for derived values, transformations, and conditional logic
- Keep complex expressions in locals rather than inline in resources
- Use locals to combine variables into composite values
- Do not use locals as simple aliases for single variables
- Document complex local computations with comments

## Example

```hcl
locals {
  # Combine variables
  full_name = "${var.first_name}-${var.last_name}"

  # Compute CIDR blocks
  subnet_cidrs = [
    cidrsubnet(var.vpc_cidr, 8, 1),
    cidrsubnet(var.vpc_cidr, 8, 2),
    cidrsubnet(var.vpc_cidr, 8, 3),
  ]

  # Conditional values
  instance_count = var.environment == "production" ? 3 : 1

  # Complex transformations
  security_group_rules = [
    for rule in var.custom_rules : {
      type        = rule.type
      from_port   = rule.port
      to_port     = rule.port
      protocol    = rule.protocol
      cidr_blocks = [rule.source_cidr]
    }
  ]
}

resource "aws_instance" "web" {
  count = local.instance_count
  # ... uses local.instance_count
}
```
