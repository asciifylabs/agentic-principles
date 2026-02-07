# Use Remote State Backend

> Always store Terraform state in a remote, encrypted, and locked backend.

## Rules

- Use S3, GCS, Azure Storage, or Terraform Cloud for state storage
- Enable state locking (DynamoDB, GCS, etc.)
- Encrypt state at rest
- Use different backends per environment
- Never commit state files to version control
- Use state backends that support versioning

## Example

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```
