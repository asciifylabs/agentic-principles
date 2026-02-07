# Use Variables and Outputs Effectively

> Define all configurable values as typed, validated, documented variables and expose key attributes as outputs.

## Rules

- Define all configurable values as variables with type constraints and validation
- Provide sensible defaults where appropriate
- Document all variables with descriptions
- Output important resource attributes for module composition
- Never hardcode sensitive values

## Example

```hcl
# variables.tf
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^t[23]", var.instance_type))
    error_message = "Instance type must be t2 or t3 family."
  }
}

variable "enable_monitoring" {
  description = "Enable CloudWatch monitoring"
  type        = bool
  default     = true
}

# outputs.tf
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "instance_public_ip" {
  description = "Public IP address"
  value       = aws_instance.main.public_ip
  sensitive   = false
}
```
