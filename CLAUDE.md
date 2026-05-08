# Asciify Skills

## Git Commit Policy

You MAY commit when the user asks you to. **Never run `git push`** — always let the user push themselves.

- **Never add AI co-authorship** — do not add `Co-Authored-By`, `Signed-off-by`, or any trailer that attributes the commit to an AI. Commits should appear as the user's own work.
- Write clear, conventional commit messages that describe the change
- Stage specific files rather than using `git add -A` or `git add .`
- Show `git status` and `git diff` before committing so the user can review
- Never commit files that contain secrets (`.env`, credentials, API keys)

## Coding Principles

This repository provides coding principles as portable Agent Skills for Claude Code and Codex. Each generated skill has a compact `SKILL.md` entrypoint and a detailed `references/principles.md` file for examples and edge cases.

- Rebuild generated skills with `bash build-skills.sh` after changing source principles
- Run `bash test.sh` before committing generator, installer, or skill layout changes
- Keep active `SKILL.md` content concise; put detailed guidance in references
