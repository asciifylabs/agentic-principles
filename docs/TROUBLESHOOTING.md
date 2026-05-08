# Troubleshooting Guide

Common issues and fixes for Asciify Skills on Claude Code and Codex.

## Skills Not Loading

Check the install location for your agent:

```bash
# Claude Code global
ls ~/.claude/skills/python-principles/SKILL.md

# Claude Code project
ls .claude/skills/python-principles/SKILL.md

# Codex global
ls ~/.agents/skills/python-principles/SKILL.md

# Codex project
ls .agents/skills/python-principles/SKILL.md
```

Verify frontmatter:

```bash
head -12 ~/.claude/skills/python-principles/SKILL.md
head -12 ~/.agents/skills/python-principles/SKILL.md
```

Reinstall:

```bash
curl -sSL https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/install.sh | bash -s -- --global --agent both
```

Claude Code may detect edits live. Codex may need a restart if a newly installed skill does not appear.

## Claude Commands Not Available

The management commands are Claude-only command prompts.

Check:

```bash
ls ~/.claude/commands/asciify-skills/
ls .claude/commands/asciify-skills/
```

Expected files:

```text
update.md
uninstall.md
help.md
```

Restart Claude Code if the commands were installed after the session started.

## Codex Skill Invocation

Codex uses skills from `.agents/skills` and can invoke them implicitly from the description or explicitly with `$skill-name`.

Example:

```text
$python-principles review the changes in this package
```

If a skill does not appear, check `~/.agents/skills/<skill>/SKILL.md` or `.agents/skills/<skill>/SKILL.md` and restart Codex.

## Installation Issues

Check required tools:

```bash
command -v bash
command -v curl
command -v git
```

For local installs, run inside a Git repository:

```bash
git rev-parse --is-inside-work-tree
```

Install from a local clone when network access to raw GitHub URLs is blocked:

```bash
git clone https://github.com/asciifylabs/asciify-skills.git /tmp/asciify-skills
bash /tmp/asciify-skills/install.sh --global --agent both
```

Behind a corporate proxy:

```bash
export https_proxy=http://proxy.example.com:8080
curl -sSL https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/install.sh | bash -s -- --global --agent both
```

## Update Issues

Check GitHub connectivity:

```bash
curl -I https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/skills/.version
```

Check installed version markers:

```bash
cat ~/.claude/skills/.asciify-skills-version
cat ~/.agents/skills/.asciify-skills-version
```

Update by running the installer again:

```bash
curl -sSL https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/install.sh | bash -s -- --global --agent both
```

## Formatting Tools Not Found

Skills prefer project scripts and existing CI commands. If a fallback tool is missing, install the tool or note that validation was skipped.

Common tools:

```bash
# Shell
brew install shellcheck shfmt

# Python
pipx install ruff
pipx install pip-audit

# Go
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install golang.org/x/vuln/cmd/govulncheck@latest

# Rust
rustup component add rustfmt clippy
cargo install cargo-audit cargo-deny

# Infrastructure and security
brew install tflint trivy gitleaks
```

## Wrong Skills Activating

Skill matching is description-driven in both agents. Claude Code can also use `paths` from frontmatter. If activation is noisy:

```bash
grep "^description:" ~/.claude/skills/*-principles/SKILL.md
grep "^paths:" ~/.claude/skills/*-principles/SKILL.md
```

Remove an Asciify skill by deleting its directory:

```bash
rm -rf ~/.claude/skills/ansible-principles
rm -rf ~/.agents/skills/ansible-principles
```

## Migrating From Old Layouts

Older installs used grouped Claude paths such as `~/.claude/skills/asciify-skills/`. The installer removes those legacy grouped installs during uninstall and installs current skills directly under each agent's skills root.

```bash
curl -sSL https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/install.sh | bash -s -- --uninstall --agent both
curl -sSL https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/install.sh | bash -s -- --global --agent both
```

## Still Having Issues?

Open an issue with:

- operating system
- agent used: Claude Code, Codex, or both
- install command
- relevant error output

GitHub Issues: https://github.com/asciifylabs/asciify-skills/issues
