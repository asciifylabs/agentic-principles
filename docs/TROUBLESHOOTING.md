# Troubleshooting Guide

Common issues and solutions for Asciify Skills.

## Table of Contents

- [Skills Not Loading](#skills-not-loading)
- [Slash Commands Not Available](#slash-commands-not-available)
- [Installation Issues](#installation-issues)
- [Update Issues](#update-issues)
- [Formatting Tools Not Found](#formatting-tools-not-found)
- [Wrong Skills Activating](#wrong-skills-activating)

---

## Skills Not Loading

**Symptoms:**

- Claude doesn't follow coding principles
- No skill-related behavior when editing code

**Solutions:**

1. **Check installation location:**

   ```bash
   # Global install:
   ls ~/.claude/skills/asciify-skills/
   # Local install:
   ls .claude/skills/asciify-skills/
   ```

2. **Verify skill files exist:**

   ```bash
   ls ~/.claude/skills/asciify-skills/*.md
   # Should list 11 principle files + 3 management skills
   ```

3. **Check skill frontmatter:**

   ```bash
   head -4 ~/.claude/skills/asciify-skills/python-principles.md
   # Should show:
   # ---
   # name: python-principles
   # description: "Use when writing..."
   # ---
   ```

4. **Reinstall:**

   ```bash
   curl -sSL https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/install.sh | bash -s -- --global
   ```

---

## Slash Commands Not Available

**Symptoms:**

- `/asciify-skills:update` not recognized
- `/asciify-skills:help` not available

**Solutions:**

1. **Verify management skills are installed:**

   ```bash
   ls ~/.claude/skills/asciify-skills/asciify-skills-*.md
   # Should list: update.md, uninstall.md, help.md
   ```

2. **Check skill name format:**

   ```bash
   grep "^name:" ~/.claude/skills/asciify-skills/asciify-skills-update.md
   # Should show: name: asciify-skills:update
   ```

3. **Start a new Claude Code session** — skills are loaded at session start.

---

## Installation Issues

**Symptoms:**

- Install script fails
- Permission errors
- Network errors

**Solutions:**

1. **Check curl is available:**

   ```bash
   command -v curl
   ```

2. **Check write permissions:**

   ```bash
   # For global install:
   mkdir -p ~/.claude/skills/asciify-skills && echo "OK"

   # For local install (must be in a git repo):
   git rev-parse --is-inside-work-tree
   ```

3. **Install from local clone:**

   ```bash
   git clone https://github.com/asciifylabs/asciify-skills.git /tmp/asciify-skills
   bash /tmp/asciify-skills/install.sh --global
   ```

4. **Corporate firewall:**

   ```bash
   # If behind a proxy:
   export https_proxy=http://proxy.example.com:8080
   curl -sSL https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/install.sh | bash -s -- --global
   ```

---

## Update Issues

**Symptoms:**

- `/asciify-skills:update` fails
- Cannot download latest version

**Solutions:**

1. **Check GitHub connectivity:**

   ```bash
   curl -I https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/skills/.version
   ```

2. **Update manually:**

   ```bash
   curl -sSL https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/install.sh | bash -s -- --global
   ```

3. **Check current version:**

   ```bash
   cat ~/.claude/skills/asciify-skills/.version
   ```

---

## Formatting Tools Not Found

**Symptoms:**

- Claude mentions a tool but it's not installed
- Linting steps skipped

**Solutions:**

Skills will suggest install commands for missing tools. Common installations:

```bash
# macOS (via Homebrew):
brew install shellcheck shfmt

# Python:
pip install ruff

# Node.js:
npm install -g eslint prettier

# Go:
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Rust:
rustup component add rustfmt clippy

# Terraform/OpenTofu:
brew install tflint
```

---

## Wrong Skills Activating

**Symptoms:**

- Unexpected principles applied
- Missing expected principles

**Solutions:**

Skills activate based on file types. If the wrong skill is loading:

1. **Check which files you're editing** — skills match on file extensions
2. **Review the skill's trigger description:**

   ```bash
   grep "^description:" ~/.claude/skills/asciify-skills/*-principles.md
   ```

3. **Remove unwanted skills** — delete individual skill files you don't need:

   ```bash
   rm ~/.claude/skills/asciify-skills/ansible-principles.md
   ```

---

## Migrating from Agentic Principles

If you previously used the `agentic-principles` package:

1. **Uninstall cleans up automatically:**

   ```bash
   curl -sSL https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/install.sh | bash -s -- --uninstall
   ```

   This removes both `asciify-skills` and legacy `agentic-principles` installations, including old hooks and version files.

2. **Install fresh:**

   ```bash
   curl -sSL https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/install.sh | bash -s -- --global
   ```

---

## Still Having Issues?

1. **Check system requirements:**
   - Bash 3.2+
   - curl
   - Git (for local installs)

2. **Report an issue:**
   - GitHub Issues: https://github.com/asciifylabs/asciify-skills/issues
   - Include error messages and your OS version
