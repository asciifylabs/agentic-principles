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

See [.claude/hooks/README.md](.claude/hooks/README.md) for detailed setup.

### Option 3: Manual Execution (No Hooks)

Copy and paste the script from [CLAUDE.md](CLAUDE.md) at the start of each Claude session.

## How It Works

### Automatic Principles Fetching

The hook system automatically detects technologies in your repository:

- **Security**: **Always loaded** — language-agnostic code security and quality standards (OWASP, secrets management, input validation, secure defaults, etc.)
- **Shell**: Detects `*.sh` files
- **Terraform**: Detects `*.tf` files
- **Ansible**: Detects `ansible.cfg`, `playbooks/`, or `roles/`
- **Kubernetes**: Detects `Chart.yaml`, `kustomization.yaml`, or manifests
- **Node.js**: Detects `package.json` or `*.js`/`*.ts` files
- **Python**: Detects `*.py` files, `requirements.txt`, `pyproject.toml`, or `setup.py`
- **Go**: Detects `go.mod`, `go.sum`, or `*.go` files
- **Rust**: Detects `Cargo.toml`, `Cargo.lock`, or `*.rs` files

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

## Security (`security/`) — Always Loaded

| #   | Principle                                                                                                |
| --- | -------------------------------------------------------------------------------------------------------- |
| 001 | [Never Hardcode Secrets](security/001-never-hardcode-secrets.md)                                         |
| 002 | [Validate and Sanitize All Inputs](security/002-validate-and-sanitize-inputs.md)                         |
| 003 | [Use Parameterized Queries](security/003-use-parameterized-queries.md)                                   |
| 004 | [Prevent Cross-Site Scripting (XSS)](security/004-prevent-cross-site-scripting.md)                       |
| 005 | [Implement Authentication Properly](security/005-implement-authentication-properly.md)                   |
| 006 | [Enforce Authorization and Least Privilege](security/006-enforce-authorization-and-least-privilege.md)   |
| 007 | [Protect Against CSRF](security/007-protect-against-csrf.md)                                             |
| 008 | [Use HTTPS and Secure Communication](security/008-use-https-and-secure-communication.md)                 |
| 009 | [Handle Errors Without Leaking Information](security/009-handle-errors-without-leaking-information.md)   |
| 010 | [Log Security Events](security/010-log-security-events.md)                                               |
| 011 | [Keep Dependencies Secure](security/011-keep-dependencies-secure.md)                                     |
| 012 | [Use Secure Defaults](security/012-use-secure-defaults.md)                                               |
| 013 | [Protect Sensitive Data](security/013-protect-sensitive-data.md)                                         |
| 014 | [Prevent Injection Attacks](security/014-prevent-injection-attacks.md)                                   |
| 015 | [Implement Rate Limiting](security/015-implement-rate-limiting.md)                                       |
| 016 | [Use Static Analysis and Linting](security/016-use-static-analysis-and-linting.md)                       |
| 017 | [Write Security-Focused Tests](security/017-write-security-focused-tests.md)                             |
| 018 | [Follow Secure Code Review Practices](security/018-follow-secure-code-review-practices.md)               |

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

## Node.js/JavaScript (`nodejs/`)

