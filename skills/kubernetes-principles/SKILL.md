---
name: kubernetes-principles
description: "Kubernetes and Helm standards for manifests, charts, values files, RBAC, workloads, networking, policy, validation, or deployment review."
license: MIT
paths: ["**/k8s/**/*.yml", "**/k8s/**/*.yaml", "**/kubernetes/**/*.yml", "**/kubernetes/**/*.yaml", "**/helm/**/*.yml", "**/helm/**/*.yaml", "**/Chart.yaml", "**/values*.yaml", "**/values*.yml"]
globs: ["**/k8s/**/*.yml", "**/k8s/**/*.yaml", "**/kubernetes/**/*.yml", "**/kubernetes/**/*.yaml", "**/helm/**/*.yml", "**/helm/**/*.yaml", "**/Chart.yaml", "**/values*.yaml", "**/values*.yml"]
metadata:
  asciify-source: asciify-skills
  asciify-category: kubernetes
---

# Kubernetes Principles

Use this skill as standing guidance for this domain. Apply the checklist first; read the detailed reference only when the task is substantial, risky, unfamiliar, or review-oriented.

## Operating Rules

- Prefer the repository's existing conventions, toolchain, and CI commands over generic defaults.
- Make the smallest coherent change that satisfies the request while preserving behavior.
- Treat tests, linting, dependency hygiene, and security review as part of completion.
- If a principle conflicts with higher-priority repository instructions or an explicit user request, follow the higher-priority instruction and call out the tradeoff.

## Core Checklist

- Set requests, limits, probes, disruption budgets, and rollout strategy deliberately for production workloads.
- Use namespace boundaries, least-privilege RBAC, and network policies for isolation.
- Follow Kubernetes Pod Security Standards; default application workloads toward the Restricted profile.
- Run containers as non-root, drop unnecessary capabilities, and avoid host namespaces and privileged containers.
- Store configuration in ConfigMaps and secrets appropriately; do not commit plaintext secrets.
- Validate Helm templates, CRDs, and manifests against schemas and policy before applying.
- Use labels and annotations consistently for ownership, observability, selection, and lifecycle automation.
- Design upgrades and rollbacks before changing stateful workloads, ingress, storage, or networking.

## Validation

Run applicable checks when they exist in the project; if a tool is missing, report that it was skipped.

- `helm lint` for charts
- `helm template ... | kubeconform -strict` or schema validation for rendered manifests
- Policy checks with Kyverno, Gatekeeper/OPA, Conftest, or the project's admission policy tooling

## Detailed Reference

For the complete principle set with examples and edge cases, read [references/principles.md](references/principles.md) when deeper guidance is useful.
