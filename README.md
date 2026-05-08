# Asciify Skills

Curated engineering principles packaged as portable Agent Skills for Claude Code and Codex.

Asciify Skills gives coding agents compact, automatically discoverable guidance for common engineering domains: Python, Go, Rust, Node.js, Docker, Kubernetes, Terraform/OpenTofu, Ansible, Shell, Git, AI applications, and general security.

## What Changed

This repository now targets the shared Agent Skills format instead of a Claude-only layout.

- Each skill is a directory with `SKILL.md`.
- `SKILL.md` stays concise so it can be loaded often without crowding the agent context.
- Detailed examples and full principle text live in `references/principles.md`.
- Codex UI metadata lives in `agents/openai.yaml`.
- Claude Code path activation uses `paths`; legacy `globs` are retained for older Claude-oriented consumers.
- Codex activation relies on the skill `description` and explicit `$skill-name` invocation.

## Quick Start

Install globally for both Claude Code and Codex:

```bash
curl -sSL https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/install.sh | bash -s -- --global --agent both
```

Install locally into the current repository:

```bash
curl -sSL https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/install.sh | bash -s -- --local --agent both
```

Install for only one agent:

```bash
# Claude Code only
curl -sSL https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/install.sh | bash -s -- --global --agent claude

# Codex only
curl -sSL https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/install.sh | bash -s -- --global --agent codex
```

Uninstall:

```bash
curl -sSL https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/install.sh | bash -s -- --uninstall --agent both
```

## Install Locations

| Agent | Global skills | Project skills |
| --- | --- | --- |
| Claude Code | `~/.claude/skills/<skill>/SKILL.md` | `.claude/skills/<skill>/SKILL.md` |
| Codex | `~/.agents/skills/<skill>/SKILL.md` | `.agents/skills/<skill>/SKILL.md` |

Claude management commands are installed to:

```text
~/.claude/commands/asciify-skills/
.claude/commands/asciify-skills/
```

Codex uses skills directly from `.agents/skills`; no slash command files are installed for Codex.

## Available Skills

| Skill | Scope |
| --- | --- |
| `ai-principles` | LLM apps, RAG, agents, embeddings, tool calling, evals, guardrails |
| `ansible-principles` | Playbooks, roles, inventories, templates, Molecule tests |
| `docker-principles` | Dockerfiles, Compose files, image builds, scanning, runtime hardening |
| `git-principles` | Commits, staging, branches, history, PR hygiene, secret prevention |
| `go-principles` | Go modules, tests, concurrency, errors, linting, dependencies |
| `kubernetes-principles` | Manifests, Helm charts, RBAC, policies, workloads, validation |
| `nodejs-principles` | JavaScript, TypeScript, package management, linting, tests |
| `python-principles` | Python code, packaging, pytest, typing, Ruff, dependency management |
| `rust-principles` | Rust code, crates, error handling, async, tests, dependency policy |
| `security-principles` | Secure coding, secrets, auth, supply chain, scanning, reviews |
| `shell-principles` | Shell scripts, Makefiles, quoting, traps, ShellCheck, shfmt |
| `terraform-principles` | Terraform/OpenTofu modules, state, providers, policy checks, IaC review |

## Skill Layout

Each generated skill uses this structure:

```text
skills/<skill-name>/
├── SKILL.md
├── agents/
│   └── openai.yaml
└── references/
    └── principles.md
```

The active `SKILL.md` contains:

- concise trigger metadata
- Claude `paths` and legacy `globs` where file patterns are useful
- a short operating checklist
- validation commands
- a pointer to `references/principles.md`

The detailed reference is loaded only when the agent needs examples, edge cases, or a deeper review checklist.

## Management Commands

Claude Code users get:

| Command | Purpose |
| --- | --- |
| `/asciify-skills:update` | Update installed skills from GitHub |
| `/asciify-skills:uninstall` | Remove installed skills |
| `/asciify-skills:help` | Show status and installed skills |

Codex users can invoke installed skills explicitly with `$skill-name`, for example:

```text
$python-principles review the changes in this package
```

## Standards Refresh

The active checklists have been updated around current common practice:

- Progressive disclosure for skills: compact entrypoint, detailed references on demand.
- Python: `pyproject.toml`, Ruff, pytest, pyright/mypy, lock-capable dependency workflows such as uv, Poetry, PDM, or pip-tools.
- Node.js: TypeScript strictness, one package manager, lock-file installs, package manager metadata, modern ESLint/Prettier/Biome-aware workflows.
- Go: Go modules, `gofmt`, `go test`, `go vet`, `golangci-lint`, `govulncheck`, context-aware concurrency.
- Rust: `cargo fmt`, `clippy`, `cargo test`, explicit errors, limited `unwrap`, dependency policy checks.
- Docker: multi-stage builds, minimal images, pinned bases, non-root runtime, BuildKit secrets, SBOM/provenance, image scanning.
- Kubernetes: Pod Security Standards, RBAC, network policies, probes, resource controls, schema and policy validation.
- Terraform/OpenTofu: remote encrypted state, provider/version pinning, CI plan review, Trivy/Checkov/OPA-style policy checks.
- Security: OWASP-style secure coding, secret detection, SCA, SBOMs, provenance, and supply-chain controls.
- AI: prompt injection resistance, structured outputs, bounded tool use, evals, observability, model routing, and GenAI security controls.

## Rebuilding

The generated skills are built from the category directories (`python/`, `go/`, `security/`, etc.).

```bash
bash build-skills.sh
```

Run the test suite:

```bash
bash test.sh
```

## Manual Install

For Claude Code:

```bash
mkdir -p ~/.claude/skills
cp -R skills/python-principles ~/.claude/skills/
```

For Codex:

```bash
mkdir -p ~/.agents/skills
cp -R skills/python-principles ~/.agents/skills/
```

Repeat for each skill you want installed.

## License

MIT. See [LICENSE](LICENSE).
