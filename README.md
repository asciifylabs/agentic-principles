# Infrastructure Principles

Coding standards and best practices for this infrastructure repository. Each principle is a short, actionable reference with rules and examples.

## Quick Start

Install hooks to automatically fetch principles and enforce code quality:

```bash
curl -sSL https://raw.githubusercontent.com/Exobitt/principles/main/install.sh | bash
```

This will:

- ✅ Auto-fetch principles after `git checkout` and `git pull`
- ✅ Auto-format and lint code before commits
- ✅ Set up everything with one command

## Installation Options

### Option 1: Automated Installation (Recommended)

**Full Installation** (principles + formatting):

```bash
curl -sSL https://raw.githubusercontent.com/Exobitt/principles/main/install.sh | bash
```

**Principles Only** (no auto-formatting):

```bash
curl -sSL https://raw.githubusercontent.com/Exobitt/principles/main/install.sh | bash -s -- --principles-only
```

**Formatting Only** (no principles):

```bash
curl -sSL https://raw.githubusercontent.com/Exobitt/principles/main/install.sh | bash -s -- --formatting-only
```

**With Auto-Install Tools**:

```bash
curl -sSL https://raw.githubusercontent.com/Exobitt/principles/main/install.sh | bash -s -- --auto-install-tools
```

### Option 2: Claude Code Session Hook

To automatically load principles when starting Claude Code sessions:

1. Open `~/.claude/settings.json`
2. Add this configuration:

```json
{
  "sessionStartHooks": [
    {
      "name": "Load Coding Principles",
      "command": "bash",
      "args": [
        "-c",
        "bash /path/to/fetch-principles.sh && cat /tmp/claude-principles-active.md"
      ],
      "timeout": 30000
    }
  ]
}
```

See [hooks/claude-code/README.md](hooks/claude-code/README.md) for detailed setup.

### Option 3: Manual Execution (No Hooks)

Copy and paste the script from [CLAUDE.md](CLAUDE.md) at the start of each Claude session.

## How It Works

### Automatic Principles Fetching

The hook system automatically detects technologies in your repository:

- **Shell**: Detects `*.sh` files
- **Terraform**: Detects `*.tf` files
- **Ansible**: Detects `ansible.cfg`, `playbooks/`, or `roles/`
- **Kubernetes**: Detects `Chart.yaml`, `kustomization.yaml`, or manifests
- **Node.js**: Detects `package.json` or `*.js`/`*.ts` files

Detected principles are cached in `/tmp/claude-principles-active.md` for fast access.

**Git hooks run automatically:**

- `post-checkout`: After switching branches
- `post-merge`: After pulling changes

**Performance:**

- Hooks run in the background (non-blocking)
- Uses shallow git clone for speed
- Caches repository locally
- Concurrent execution prevented with lockfile

### Code Formatting and Linting

The pre-commit hook automatically formats and lints staged files before commits:

**Supported file types:**

- **Shell** (`*.sh`): `shellcheck` (linting) + `shfmt` (formatting)
- **Markdown** (`*.md`): `prettier`
- **JavaScript/TypeScript** (`*.js`, `*.ts`, `*.tsx`): `prettier` + `eslint`
- **JSON** (`*.json`): `prettier`
- **YAML** (`*.yml`, `*.yaml`): `prettier`

**What happens on commit:**

1. Pre-commit hook runs automatically
2. Detects file types from staged files
3. Runs appropriate formatters/linters
4. Auto-fixes formatting issues
5. Re-stages modified files
6. Blocks commit if unfixable issues exist

**Skip formatting when needed:**

```bash
git commit --no-verify
```

## Formatting/Linting Configuration

### Tool Installation

The installer checks for required tools and prompts you to install missing ones:

```bash
# Install all tools at once:
npm install -g prettier eslint shellcheck shfmt

# Or individually:
npm install -g prettier    # JS/TS/JSON/YAML formatting
npm install -g eslint      # JS/TS linting
npm install -g shellcheck  # Shell script linting
npm install -g shfmt       # Shell script formatting

# Alternative package managers:
brew install prettier eslint shellcheck shfmt  # macOS
sudo apt install shellcheck                    # Ubuntu/Debian
```

