# Use Workspaces or Separate Directories for Environments

> Isolate each environment's state and configuration to prevent cross-environment accidents.

## Rules

- Prefer separate directories per environment (recommended for most cases)
- Use Terraform workspaces only for simpler, similar environments
- Use environment-specific variable files
- Use different state backends per environment
- Never share state between environments

## Example

```hcl
# Directory structure
environments/
  production/
    main.tf
    variables.tf
    terraform.tfvars
    backend.tf
  staging/
    main.tf
    variables.tf
    terraform.tfvars
    backend.tf

# Or using workspaces
terraform workspace new production
terraform workspace select production
terraform apply
```
