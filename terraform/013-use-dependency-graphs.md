# Understand and Use Dependency Graphs

> Let Terraform infer dependencies from references; use explicit `depends_on` only when implicit dependencies are insufficient.

## Rules

- Terraform infers dependencies automatically from resource references -- rely on this
- Use `depends_on` explicitly only when there is no reference-based dependency (rare)
- Use `terraform graph` to visualize and debug dependency ordering
- Order resources logically in files for human readability
- Use module outputs to create explicit dependencies between modules
- Never create circular dependencies

## Example

```hcl
# Implicit dependency (Terraform infers this)
resource "aws_security_group" "web" {
  name = "web-sg"
  # ...
}

resource "aws_instance" "web" {
  security_groups = [aws_security_group.web.id]  # Dependency inferred
  # ...
}

# Explicit dependency (when needed)
resource "aws_instance" "web" {
  # ...
  depends_on = [
    aws_iam_role.instance_role,  # Explicit dependency
    aws_cloudwatch_log_group.app  # Explicit dependency
  ]
}

# Module dependency via outputs
module "network" {
  source = "./modules/network"
}

module "compute" {
  source = "./modules/compute"
  vpc_id = module.network.vpc_id  # Creates dependency
}
```