### Customizing Formatters

Create configuration files in your project root to customize formatting:

**`.prettierrc`** (JavaScript, TypeScript, JSON, YAML, Markdown):

```json
{
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "semi": true,
  "singleQuote": false,
  "trailingComma": "es5"
}
```

**`.eslintrc.json`** (JavaScript, TypeScript linting):

```json
{
  "extends": ["eslint:recommended"],
  "rules": {
    "indent": ["error", 2],
    "quotes": ["error", "single"]
  }
}
```

**`.editorconfig`** (All files):

```ini
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
```

**Ignore files** (`.prettierignore`, `.eslintignore`):

```
node_modules/
dist/
build/
*.min.js
```

The hooks will respect your configuration files automatically.

## Uninstalling

```bash
curl -sSL https://raw.githubusercontent.com/Exobitt/principles/main/install.sh | bash -s -- --uninstall
```

This will:

- Remove installed hooks
- Restore original hooks from backups
- Clean up downloaded scripts

**Manual uninstall:**

```bash
cd /path/to/your/repo
rm -f .git/hooks/fetch-principles.sh
rm -f .git/hooks/format-lint.sh
rm -f .git/hooks/post-checkout
rm -f .git/hooks/post-merge
rm -f .git/hooks/pre-commit

# Restore backups if they exist:
for hook in .git/hooks/*.backup-original; do
  [ -f "$hook" ] && mv "$hook" "${hook%.backup-original}"
done
```

## Troubleshooting

