---
name: ansible-principles
description: "Ansible standards for playbooks, roles, inventories, ansible.cfg, Jinja templates, idempotency, Molecule tests, or automation review."
license: MIT
paths: ["**/playbooks/**/*.yml", "**/playbooks/**/*.yaml", "**/roles/**/*.yml", "**/roles/**/*.yaml", "**/roles/**/*.j2", "**/inventories/**/*.yml", "**/inventories/**/*.yaml", "**/ansible.cfg", "**/molecule.yml"]
globs: ["**/playbooks/**/*.yml", "**/playbooks/**/*.yaml", "**/roles/**/*.yml", "**/roles/**/*.yaml", "**/roles/**/*.j2", "**/inventories/**/*.yml", "**/inventories/**/*.yaml", "**/ansible.cfg", "**/molecule.yml"]
metadata:
  asciify-source: asciify-skills
  asciify-category: ansible
---

# Ansible Principles

Use this skill as standing guidance for this domain. Apply the checklist first; read the detailed reference only when the task is substantial, risky, unfamiliar, or review-oriented.

## Operating Rules

- Prefer the repository's existing conventions, toolchain, and CI commands over generic defaults.
- Make the smallest coherent change that satisfies the request while preserving behavior.
- Treat tests, linting, dependency hygiene, and security review as part of completion.
- If a principle conflicts with higher-priority repository instructions or an explicit user request, follow the higher-priority instruction and call out the tradeoff.

## Core Checklist

- Prefer roles, collections, inventories, and variables over monolithic playbooks.
- Make every task idempotent; use `changed_when` and `failed_when` intentionally.
- Use modules before `shell` or `command`; if shell is required, quote variables and define creates/removes guards.
- Keep secrets in Ansible Vault or an external secret manager, never in playbooks or inventories.
- Pin collection versions and document supported Ansible versions.
- Use handlers for service restarts and tags for targeted execution.
- Keep templates deterministic, explicit, and validated before deployment.
- Test roles with Molecule or an equivalent CI path for important infrastructure.

## Validation

Run applicable checks when they exist in the project; if a tool is missing, report that it was skipped.

- `ansible-lint`
- `ansible-playbook --syntax-check <playbook>`
- `molecule test` for roles or risky changes when configured

## Detailed Reference

For the complete principle set with examples and edge cases, read [references/principles.md](references/principles.md) when deeper guidance is useful.
