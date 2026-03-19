# Follow Security Best Practices

> Harden Terraform/OpenTofu configurations to prevent unauthorized access, data exposure, and insecure infrastructure.

## Rules

- Never store secrets in `.tf` files or `.tfvars`; use environment variables, vault references, or secret manager data sources
- Encrypt state files at rest; use remote backends with encryption (S3 + KMS, GCS + CMEK, OpenTofu state encryption)
- Restrict state file access with IAM policies; state contains sensitive data
- Use `sensitive = true` on variables and outputs that contain secrets
- Enable encryption at rest and in transit for all storage and database resources
- Apply least-privilege IAM policies; never use wildcard (`*`) permissions in production
- Run security scanners (tfsec, Checkov, trivy) in CI to catch misconfigurations

## Example

```hcl
# Bad: secrets in plain text, overly permissive IAM
variable "db_password" {
  default = "hunter2"
}

resource "aws_iam_policy" "admin" {
  policy = jsonencode({
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}

# Good: secrets from vault, least-privilege IAM, encrypted state
variable "db_password" {
  type      = string
  sensitive = true  # Prevents display in logs and plan output
}

data "aws_secretsmanager_secret_version" "db" {
  secret_id = "prod/db/password"
}

resource "aws_iam_policy" "app" {
  policy = jsonencode({
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject", "s3:PutObject"]
      Resource = "${aws_s3_bucket.data.arn}/*"
    }]
  })
}

# Encrypt state with OpenTofu
terraform {
  encryption {
    key_provider "aws_kms" "main" {
      kms_key_id = "alias/tofu-state"
      region     = "us-east-1"
    }
    method "aes_gcm" "main" {
      keys = key_provider.aws_kms.main
    }
    state {
      method   = method.aes_gcm.main
      enforced = true
    }
  }
}
```

```bash
# Scan for security issues
tfsec .
checkov -d .
trivy config .
```
