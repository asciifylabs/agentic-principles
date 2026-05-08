---
name: shell-principles
description: "Shell scripting standards for .sh, .bash, Makefile, Dockerfile shell snippets, and automation scripts. Use for writing, reviewing, or modifying shell code."
license: MIT
paths: ["**/*.sh", "**/*.bash", "**/*.zsh", "**/Makefile", "**/Makefile.*", "**/*.mk"]
globs: ["**/*.sh", "**/*.bash", "**/*.zsh", "**/Makefile", "**/Makefile.*", "**/*.mk"]
metadata:
  asciify-source: asciify-skills
  asciify-category: shell
---

# Shell Principles

Use this skill as standing guidance for this domain. Apply the checklist first; read the detailed reference only when the task is substantial, risky, unfamiliar, or review-oriented.

## Operating Rules

- Prefer the repository's existing conventions, toolchain, and CI commands over generic defaults.
- Make the smallest coherent change that satisfies the request while preserving behavior.
- Treat tests, linting, dependency hygiene, and security review as part of completion.
- If a principle conflicts with higher-priority repository instructions or an explicit user request, follow the higher-priority instruction and call out the tradeoff.

## Core Checklist

- Start scripts with `set -euo pipefail` when compatible with the script's control flow.
- Quote variable expansions and use arrays for argument lists.
- Prefer functions with local variables for reusable logic.
- Use `mktemp`, traps, and cleanup handlers for temporary files.
- Avoid `eval`, string-built commands, unvalidated `curl | sh`, and untrusted input in shell contexts.
- Check required commands before use and fail with actionable messages.
- Use structured logging for automation and keep secrets out of command traces.
- Run ShellCheck and shfmt on changed scripts.

## Validation

Run applicable checks when they exist in the project; if a tool is missing, report that it was skipped.

- `shellcheck <changed scripts>`
- `shfmt -w <changed scripts>`
- Run the script in a safe test mode or fixture when possible

## Detailed Reference

For the complete principle set with examples and edge cases, read [references/principles.md](references/principles.md) when deeper guidance is useful.
