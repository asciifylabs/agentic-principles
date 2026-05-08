---
name: git-principles
description: "Git workflow standards for commits, commit messages, staging, branches, history, secret prevention, pull requests, or repository hygiene."
license: MIT
metadata:
  asciify-source: asciify-skills
  asciify-category: git
---

# Git Principles

Use this skill as standing guidance for this domain. Apply the checklist first; read the detailed reference only when the task is substantial, risky, unfamiliar, or review-oriented.

## Operating Rules

- Prefer the repository's existing conventions, toolchain, and CI commands over generic defaults.
- Make the smallest coherent change that satisfies the request while preserving behavior.
- Treat tests, linting, dependency hygiene, and security review as part of completion.
- If a principle conflicts with higher-priority repository instructions or an explicit user request, follow the higher-priority instruction and call out the tradeoff.

## Core Checklist

- Keep commits atomic: one coherent change, with tests or docs in the same commit when they belong together.
- Use conventional commit messages when the project does not define a stronger local convention.
- Review `git status` and the staged diff before committing.
- Stage specific files instead of broad `git add .` or `git add -A` when unrelated edits exist.
- Never commit secrets, generated credentials, `.env` files, private keys, or unrelated local config.
- Do not add AI attribution trailers unless the repository explicitly requires them.
- Preserve user changes you did not make; do not rewrite history or force-push unless explicitly requested.
- Prefer short-lived branches and clear PR descriptions that explain risk, tests, and rollout notes.

## Validation

Run applicable checks when they exist in the project; if a tool is missing, report that it was skipped.

- `git status --short`
- `git diff --staged` before committing
- Secret scan changed files when credentials, config, or generated artifacts are involved

## Detailed Reference

For the complete principle set with examples and edge cases, read [references/principles.md](references/principles.md) when deeper guidance is useful.
