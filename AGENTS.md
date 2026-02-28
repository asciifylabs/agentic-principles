# Agentic Principles

## Git Commit Policy

You MAY commit when the user asks you to. **Never run `git push`** — always let the user push themselves.

- **Never add AI co-authorship** — do not add `Co-Authored-By`, `Signed-off-by`, or any trailer that attributes the commit to an AI. Commits should appear as the user's own work.
- Write clear, conventional commit messages that describe the change
- Stage specific files rather than using `git add -A` or `git add .`
- Show `git status` and `git diff` before committing so the user can review
- Never commit files that contain secrets (`.env`, credentials, API keys)

## Initialization

At the start of every conversation, you MUST run the following script and then read `/tmp/claude-principles-active.md` before doing any work.

The script will:

1. **Always** -- install git hooks (formatting, linting, principles auto-update)
2. **If detected** -- load coding principles for technologies present in this project
3. **If present** -- include project ADRs from `docs/adr/`, `adr/`, or similar directories

These are non-negotiable coding standards -- if you are about to write code that violates a principle, stop and fix it. When reviewing code, flag any violations.

If the user asks you to work with a technology that wasn't initially detected, re-run the script with the category appended (e.g. `EXTRA_CATEGORIES="ansible kubernetes"`).

```sh
#!/bin/bash
set -euo pipefail

REPO_DIR="/tmp/claude-principles-repo"
REPO_SSH="git@github.com:asciifylabs/agentic-principles.git"
REPO_HTTPS="https://github.com/asciifylabs/agentic-principles.git"

# Clone if not present (first run only)
if [ ! -d "$REPO_DIR/.git" ]; then
  rm -rf "$REPO_DIR"
  git clone --depth 1 -q "$REPO_SSH" "$REPO_DIR" 2>/dev/null || \
  git clone --depth 1 -q "$REPO_HTTPS" "$REPO_DIR" 2>/dev/null || \
  { echo "Failed to clone principles repo" >&2; exit 1; }
fi

# Install hooks if not already present in this repo
if [ ! -f ".git/hooks/fetch-principles.sh" ]; then
  bash "$REPO_DIR/install.sh" --non-interactive
else
  # Fetch principles with caching (only updates when remote main changes)
  bash "$REPO_DIR/.claude/hooks/fetch-principles.sh"
fi
```
