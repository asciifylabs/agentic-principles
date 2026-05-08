#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="${SCRIPT_DIR}/skills"
SKIP_DIRS="skills docs .claude .agents .git"

mkdir -p "${SKILLS_DIR}"

SKILL_NAMES=(
  ai
  ansible
  docker
  git
  go
  kubernetes
  nodejs
  python
  rust
  security
  shell
  terraform
)

get_trigger() {
  case "$1" in
    security)   echo "Security standards for any code change in any language. Use for implementation, review, dependency changes, authentication, authorization, data handling, or release risk." ;;
    shell)      echo "Shell scripting standards for .sh, .bash, Makefile, Dockerfile shell snippets, and automation scripts. Use for writing, reviewing, or modifying shell code." ;;
    go)         echo "Go engineering standards for .go, go.mod, and go.sum files. Use for Go implementation, tests, concurrency, dependencies, linting, or code review." ;;
    python)     echo "Python engineering standards for .py, pyproject.toml, requirements, setup files, tests, packaging, linting, or review." ;;
    nodejs)     echo "JavaScript and TypeScript standards for .js, .jsx, .ts, .tsx, package.json, tsconfig, tests, package management, linting, or review." ;;
    rust)       echo "Rust engineering standards for .rs, Cargo.toml, Cargo.lock, tests, crates, error handling, async code, linting, or review." ;;
    terraform)  echo "Terraform and OpenTofu standards for .tf, .tfvars, .tofu, modules, providers, state, plans, policy checks, and IaC review." ;;
    ansible)    echo "Ansible standards for playbooks, roles, inventories, ansible.cfg, Jinja templates, idempotency, Molecule tests, or automation review." ;;
    kubernetes) echo "Kubernetes and Helm standards for manifests, charts, values files, RBAC, workloads, networking, policy, validation, or deployment review." ;;
    ai)         echo "AI application standards for LLM, RAG, agent, embedding, tool-calling, evaluation, guardrail, OpenAI, Anthropic, LangChain, PyTorch, or TensorFlow work." ;;
    git)        echo "Git workflow standards for commits, commit messages, staging, branches, history, secret prevention, pull requests, or repository hygiene." ;;
    docker)     echo "Container standards for Dockerfiles, Compose files, .dockerignore, image builds, BuildKit, runtime hardening, scanning, or container review." ;;
    *)          echo "Engineering standards for $1 code. Use for writing, reviewing, or modifying related files." ;;
  esac
}

get_paths() {
  case "$1" in
    security)   echo '["**/*"]' ;;
    shell)      echo '["**/*.sh", "**/*.bash", "**/*.zsh", "**/Makefile", "**/Makefile.*", "**/*.mk"]' ;;
    go)         echo '["**/*.go", "**/go.mod", "**/go.sum", "**/go.work"]' ;;
    python)     echo '["**/*.py", "**/pyproject.toml", "**/requirements*.txt", "**/setup.py", "**/setup.cfg", "**/uv.lock", "**/poetry.lock"]' ;;
    nodejs)     echo '["**/*.js", "**/*.mjs", "**/*.cjs", "**/*.ts", "**/*.tsx", "**/*.jsx", "**/package.json", "**/tsconfig.json", "**/pnpm-lock.yaml", "**/package-lock.json", "**/yarn.lock", "**/bun.lockb"]' ;;
    rust)       echo '["**/*.rs", "**/Cargo.toml", "**/Cargo.lock"]' ;;
    terraform)  echo '["**/*.tf", "**/*.tfvars", "**/*.tofu", "**/*.tf.json", "**/*.tofu.json"]' ;;
    ansible)    echo '["**/playbooks/**/*.yml", "**/playbooks/**/*.yaml", "**/roles/**/*.yml", "**/roles/**/*.yaml", "**/roles/**/*.j2", "**/inventories/**/*.yml", "**/inventories/**/*.yaml", "**/ansible.cfg", "**/molecule.yml"]' ;;
    kubernetes) echo '["**/k8s/**/*.yml", "**/k8s/**/*.yaml", "**/kubernetes/**/*.yml", "**/kubernetes/**/*.yaml", "**/helm/**/*.yml", "**/helm/**/*.yaml", "**/Chart.yaml", "**/values*.yaml", "**/values*.yml"]' ;;
    ai)         echo '["**/*.py", "**/*.ts", "**/*.tsx", "**/*.js", "**/*.jsx", "**/*.ipynb", "**/prompts/**/*.md", "**/evals/**/*.json", "**/evals/**/*.yaml"]' ;;
    docker)     echo '["**/Dockerfile", "**/Dockerfile.*", "**/Containerfile", "**/compose.yaml", "**/compose.yml", "**/docker-compose*.yml", "**/docker-compose*.yaml", "**/.dockerignore"]' ;;
    git)        echo "" ;;
    *)          echo "" ;;
  esac
}

