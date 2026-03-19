# Write Tests for Infrastructure

> Validate Terraform/OpenTofu configurations with automated tests to catch misconfigurations before they reach production.

## Rules

- Use `terraform validate` and `tofu validate` as the first line of defense
- Write policy tests with OPA/Conftest, Sentinel, or Checkov for compliance
- Use `terraform test` (v1.6+) or Terratest for integration testing
- Test modules in isolation with minimal variable inputs
- Validate plan output against expected resources before applying
- Run `terraform plan` in CI on every PR to surface changes early
- Test destructive operations (replacements, deletions) are flagged before apply

## Example

```hcl
# tests/main.tftest.hcl (terraform test)
run "creates_s3_bucket" {
  command = plan

  assert {
    condition     = aws_s3_bucket.main.bucket == "my-app-data"
    error_message = "Bucket name must be my-app-data"
  }

  assert {
    condition     = aws_s3_bucket_versioning.main.versioning_configuration[0].status == "Enabled"
    error_message = "Versioning must be enabled"
  }
}

run "blocks_public_access" {
  command = plan

  assert {
    condition     = aws_s3_bucket_public_access_block.main.block_public_acls == true
    error_message = "Public ACLs must be blocked"
  }
}
```

```bash
# Run terraform native tests
terraform test

# Run Checkov for policy compliance
checkov -d .

# Run Conftest with custom OPA policies
conftest test --policy policy/ tfplan.json
```