For common issues and solutions, see [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

**Quick checks:**

- Git hooks not running? Check permissions: `chmod +x .git/hooks/*`
- Principles not updating? Clear cache: `rm -rf /tmp/claude-principles-repo`
- Formatting tools missing? Install with: `npm install -g prettier eslint shellcheck shfmt`
- Need verbose output? Run with: `VERBOSE=true bash .git/hooks/fetch-principles.sh`

---

## Principles Reference

## Shell Scripting (`shell/`)

| #   | Principle                                                                    |
| --- | ---------------------------------------------------------------------------- |
| 001 | [Use `set -euo pipefail`](shell/001-use-set-euo-pipefail.md)                 |
| 002 | [Use Functions for Reusability](shell/002-use-functions-for-reusability.md)  |
| 003 | [Proper Error Handling](shell/003-proper-error-handling.md)                  |
| 004 | [Always Quote Variables](shell/004-quote-variables.md)                       |
| 005 | [Use Local Variables in Functions](shell/005-use-local-variables.md)         |
| 006 | [Validate All Inputs](shell/006-validate-inputs.md)                          |
| 007 | [Use Temporary Files Safely](shell/007-use-temporary-files-safely.md)        |
| 008 | [Structured Logging](shell/008-logging-best-practices.md)                    |
| 009 | [Avoid Hardcoded Paths](shell/009-avoid-hardcoded-paths.md)                  |
| 010 | [Use Here Documents](shell/010-use-here-documents.md)                        |
| 011 | [Check Command Existence](shell/011-check-command-existence.md)              |
| 012 | [Use Arrays for Multiple Values](shell/012-use-array-for-multiple-values.md) |

## Ansible (`ansible/`)

| #   | Principle                                                                           |
| --- | ----------------------------------------------------------------------------------- |
| 001 | [Use Roles Over Playbooks](ansible/001-use-roles-over-playbooks.md)                 |
| 002 | [Write Idempotent Tasks](ansible/002-use-idempotent-tasks.md)                       |
| 003 | [Use Variables and Defaults](ansible/003-use-variables-and-defaults.md)             |
| 004 | [Use Handlers for Notifications](ansible/004-use-handlers-for-notifications.md)     |
| 005 | [Use Templates Over Static Files](ansible/005-use-templates-over-static-files.md)   |
| 006 | [Use Tags for Selective Execution](ansible/006-use-tags-for-selective-execution.md) |
| 007 | [Use Facts Wisely](ansible/007-use-facts-wisely.md)                                 |
| 008 | [Use Blocks for Error Handling](ansible/008-use-blocks-for-error-handling.md)       |
| 009 | [Use Vault for Secrets](ansible/009-use-vault-for-secrets.md)                       |
| 010 | [Use Inventories Effectively](ansible/010-use-inventories-effectively.md)           |
| 011 | [Use Conditional Logic](ansible/011-use-conditional-logic.md)                       |
| 012 | [Use Loops Efficiently](ansible/012-use-loops-efficiently.md)                       |

## Terraform (`terraform/`)

| #   | Principle                                                                                         |
| --- | ------------------------------------------------------------------------------------------------- |
| 001 | [Use Modules for Reusability](terraform/001-use-modules-for-reusability.md)                       |
| 002 | [Use Remote State](terraform/002-use-remote-state.md)                                             |
| 003 | [Use Workspaces or Separate Directories](terraform/003-use-workspaces-or-separate-directories.md) |
| 004 | [Use Variables and Outputs](terraform/004-use-variables-and-outputs.md)                           |
| 005 | [Use Data Sources](terraform/005-use-data-sources.md)                                             |
| 006 | [Use Lifecycle Rules](terraform/006-use-lifecycle-rules.md)                                       |
| 007 | [Use Terraform Cloud or CI/CD](terraform/007-use-terraform-cloud-or-ci-cd.md)                     |
| 008 | [Use Provider Version Constraints](terraform/008-use-provider-version-constraints.md)             |
| 009 | [Use `terraform fmt` and `validate`](terraform/009-use-terraform-fmt-and-validate.md)             |
| 010 | [Use Resource Tags](terraform/010-use-resource-tags.md)                                           |
| 011 | [Use Locals for Computed Values](terraform/011-use-locals-for-computed-values.md)                 |
| 012 | [Use Workspaces Carefully](terraform/012-use-terraform-workspaces-carefully.md)                   |
| 013 | [Understand Dependency Graphs](terraform/013-use-dependency-graphs.md)                            |

## Kubernetes (`kubernetes/`)

### General

| #   | Principle                                                                                            |
| --- | ---------------------------------------------------------------------------------------------------- |
| 001 | [Use Namespaces for Isolation](kubernetes/001-use-namespaces-for-isolation.md)                       |
| 002 | [Set Resource Requests and Limits](kubernetes/002-set-resource-requests-and-limits.md)               |
| 003 | [Use Liveness and Readiness Probes](kubernetes/003-use-liveness-and-readiness-probes.md)             |
| 004 | [Use ConfigMaps and Secrets Properly](kubernetes/004-use-configmaps-and-secrets-properly.md)         |
| 005 | [Use Labels and Annotations Consistently](kubernetes/005-use-labels-and-annotations-consistently.md) |
| 006 | [Use PodDisruptionBudgets](kubernetes/006-use-poddisruptionbudgets.md)                               |
| 007 | [Use Network Policies](kubernetes/007-use-network-policies.md)                                       |
| 008 | [Use RBAC Properly](kubernetes/008-use-rbac-properly.md)                                             |
| 009 | [Use Pod Security Standards](kubernetes/009-use-pod-security-standards.md)                           |
| 010 | [Use Priority Classes](kubernetes/010-use-priority-classes.md)                                       |

### Cilium Networking

| #   | Principle                                                                               |
| --- | --------------------------------------------------------------------------------------- |
| 011 | [Choose the Right Routing Mode](kubernetes/011-cilium-choose-routing-mode.md)           |
| 012 | [Configure MTU Properly](kubernetes/012-cilium-configure-mtu-properly.md)               |
| 013 | [Enable Hubble for Observability](kubernetes/013-cilium-enable-hubble-observability.md) |
| 014 | [Use Kube-Proxy Replacement](kubernetes/014-cilium-kubeproxy-replacement.md)            |
| 015 | [Configure Masquerading Correctly](kubernetes/015-cilium-configure-masquerading.md)     |
| 016 | [Use CiliumNetworkPolicies](kubernetes/016-cilium-network-policies.md)                  |
| 017 | [Configure eBPF for Performance](kubernetes/017-cilium-ebpf-configuration.md)           |
| 018 | [Enable Bandwidth Manager](kubernetes/018-cilium-bandwidth-manager.md)                  |
