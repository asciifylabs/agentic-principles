# Use Lifecycle Rules Appropriately

> Control resource creation, replacement, and destruction behavior with lifecycle blocks.

## Rules

- Use `create_before_destroy` for zero-downtime replacements
- Use `prevent_destroy` for critical resources (databases, encryption keys)
- Use `ignore_changes` for attributes managed outside Terraform
- Use `replace_triggered_by` to force replacement on upstream changes
- Document why each lifecycle rule exists

## Example

```hcl
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false

    ignore_changes = [
      # Tags managed by external system
      tags["ManagedBy"],
      # AMI updates handled separately
      ami,
    ]
  }
}

resource "aws_db_instance" "critical" {
  # ... configuration

  lifecycle {
    prevent_destroy = true  # Never destroy production database
  }
}
```
