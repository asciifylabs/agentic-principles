# Use Data Sources for External References

> Query existing resources with data sources instead of hardcoding IDs or ARNs.

## Rules

- Use data sources instead of hardcoding resource IDs
- Query existing resources dynamically
- Use data sources for resources managed outside Terraform
- Leverage data sources for cross-stack references
- Use remote state data sources for module composition

## Example

```hcl
# Get existing VPC
data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["production-vpc"]
  }
}

# Get AMI dynamically
data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-22.04-amd64-server-*"]
  }
}

# Reference in resource
resource "aws_instance" "web" {
  ami           = data.aws_ami.latest_ubuntu.id
  subnet_id     = data.aws_vpc.existing.default_subnet_id
  instance_type = "t3.micro"
}
```
