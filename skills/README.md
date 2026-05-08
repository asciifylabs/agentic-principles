# Asciify Skills Catalog

Generated Agent Skills for Claude Code and Codex.

## Layout

Each principle skill is a directory:

```text
<skill>/
├── SKILL.md
├── agents/openai.yaml
└── references/principles.md
```

`SKILL.md` is the compact entrypoint. `references/principles.md` contains the full rule set and examples.

## Available Skills

| Skill | Scope |
| --- | --- |
| `ai-principles` | AI/ML, LLM, RAG, agents, evals, guardrails |
| `ansible-principles` | Ansible playbooks, roles, inventories |
| `docker-principles` | Dockerfiles, Compose, images, containers |
| `git-principles` | Git operations, commits, pull requests |
| `go-principles` | Go source, modules, tests |
| `kubernetes-principles` | Kubernetes manifests and Helm charts |
| `nodejs-principles` | JavaScript, TypeScript, package management |
| `python-principles` | Python code, packaging, tests, linting |
| `rust-principles` | Rust source, crates, tests |
| `security-principles` | Secure coding and supply-chain review |
| `shell-principles` | Shell scripts and Makefiles |
| `terraform-principles` | Terraform and OpenTofu infrastructure code |

## Management Commands

The `asciify-skills-*.md` files are Claude Code command prompts. They are installed into `.claude/commands/asciify-skills/` by `install.sh`.

Codex does not use these command files; it uses the generated skills under `.agents/skills`.

## Rebuild

From the repository root:

```bash
bash build-skills.sh
```
