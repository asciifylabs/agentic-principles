# Asciify Skills

## Git Commit Policy

You MAY commit when the user asks you to. **Never run `git push`** — always let the user push themselves.

- **Never add AI co-authorship** — do not add `Co-Authored-By`, `Signed-off-by`, or any trailer that attributes the commit to an AI. Commits should appear as the user's own work.
- Write clear, conventional commit messages that describe the change
- Stage specific files rather than using `git add -A` or `git add .`
- Show `git status` and `git diff` before committing so the user can review
- Never commit files that contain secrets (`.env`, credentials, API keys)

## Coding Principles

This repository provides coding principles as Claude Code skills. Each skill triggers automatically based on the code you're working with. The principles are non-negotiable coding standards — if you are about to write code that violates a principle, stop and fix it. When reviewing code, flag any violations.