| #   | Principle                                                                                  |
| --- | ------------------------------------------------------------------------------------------ |
| 001 | [Use Async/Await Over Callbacks](nodejs/001-use-async-await-over-callbacks.md)             |
| 002 | [Use Environment Variables for Config](nodejs/002-use-environment-variables-for-config.md) |
| 003 | [Use Proper Error Handling](nodejs/003-use-proper-error-handling.md)                       |
| 004 | [Use package.json Scripts](nodejs/004-use-package-json-scripts.md)                         |
| 005 | [Use ESLint and Prettier](nodejs/005-use-eslint-and-prettier.md)                           |
| 006 | [Use ESM Modules Consistently](nodejs/006-use-esm-modules-consistently.md)                 |
| 007 | [Lock Dependencies](nodejs/007-lock-dependencies.md)                                       |
| 008 | [Use Structured Logging](nodejs/008-use-structured-logging.md)                             |
| 009 | [Validate Inputs](nodejs/009-validate-inputs.md)                                           |
| 010 | [Use Dependency Injection](nodejs/010-use-dependency-injection.md)                         |
| 011 | [Handle Promises Properly](nodejs/011-handle-promises-properly.md)                         |
| 012 | [Use TypeScript for Type Safety](nodejs/012-use-typescript-for-type-safety.md)             |
| 013 | [Use Security Best Practices](nodejs/013-use-security-best-practices.md)                   |
| 014 | [Organize Project Structure](nodejs/014-organize-project-structure.md)                     |
| 015 | [Use Graceful Shutdown](nodejs/015-use-graceful-shutdown.md)                               |

## Python (`python/`)

### General Best Practices

| #   | Principle                                                                          |
| --- | ---------------------------------------------------------------------------------- |
| 001 | [Use Type Hints](python/001-use-type-hints.md)                                     |
| 002 | [Use Context Managers](python/002-use-context-managers.md)                         |
| 003 | [Follow PEP 8 Style Guide](python/003-follow-pep8-style-guide.md)                  |
| 004 | [Use Virtual Environments](python/004-use-virtual-environments.md)                 |
| 005 | [Write Comprehensive Docstrings](python/005-write-comprehensive-docstrings.md)     |
| 006 | [Handle Exceptions Properly](python/006-handle-exceptions-properly.md)             |
| 007 | [Use pathlib Over os.path](python/007-use-pathlib-over-os-path.md)                 |
| 008 | [Use Structured Logging](python/008-use-structured-logging.md)                     |
| 009 | [Avoid Mutable Default Arguments](python/009-avoid-mutable-default-arguments.md)   |
| 010 | [Use Comprehensions Appropriately](python/010-use-comprehensions-appropriately.md) |
| 011 | [Use Dataclasses](python/011-use-dataclasses.md)                                   |
| 012 | [Use f-strings for Formatting](python/012-use-f-strings-for-formatting.md)         |
| 013 | [Write Unit Tests with pytest](python/013-write-unit-tests-with-pytest.md)         |
| 014 | [Use Async/Await for I/O Operations](python/014-use-async-await-for-io.md)         |
| 015 | [Manage Dependencies Properly](python/015-manage-dependencies-properly.md)         |
| 016 | [Use Static Type Checking](python/016-use-static-type-checking.md)                 |
| 017 | [Follow Security Best Practices](python/017-follow-security-best-practices.md)     |

### AI Development

| #   | Principle                                                                                |
| --- | ---------------------------------------------------------------------------------------- |
| 018 | [Manage API Keys Securely](python/018-manage-api-keys-securely.md)                       |
| 019 | [Handle API Rate Limits](python/019-handle-api-rate-limits.md)                           |
| 020 | [Use Streaming for Large Outputs](python/020-use-streaming-for-large-outputs.md)         |
| 021 | [Implement Proper Prompt Engineering](python/021-implement-proper-prompt-engineering.md) |
| 022 | [Use Vector Databases](python/022-use-vector-databases.md)                               |
| 023 | [Implement Response Caching](python/023-implement-response-caching.md)                   |
| 024 | [Use Structured Outputs](python/024-use-structured-outputs.md)                           |
| 025 | [Monitor Token Usage and Costs](python/025-monitor-token-usage-and-costs.md)             |

## Go (`go/`)