get_display_name() {
  case "$1" in
    ai)         echo "AI" ;;
    nodejs)     echo "Node.js" ;;
    go)         echo "Go" ;;
    kubernetes) echo "Kubernetes" ;;
    *)
      first="$(echo "$1" | cut -c1 | tr '[:lower:]' '[:upper:]')"
      rest="$(echo "$1" | cut -c2-)"
      echo "${first}${rest}"
      ;;
  esac
}

get_short_description() {
  case "$1" in
    ai)         echo "AI safety, evals, RAG, and agents" ;;
    ansible)    echo "Ansible playbook and role standards" ;;
    docker)     echo "Docker build and runtime standards" ;;
    git)        echo "Git commit and repository hygiene" ;;
    go)         echo "Go code, tests, and module standards" ;;
    kubernetes) echo "Kubernetes and Helm deployment standards" ;;
    nodejs)     echo "JavaScript and TypeScript standards" ;;
    python)     echo "Python code, packaging, and test standards" ;;
    rust)       echo "Rust code, crate, and safety standards" ;;
    security)   echo "Secure coding and supply-chain checks" ;;
    shell)      echo "Shell script safety and linting" ;;
    terraform)  echo "Terraform and OpenTofu IaC standards" ;;
    *)          echo "$1 standards" ;;
  esac
}

generate_core_checklist() {
  case "$1" in
    ai)
      cat <<'EOF'
- Treat prompts, retrieved documents, tool outputs, and user uploads as untrusted data.
- Separate instructions from data with explicit boundaries and verify outputs before acting on them.
- Use structured outputs or schemas for data that drives code, tools, money movement, or permissions.
- Put hard limits around agent loops: tool allowlists, timeouts, step budgets, rate limits, and human approval for destructive actions.
- Evaluate with task-specific datasets, adversarial cases, regression tests, and production telemetry before changing prompts or models.
- Route models by measured quality, latency, and cost; keep model identifiers configurable.
- Design RAG around retrieval quality: chunk deliberately, cite sources where needed, detect stale or missing context, and handle no-answer cases.
- Log requests, model choices, tool calls, retrieval metadata, safety decisions, and failures without storing secrets or unnecessary personal data.
- Apply OWASP GenAI guidance for prompt injection, sensitive data exposure, supply-chain risk, and agentic autonomy.
EOF
      ;;
    ansible)
      cat <<'EOF'
- Prefer roles, collections, inventories, and variables over monolithic playbooks.
- Make every task idempotent; use `changed_when` and `failed_when` intentionally.
- Use modules before `shell` or `command`; if shell is required, quote variables and define creates/removes guards.
- Keep secrets in Ansible Vault or an external secret manager, never in playbooks or inventories.
- Pin collection versions and document supported Ansible versions.
- Use handlers for service restarts and tags for targeted execution.
- Keep templates deterministic, explicit, and validated before deployment.
- Test roles with Molecule or an equivalent CI path for important infrastructure.
EOF
      ;;
    docker)
      cat <<'EOF'
- Use multi-stage builds and minimal runtime images; avoid full OS images unless the workload requires them.
- Pin base image tags and prefer digests for production rebuild reproducibility.
- Run as a non-root user, drop capabilities, and make filesystems read-only when practical.
- Keep secrets out of layers; use BuildKit secret mounts or runtime secret providers.
- Copy only required files, maintain `.dockerignore`, and keep dependency installation cacheable.
- Use exec-form entrypoints, health checks, and explicit signal handling.
- Generate or preserve SBOM/provenance where the build system supports it.
- Scan Dockerfiles, image configs, base images, and final images before publishing.
EOF
      ;;
    git)
      cat <<'EOF'
- Keep commits atomic: one coherent change, with tests or docs in the same commit when they belong together.
- Use conventional commit messages when the project does not define a stronger local convention.
- Review `git status` and the staged diff before committing.
- Stage specific files instead of broad `git add .` or `git add -A` when unrelated edits exist.
- Never commit secrets, generated credentials, `.env` files, private keys, or unrelated local config.
- Do not add AI attribution trailers unless the repository explicitly requires them.
- Preserve user changes you did not make; do not rewrite history or force-push unless explicitly requested.
- Prefer short-lived branches and clear PR descriptions that explain risk, tests, and rollout notes.
EOF
      ;;
    go)
      cat <<'EOF'
