---
name: nodejs-principles
description: "JavaScript and TypeScript standards for .js, .jsx, .ts, .tsx, package.json, tsconfig, tests, package management, linting, or review."
license: MIT
paths: ["**/*.js", "**/*.mjs", "**/*.cjs", "**/*.ts", "**/*.tsx", "**/*.jsx", "**/package.json", "**/tsconfig.json", "**/pnpm-lock.yaml", "**/package-lock.json", "**/yarn.lock", "**/bun.lockb"]
globs: ["**/*.js", "**/*.mjs", "**/*.cjs", "**/*.ts", "**/*.tsx", "**/*.jsx", "**/package.json", "**/tsconfig.json", "**/pnpm-lock.yaml", "**/package-lock.json", "**/yarn.lock", "**/bun.lockb"]
metadata:
  asciify-source: asciify-skills
  asciify-category: nodejs
---

# Node.js Principles

Use this skill as standing guidance for this domain. Apply the checklist first; read the detailed reference only when the task is substantial, risky, unfamiliar, or review-oriented.

## Operating Rules

- Prefer the repository's existing conventions, toolchain, and CI commands over generic defaults.
- Make the smallest coherent change that satisfies the request while preserving behavior.
- Treat tests, linting, dependency hygiene, and security review as part of completion.
- If a principle conflicts with higher-priority repository instructions or an explicit user request, follow the higher-priority instruction and call out the tradeoff.

## Core Checklist

- Prefer TypeScript with strict settings for maintained application code.
- Use one package manager per project and commit the matching lock file.
- Use ESM or CommonJS consistently; do not mix module systems without a clear boundary.
- Validate external input at trust boundaries with schemas and typed domain objects.
- Handle promises explicitly; avoid floating promises and callback-style control flow in new code.
- Keep configuration in environment variables or secret managers, not source code.
- Use structured logging, graceful shutdown, dependency scanning, and reproducible CI installs.
- Prefer project scripts for lint, test, build, and type-check commands.

## Validation

Run applicable checks when they exist in the project; if a tool is missing, report that it was skipped.

- Use project scripts first: lint, typecheck, test, build.
- Use reproducible installs: `npm ci`, `pnpm install --frozen-lockfile`, `yarn install --immutable`, or the configured equivalent.
- Run dependency audit/scanning for dependency or release-sensitive changes.

## Detailed Reference

For the complete principle set with examples and edge cases, read [references/principles.md](references/principles.md) when deeper guidance is useful.
