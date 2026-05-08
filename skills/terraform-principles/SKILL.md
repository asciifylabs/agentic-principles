---
name: terraform-principles
description: "Terraform and OpenTofu standards for .tf, .tfvars, .tofu, modules, providers, state, plans, policy checks, and IaC review."
license: MIT
paths: ["**/*.tf", "**/*.tfvars", "**/*.tofu", "**/*.tf.json", "**/*.tofu.json"]
globs: ["**/*.tf", "**/*.tfvars", "**/*.tofu", "**/*.tf.json", "**/*.tofu.json"]
metadata:
  asciify-source: asciify-skills
  asciify-category: terraform
---

# Terraform Principles

Use this skill as standing guidance for this domain. Apply the checklist first; read the detailed reference only when the task is substantial, risky, unfamiliar, or review-oriented.

## Operating Rules

- Prefer the repository's existing conventions, toolchain, and CI commands over generic defaults.
- Make the smallest coherent change that satisfies the request while preserving behavior.
- Treat tests, linting, dependency hygiene, and security review as part of completion.
- If a principle conflicts with higher-priority repository instructions or an explicit user request, follow the higher-priority instruction and call out the tradeoff.

## Core Checklist

- Use modules to create reusable boundaries, but keep module interfaces small and explicit.
- Store state remotely with encryption and locking; restrict state access because state can contain secrets.
- Pin Terraform/OpenTofu and provider versions; commit lock files where applicable.
- Keep variables typed, outputs intentional, and sensitive values marked `sensitive = true`.
- Prefer data sources and locals over hardcoded environment-specific values.
- Review plans in CI and separate plan from apply with approval for production.
- Apply least-privilege IAM and policy-as-code checks for sensitive infrastructure.
- Support OpenTofu deliberately when the project has chosen it; do not mix CLIs accidentally.

## Validation

Run applicable checks when they exist in the project; if a tool is missing, report that it was skipped.

- `terraform fmt -recursive` or `tofu fmt -recursive`
- `terraform validate` or `tofu validate`
- `tflint --recursive` when configured
- `trivy config .`, Checkov, Conftest, or the project's policy scanner for risky infrastructure

## Detailed Reference

For the complete principle set with examples and edge cases, read [references/principles.md](references/principles.md) when deeper guidance is useful.