- Use Go modules and keep `go.mod`, `go.sum`, and `go.work` intentional and tidy.
- Prefer simple, idiomatic code: small interfaces, explicit errors, clear package boundaries, and no unnecessary abstractions.
- Thread `context.Context` through I/O, RPC, database, and goroutine lifecycles.
- Avoid goroutine leaks; every goroutine should have a cancellation or completion path.
- Wrap errors with context and handle them explicitly; reserve panics for truly unrecoverable states.
- Use table-driven tests, race tests for concurrent code, and benchmarks only for meaningful performance questions.
- Keep public APIs documented and backward-compatible unless a breaking change is intentional.
- Run vulnerability checks for dependencies and avoid package-level mutable state in production code.
EOF
      ;;
    kubernetes)
      cat <<'EOF'
- Set requests, limits, probes, disruption budgets, and rollout strategy deliberately for production workloads.
- Use namespace boundaries, least-privilege RBAC, and network policies for isolation.
- Follow Kubernetes Pod Security Standards; default application workloads toward the Restricted profile.
- Run containers as non-root, drop unnecessary capabilities, and avoid host namespaces and privileged containers.
- Store configuration in ConfigMaps and secrets appropriately; do not commit plaintext secrets.
- Validate Helm templates, CRDs, and manifests against schemas and policy before applying.
- Use labels and annotations consistently for ownership, observability, selection, and lifecycle automation.
- Design upgrades and rollbacks before changing stateful workloads, ingress, storage, or networking.
EOF
      ;;
    nodejs)
      cat <<'EOF'
- Prefer TypeScript with strict settings for maintained application code.
- Use one package manager per project and commit the matching lock file.
- Use ESM or CommonJS consistently; do not mix module systems without a clear boundary.
- Validate external input at trust boundaries with schemas and typed domain objects.
- Handle promises explicitly; avoid floating promises and callback-style control flow in new code.
- Keep configuration in environment variables or secret managers, not source code.
- Use structured logging, graceful shutdown, dependency scanning, and reproducible CI installs.
- Prefer project scripts for lint, test, build, and type-check commands.
EOF
      ;;
    python)
      cat <<'EOF'
- Use `pyproject.toml` for modern packaging, tool configuration, and Python version constraints.
- Prefer type hints for public and non-trivial internal functions; check them with pyright or mypy when configured.
- Use Ruff for linting and formatting unless the project has a different standard.
- Manage dependencies with a lock-capable workflow such as uv, Poetry, PDM, pip-tools, or an existing project convention.
- Use context managers for resources, pathlib for filesystem paths, and dataclasses or typed models for structured data.
- Avoid mutable defaults, broad exception swallowing, global runtime state, and unstructured logging.
- Write focused pytest tests for changed behavior, including edge cases and failure paths.
- Keep secrets out of source and client bundles; load them from environment or a secret manager.
EOF
      ;;
    rust)
      cat <<'EOF'
- Model ownership and lifetimes directly instead of cloning or allocating around unclear design.
- Return `Result` and `Option` deliberately; do not use `unwrap`, `expect`, or `panic!` in production paths without justification.
- Define clear error types with context at API boundaries.
- Prefer iterators, pattern matching, traits, and newtypes when they improve clarity or safety.
- Keep unsafe code isolated, justified, documented, and covered by tests.
- Use async only where concurrency or I/O benefits justify it; avoid holding locks across `.await`.
- Keep crate features explicit and dependencies minimal.
- Run format, lint, tests, and dependency policy checks before release-sensitive changes.
EOF
      ;;
    security)
      cat <<'EOF'
- Validate and encode data at every trust boundary; use parameterized queries and safe serializers.
- Enforce authentication, authorization, tenancy, and least privilege server-side.
- Keep secrets out of source, logs, images, Terraform state exposure, and client bundles.
- Avoid command injection, path traversal, unsafe deserialization, SSRF, XSS, CSRF, and insecure direct object references.
- Use secure defaults: TLS, encryption at rest, short-lived credentials, scoped tokens, and safe error messages.
- Maintain dependency, container, and IaC scanning in CI; produce SBOMs where the build system supports them.
- Prefer signed or provenance-backed artifacts for release workflows and align supply-chain controls with SLSA/SSDF concepts.
- Add abuse-case tests for security-sensitive changes and review logs for sensitive data leakage.
EOF
      ;;
    shell)
      cat <<'EOF'
