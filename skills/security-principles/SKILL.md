---
name: security-principles
description: "Security standards for any code change in any language. Use for implementation, review, dependency changes, authentication, authorization, data handling, or release risk."
license: MIT
paths: ["**/*"]
globs: ["**/*"]
metadata:
  asciify-source: asciify-skills
  asciify-category: security
---

# Security Principles

Use this skill as standing guidance for this domain. Apply the checklist first; read the detailed reference only when the task is substantial, risky, unfamiliar, or review-oriented.

## Operating Rules

- Prefer the repository's existing conventions, toolchain, and CI commands over generic defaults.
- Make the smallest coherent change that satisfies the request while preserving behavior.
- Treat tests, linting, dependency hygiene, and security review as part of completion.
- If a principle conflicts with higher-priority repository instructions or an explicit user request, follow the higher-priority instruction and call out the tradeoff.

## Core Checklist

- Validate and encode data at every trust boundary; use parameterized queries and safe serializers.
- Enforce authentication, authorization, tenancy, and least privilege server-side.
- Keep secrets out of source, logs, images, Terraform state exposure, and client bundles.
- Avoid command injection, path traversal, unsafe deserialization, SSRF, XSS, CSRF, and insecure direct object references.
- Use secure defaults: TLS, encryption at rest, short-lived credentials, scoped tokens, and safe error messages.
- Maintain dependency, container, and IaC scanning in CI; produce SBOMs where the build system supports them.
- Prefer signed or provenance-backed artifacts for release workflows and align supply-chain controls with SLSA/SSDF concepts.
- Add abuse-case tests for security-sensitive changes and review logs for sensitive data leakage.

## Validation

Run applicable checks when they exist in the project; if a tool is missing, report that it was skipped.

- `gitleaks detect --source .` for secret scanning
- `semgrep --config auto` for common vulnerability patterns
- `trivy fs .` or ecosystem-specific dependency scanning
- Add targeted security tests for authorization, input validation, and data exposure risks

## Detailed Reference

For the complete principle set with examples and edge cases, read [references/principles.md](references/principles.md) when deeper guidance is useful.
