---
name: asciify-skills:help
description: "Show asciify-skills status for Claude Code and Codex"
---

# Asciify Skills Help

Show the user the current status of their asciify-skills installation.

## Steps

1. Check for installations:
   - Claude global skills: `~/.claude/skills/<skill>/`
   - Claude global commands: `~/.claude/commands/asciify-skills/`
   - Claude local skills: `.claude/skills/<skill>/`
   - Claude local commands: `.claude/commands/asciify-skills/`
   - Codex global skills: `~/.agents/skills/<skill>/`
   - Codex local skills: `.agents/skills/<skill>/`

2. For each installation found, read `.asciify-skills-version` and list installed skill directories that contain `.asciify-skills`.

3. Display a summary like:

```
Asciify Skills — Status

Claude skills location: ~/.claude/skills/
Commands location: ~/.claude/commands/asciify-skills/
Version: <sha from .asciify-skills-version>

Installed skills (auto-triggered):
  - ai-principles          — AI/ML code
  - ansible-principles      — Ansible playbooks and roles
  - docker-principles       — Dockerfiles and containers
  - git-principles          — Git operations
  - go-principles           — Go code
  - kubernetes-principles   — Kubernetes manifests and Helm charts
  - nodejs-principles       — JavaScript/TypeScript
  - python-principles       — Python code
  - rust-principles         — Rust code
  - security-principles     — All code and security-sensitive review
  - shell-principles        — Shell scripts
  - terraform-principles    — Terraform/OpenTofu code

Commands:
  /asciify-skills:update      — Update to the latest version
  /asciify-skills:uninstall   — Remove asciify-skills
  /asciify-skills:help        — Show this help
```

For Codex installations, show:

```
Codex skills location: ~/.agents/skills/
Version: <sha from .asciify-skills-version>
Invocation: implicit by description, or explicit with $skill-name
```

4. If no installation is found, tell the user how to install:
```
Asciify Skills is not installed. Install with:

  curl -sSL https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/install.sh | bash -s -- --global --agent both
```