- Start scripts with `set -euo pipefail` when compatible with the script's control flow.
- Quote variable expansions and use arrays for argument lists.
- Prefer functions with local variables for reusable logic.
- Use `mktemp`, traps, and cleanup handlers for temporary files.
- Avoid `eval`, string-built commands, unvalidated `curl | sh`, and untrusted input in shell contexts.
- Check required commands before use and fail with actionable messages.
- Use structured logging for automation and keep secrets out of command traces.
- Run ShellCheck and shfmt on changed scripts.
EOF
      ;;
    terraform)
      cat <<'EOF'
- Use modules to create reusable boundaries, but keep module interfaces small and explicit.
- Store state remotely with encryption and locking; restrict state access because state can contain secrets.
- Pin Terraform/OpenTofu and provider versions; commit lock files where applicable.
- Keep variables typed, outputs intentional, and sensitive values marked `sensitive = true`.
- Prefer data sources and locals over hardcoded environment-specific values.
- Review plans in CI and separate plan from apply with approval for production.
- Apply least-privilege IAM and policy-as-code checks for sensitive infrastructure.
- Support OpenTofu deliberately when the project has chosen it; do not mix CLIs accidentally.
EOF
      ;;
  esac
}

generate_validation_section() {
  case "$1" in
    ai)
      cat <<'EOF'
- Run the project's existing evals, prompt regression tests, and safety tests.
- Add or update eval cases for changed model behavior, retrieval behavior, tool calls, or guardrails.
- Inspect logs for token blowups, tool-loop failures, leaked secrets, and unsafe autonomous actions.
EOF
      ;;
    ansible)
      cat <<'EOF'
- `ansible-lint`
- `ansible-playbook --syntax-check <playbook>`
- `molecule test` for roles or risky changes when configured
EOF
      ;;
    docker)
      cat <<'EOF'
- `hadolint Dockerfile` or equivalent Dockerfile linting
- `docker build` or the project's container build command
- `trivy config .` and `trivy image <image>` or equivalent image scanning
EOF
      ;;
    git)
      cat <<'EOF'
- `git status --short`
- `git diff --staged` before committing
- Secret scan changed files when credentials, config, or generated artifacts are involved
EOF
      ;;
    go)
      cat <<'EOF'
- `gofmt -w` on changed Go files
- `go test ./...`
- `go vet ./...`
- `golangci-lint run ./...` and `govulncheck ./...` when configured or security-sensitive
EOF
      ;;
    kubernetes)
      cat <<'EOF'
- `helm lint` for charts
- `helm template ... | kubeconform -strict` or schema validation for rendered manifests
- Policy checks with Kyverno, Gatekeeper/OPA, Conftest, or the project's admission policy tooling
EOF
      ;;
    nodejs)
      cat <<'EOF'
- Use project scripts first: lint, typecheck, test, build.
- Use reproducible installs: `npm ci`, `pnpm install --frozen-lockfile`, `yarn install --immutable`, or the configured equivalent.
- Run dependency audit/scanning for dependency or release-sensitive changes.
EOF
      ;;
    python)
      cat <<'EOF'
- `ruff check --fix .`
- `ruff format .`
- `pytest` for changed behavior
- `pyright` or `mypy` when configured for the project
EOF
      ;;
    rust)
      cat <<'EOF'
- `cargo fmt`
- `cargo clippy --all-targets --all-features -- -D warnings`
- `cargo test`
- `cargo audit` or `cargo deny check` for release-sensitive dependency changes
EOF
      ;;
    security)
      cat <<'EOF'
- `gitleaks detect --source .` for secret scanning
- `semgrep --config auto` for common vulnerability patterns
- `trivy fs .` or ecosystem-specific dependency scanning
- Add targeted security tests for authorization, input validation, and data exposure risks
EOF
      ;;
    shell)
      cat <<'EOF'
- `shellcheck <changed scripts>`
- `shfmt -w <changed scripts>`
- Run the script in a safe test mode or fixture when possible
EOF
      ;;
    terraform)
      cat <<'EOF'
- `terraform fmt -recursive` or `tofu fmt -recursive`
- `terraform validate` or `tofu validate`
- `tflint --recursive` when configured
- `trivy config .`, Checkov, Conftest, or the project's policy scanner for risky infrastructure
EOF
      ;;
  esac
}