| #   | Principle                                                                    |
| --- | ---------------------------------------------------------------------------- |
| 001 | [Use Go Modules for Dependencies](go/001-use-go-modules.md)                  |
| 002 | [Handle Errors Explicitly](go/002-handle-errors-explicitly.md)               |
| 003 | [Use Interfaces for Abstraction](go/003-use-interfaces-for-abstraction.md)   |
| 004 | [Follow Effective Go Guidelines](go/004-follow-effective-go.md)              |
| 005 | [Use gofmt and Linters](go/005-use-gofmt-and-linters.md)                     |
| 006 | [Write Table-Driven Tests](go/006-write-table-driven-tests.md)               |
| 007 | [Use Context for Cancellation](go/007-use-context-for-cancellation.md)       |
| 008 | [Use Channels for Communication](go/008-use-channels-for-communication.md)   |
| 009 | [Avoid Goroutine Leaks](go/009-avoid-goroutine-leaks.md)                     |
| 010 | [Use Defer for Cleanup](go/010-use-defer-for-cleanup.md)                     |
| 011 | [Use Struct Embedding Over Inheritance](go/011-use-struct-embedding.md)      |
| 012 | [Keep Interfaces Small](go/012-keep-interfaces-small.md)                     |
| 013 | [Use Standard Library Packages](go/013-use-standard-library.md)              |
| 014 | [Avoid Package-Level State](go/014-avoid-package-level-state.md)             |
| 015 | [Use Meaningful Variable Names](go/015-use-meaningful-names.md)              |
| 016 | [Handle Panics Appropriately](go/016-handle-panics-appropriately.md)         |
| 017 | [Use Buffered Channels Carefully](go/017-use-buffered-channels-carefully.md) |
| 018 | [Follow Standard Project Layout](go/018-follow-project-layout.md)            |
| 019 | [Use Build Tags for Conditional Compilation](go/019-use-build-tags.md)       |
| 020 | [Write Benchmarks for Performance](go/020-write-benchmarks.md)               |

## Rust (`rust/`)

| #   | Principle                                                                        |
| --- | -------------------------------------------------------------------------------- |
| 001 | [Embrace Ownership and Borrowing](rust/001-embrace-ownership-and-borrowing.md)   |
| 002 | [Use Result and Option for Error Handling](rust/002-use-result-and-option.md)    |
| 003 | [Leverage the Type System](rust/003-leverage-the-type-system.md)                 |
| 004 | [Use Cargo Effectively](rust/004-use-cargo-effectively.md)                       |
| 005 | [Follow Rust API Guidelines](rust/005-follow-api-guidelines.md)                  |
| 006 | [Use rustfmt and clippy](rust/006-use-rustfmt-and-clippy.md)                     |
| 007 | [Write Comprehensive Tests](rust/007-write-comprehensive-tests.md)               |
| 008 | [Use Traits for Shared Behavior](rust/008-use-traits-for-shared-behavior.md)     |
| 009 | [Prefer Iterators Over Loops](rust/009-prefer-iterators-over-loops.md)           |
| 010 | [Use Pattern Matching](rust/010-use-pattern-matching.md)                         |
| 011 | [Avoid unwrap in Production](rust/011-avoid-unwrap-in-production.md)             |
| 012 | [Use Smart Pointers Appropriately](rust/012-use-smart-pointers-appropriately.md) |
| 013 | [Use async/await for Concurrency](rust/013-use-async-await-for-concurrency.md)   |
| 014 | [Implement Error Types Properly](rust/014-implement-error-types-properly.md)     |
| 015 | [Use Macros Sparingly](rust/015-use-macros-sparingly.md)                         |
| 016 | [Follow Module Organization](rust/016-follow-module-organization.md)             |
| 017 | [Use Lifetimes When Necessary](rust/017-use-lifetimes-when-necessary.md)         |
| 018 | [Prefer &str Over String for Parameters](rust/018-prefer-str-over-string.md)     |
| 019 | [Use Arc and Mutex for Shared State](rust/019-use-arc-mutex-for-shared-state.md) |
| 020 | [Leverage Zero-Cost Abstractions](rust/020-leverage-zero-cost-abstractions.md)   |
