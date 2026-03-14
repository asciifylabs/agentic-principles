# Asciify Skills

These skills provide coding principles, linting, and security scanning for Claude Code.

## Available Skills

| Skill | Triggers On |
|-------|------------|
| `security-principles` | All code (always active) |
| `docker-principles` | Dockerfile, docker-compose files, container configs |
| `shell-principles` | .sh, .bash, Makefile, Dockerfile |
| `go-principles` | .go, go.mod, go.sum |
| `python-principles` | .py, pyproject.toml, requirements.txt |
| `nodejs-principles` | .js, .ts, .tsx, package.json |
| `rust-principles` | .rs, Cargo.toml |
| `terraform-principles` | .tf, .tfvars (Terraform and OpenTofu) |
| `ansible-principles` | playbooks, roles, ansible.cfg |
| `kubernetes-principles` | Kubernetes manifests, Helm charts |
| `ai-principles` | AI/ML code (OpenAI, Anthropic, LangChain, etc.) |
| `git-principles` | Git operations and commits |

## Management Commands

| Command | What it does |
|---------|-------------|
| `/asciify-skills:update` | Update to the latest version |
| `/asciify-skills:uninstall` | Remove asciify-skills |
| `/asciify-skills:help` | Show status and help |

## What Each Skill Includes

1. **Coding principles** — non-negotiable standards for that language/domain
2. **Linting instructions** — which tools to run and how (language skills)
3. **Security scanning** — trivy, semgrep, gitleaks, OWASP top 10 detection (security skill)

## Rebuilding Skills

If you modify the source principle files in the category directories, regenerate the skills:

```bash
bash build-skills.sh
```