generate_linting_reference() {
  local category="$1"
  cat <<EOF

---

# Validation and Tooling

Prefer the repository's existing scripts and CI commands. When no local convention exists, use these defaults and report tools that are unavailable rather than inventing new project dependencies.

EOF
  generate_validation_section "${category}"
}

generate_skill_body() {
  local category="$1"
  local display_name="$2"

  cat <<EOF
# ${display_name} Principles

Use this skill as standing guidance for this domain. Apply the checklist first; read the detailed reference only when the task is substantial, risky, unfamiliar, or review-oriented.

## Operating Rules

- Prefer the repository's existing conventions, toolchain, and CI commands over generic defaults.
- Make the smallest coherent change that satisfies the request while preserving behavior.
- Treat tests, linting, dependency hygiene, and security review as part of completion.
- If a principle conflicts with higher-priority repository instructions or an explicit user request, follow the higher-priority instruction and call out the tradeoff.

## Core Checklist

EOF
  generate_core_checklist "${category}"

  cat <<EOF

## Validation

Run applicable checks when they exist in the project; if a tool is missing, report that it was skipped.

EOF
  generate_validation_section "${category}"

  cat <<EOF

## Detailed Reference

For the complete principle set with examples and edge cases, read [references/principles.md](references/principles.md) when deeper guidance is useful.
EOF
}

generate_openai_yaml() {
  local skill_name="$1"
  local display_name="$2"
  local short_description="$3"
  local dest="$4"

  mkdir -p "$(dirname "${dest}")"
  cat > "${dest}" <<EOF
interface:
  display_name: "${display_name} Principles"
  short_description: "${short_description}"
  default_prompt: "Use \$${skill_name} to apply the relevant engineering standards to this task."
policy:
  allow_implicit_invocation: true
EOF
}

generate_reference() {
  local category="$1"
  local display_name="$2"
  local dest="$3"
  shift 3

  {
    echo "# ${display_name} Principles Reference"
    echo ""
    echo "This reference contains the full generated rule set. Load it only when the active checklist in SKILL.md is not enough for the task."
    echo ""

    first=true
    for md_file in "$@"; do
      if [[ "${first}" == true ]]; then
        first=false
      else
        echo ""
        echo "---"
        echo ""
      fi
      cat "${md_file}"
    done

    generate_linting_reference "${category}"
  } > "${dest}"
}

for category in "${SKILL_NAMES[@]}"; do
  category_dir="${SCRIPT_DIR}/${category}"

  if [[ ! -d "${category_dir}" ]]; then
    continue
  fi

  shopt -s nullglob
  md_files=("${category_dir}"/*.md)
  shopt -u nullglob

  if [[ ${#md_files[@]} -eq 0 ]]; then
    continue
  fi

  skill_name="${category}-principles"
  skill_subdir="${SKILLS_DIR}/${skill_name}"
  references_dir="${skill_subdir}/references"
  agents_dir="${skill_subdir}/agents"
  output_file="${skill_subdir}/SKILL.md"
  reference_file="${references_dir}/principles.md"
  openai_yaml="${agents_dir}/openai.yaml"
  trigger="$(get_trigger "${category}")"
  display_name="$(get_display_name "${category}")"
  paths="$(get_paths "${category}")"
  short_description="$(get_short_description "${category}")"

  mkdir -p "${references_dir}" "${agents_dir}"

  {
    echo "---"
    echo "name: ${skill_name}"
    echo "description: \"${trigger}\""
    echo "license: MIT"
    if [[ -n "${paths}" ]]; then
      echo "paths: ${paths}"
      echo "globs: ${paths}"
    fi
    echo "metadata:"
    echo "  asciify-source: asciify-skills"
    echo "  asciify-category: ${category}"
    echo "---"
    echo ""
    generate_skill_body "${category}" "${display_name}"
  } > "${output_file}"

  generate_reference "${category}" "${display_name}" "${reference_file}" "${md_files[@]}"
  generate_openai_yaml "${skill_name}" "${display_name}" "${short_description}" "${openai_yaml}"

  echo "Generated: ${output_file}"
  echo "Generated: ${reference_file}"
  echo "Generated: ${openai_yaml}"
done

{
  sha="$(git rev-parse HEAD 2>/dev/null || echo "dev")"
  echo "SHA=${sha}"
  echo "BUILT=$(date +%Y-%m-%d)"
} > "${SKILLS_DIR}/.version"

echo "Generated: ${SKILLS_DIR}/.version"
echo "Done. Skills generated in ${SKILLS_DIR}/"
