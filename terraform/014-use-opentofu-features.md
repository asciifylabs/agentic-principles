# Use OpenTofu-Specific Features When Available

> When using OpenTofu, leverage its unique capabilities for better security, flexibility, and developer experience.

## Rules

- Use client-side state encryption to protect sensitive data at rest -- configure `encryption` blocks in your backend
- Use early variable and local evaluation where supported to simplify configuration
- Source providers from the OpenTofu Registry; verify availability before migrating from Terraform
- Use the `tofu` CLI as a drop-in replacement for `terraform` -- commands and flags are compatible
- Use `-test-directory` flag for running module tests when writing testable infrastructure
- When migrating from Terraform, run `tofu init -upgrade` to re-initialize with OpenTofu-compatible providers
- Keep `required_version` constraints compatible if your team uses both tools

## Example

```hcl
# State encryption (OpenTofu-specific)
terraform {
  encryption {
    method "aes_gcm" "default" {
      keys = key_provider.pbkdf2.default
    }

    key_provider "pbkdf2" "default" {
      passphrase = var.state_passphrase
    }

    state {
      method   = method.aes_gcm.default
      enforced = true
    }

    plan {
      method   = method.aes_gcm.default
      enforced = true
    }
  }

  backend "s3" {
    bucket         = "my-tofu-state"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tofu-locks"
  }
}
```
