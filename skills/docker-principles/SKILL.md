---
name: docker-principles
description: "Container standards for Dockerfiles, Compose files, .dockerignore, image builds, BuildKit, runtime hardening, scanning, or container review."
license: MIT
paths: ["**/Dockerfile", "**/Dockerfile.*", "**/Containerfile", "**/compose.yaml", "**/compose.yml", "**/docker-compose*.yml", "**/docker-compose*.yaml", "**/.dockerignore"]
globs: ["**/Dockerfile", "**/Dockerfile.*", "**/Containerfile", "**/compose.yaml", "**/compose.yml", "**/docker-compose*.yml", "**/docker-compose*.yaml", "**/.dockerignore"]
metadata:
  asciify-source: asciify-skills
  asciify-category: docker
---

# Docker Principles

Use this skill as standing guidance for this domain. Apply the checklist first; read the detailed reference only when the task is substantial, risky, unfamiliar, or review-oriented.

## Operating Rules

- Prefer the repository's existing conventions, toolchain, and CI commands over generic defaults.
- Make the smallest coherent change that satisfies the request while preserving behavior.
- Treat tests, linting, dependency hygiene, and security review as part of completion.
- If a principle conflicts with higher-priority repository instructions or an explicit user request, follow the higher-priority instruction and call out the tradeoff.

## Core Checklist

- Use multi-stage builds and minimal runtime images; avoid full OS images unless the workload requires them.
- Pin base image tags and prefer digests for production rebuild reproducibility.
- Run as a non-root user, drop capabilities, and make filesystems read-only when practical.
- Keep secrets out of layers; use BuildKit secret mounts or runtime secret providers.
- Copy only required files, maintain `.dockerignore`, and keep dependency installation cacheable.
- Use exec-form entrypoints, health checks, and explicit signal handling.
- Generate or preserve SBOM/provenance where the build system supports it.
- Scan Dockerfiles, image configs, base images, and final images before publishing.

## Validation

Run applicable checks when they exist in the project; if a tool is missing, report that it was skipped.

- `hadolint Dockerfile` or equivalent Dockerfile linting
- `docker build` or the project's container build command
- `trivy config .` and `trivy image <image>` or equivalent image scanning

## Detailed Reference

For the complete principle set with examples and edge cases, read [references/principles.md](references/principles.md) when deeper guidance is useful.
