# Infrastructure Principles

Coding standards and best practices for this infrastructure repository. Each principle is a short, actionable reference with rules and examples.

## Shell Scripting (`shell/`)

| # | Principle |
|---|-----------|
| 001 | [Use `set -euo pipefail`](shell/001-use-set-euo-pipefail.md) |
| 002 | [Use Functions for Reusability](shell/002-use-functions-for-reusability.md) |
| 003 | [Proper Error Handling](shell/003-proper-error-handling.md) |
| 004 | [Always Quote Variables](shell/004-quote-variables.md) |
| 005 | [Use Local Variables in Functions](shell/005-use-local-variables.md) |
| 006 | [Validate All Inputs](shell/006-validate-inputs.md) |
| 007 | [Use Temporary Files Safely](shell/007-use-temporary-files-safely.md) |
| 008 | [Structured Logging](shell/008-logging-best-practices.md) |
| 009 | [Avoid Hardcoded Paths](shell/009-avoid-hardcoded-paths.md) |
| 010 | [Use Here Documents](shell/010-use-here-documents.md) |
| 011 | [Check Command Existence](shell/011-check-command-existence.md) |
| 012 | [Use Arrays for Multiple Values](shell/012-use-array-for-multiple-values.md) |

## Ansible (`ansible/`)

| # | Principle |
|---|-----------|
| 001 | [Use Roles Over Playbooks](ansible/001-use-roles-over-playbooks.md) |
| 002 | [Write Idempotent Tasks](ansible/002-use-idempotent-tasks.md) |
| 003 | [Use Variables and Defaults](ansible/003-use-variables-and-defaults.md) |
| 004 | [Use Handlers for Notifications](ansible/004-use-handlers-for-notifications.md) |
| 005 | [Use Templates Over Static Files](ansible/005-use-templates-over-static-files.md) |
| 006 | [Use Tags for Selective Execution](ansible/006-use-tags-for-selective-execution.md) |
| 007 | [Use Facts Wisely](ansible/007-use-facts-wisely.md) |
| 008 | [Use Blocks for Error Handling](ansible/008-use-blocks-for-error-handling.md) |
| 009 | [Use Vault for Secrets](ansible/009-use-vault-for-secrets.md) |
| 010 | [Use Inventories Effectively](ansible/010-use-inventories-effectively.md) |
| 011 | [Use Conditional Logic](ansible/011-use-conditional-logic.md) |
| 012 | [Use Loops Efficiently](ansible/012-use-loops-efficiently.md) |

## Terraform (`terraform/`)

| # | Principle |
|---|-----------|
| 001 | [Use Modules for Reusability](terraform/001-use-modules-for-reusability.md) |
| 002 | [Use Remote State](terraform/002-use-remote-state.md) |
| 003 | [Use Workspaces or Separate Directories](terraform/003-use-workspaces-or-separate-directories.md) |
| 004 | [Use Variables and Outputs](terraform/004-use-variables-and-outputs.md) |
| 005 | [Use Data Sources](terraform/005-use-data-sources.md) |
| 006 | [Use Lifecycle Rules](terraform/006-use-lifecycle-rules.md) |
| 007 | [Use Terraform Cloud or CI/CD](terraform/007-use-terraform-cloud-or-ci-cd.md) |
| 008 | [Use Provider Version Constraints](terraform/008-use-provider-version-constraints.md) |
| 009 | [Use `terraform fmt` and `validate`](terraform/009-use-terraform-fmt-and-validate.md) |
| 010 | [Use Resource Tags](terraform/010-use-resource-tags.md) |
| 011 | [Use Locals for Computed Values](terraform/011-use-locals-for-computed-values.md) |
| 012 | [Use Workspaces Carefully](terraform/012-use-terraform-workspaces-carefully.md) |
| 013 | [Understand Dependency Graphs](terraform/013-use-dependency-graphs.md) |

## Kubernetes (`kubernetes/`)

### General

| # | Principle |
|---|-----------|
| 001 | [Use Namespaces for Isolation](kubernetes/001-use-namespaces-for-isolation.md) |
| 002 | [Set Resource Requests and Limits](kubernetes/002-set-resource-requests-and-limits.md) |
| 003 | [Use Liveness and Readiness Probes](kubernetes/003-use-liveness-and-readiness-probes.md) |
| 004 | [Use ConfigMaps and Secrets Properly](kubernetes/004-use-configmaps-and-secrets-properly.md) |
| 005 | [Use Labels and Annotations Consistently](kubernetes/005-use-labels-and-annotations-consistently.md) |
| 006 | [Use PodDisruptionBudgets](kubernetes/006-use-poddisruptionbudgets.md) |
| 007 | [Use Network Policies](kubernetes/007-use-network-policies.md) |
| 008 | [Use RBAC Properly](kubernetes/008-use-rbac-properly.md) |
| 009 | [Use Pod Security Standards](kubernetes/009-use-pod-security-standards.md) |
| 010 | [Use Priority Classes](kubernetes/010-use-priority-classes.md) |

### Cilium Networking

| # | Principle |
|---|-----------|
| 011 | [Choose the Right Routing Mode](kubernetes/011-cilium-choose-routing-mode.md) |
| 012 | [Configure MTU Properly](kubernetes/012-cilium-configure-mtu-properly.md) |
| 013 | [Enable Hubble for Observability](kubernetes/013-cilium-enable-hubble-observability.md) |
| 014 | [Use Kube-Proxy Replacement](kubernetes/014-cilium-kubeproxy-replacement.md) |
| 015 | [Configure Masquerading Correctly](kubernetes/015-cilium-configure-masquerading.md) |
| 016 | [Use CiliumNetworkPolicies](kubernetes/016-cilium-network-policies.md) |
| 017 | [Configure eBPF for Performance](kubernetes/017-cilium-ebpf-configuration.md) |
| 018 | [Enable Bandwidth Manager](kubernetes/018-cilium-bandwidth-manager.md) |
