# Use Static Analysis and Linting

> Integrate SAST tools and security-focused linters into CI pipelines to catch vulnerabilities, code quality issues, and anti-patterns before code reaches production.

## Rules

- Integrate static application security testing (SAST) tools into the CI/CD pipeline and run them on every pull request
- Use security-focused linters alongside general linters: `eslint-plugin-security` (JS), `bandit` (Python), `gosec` (Go), `cargo-audit` (Rust), `brakeman` (Ruby)
- Use multi-language SAST scanners (Semgrep, SonarQube, CodeQL) for broad coverage and custom rules
- Treat high and critical SAST findings as build blockers — do not allow merging until resolved
- Configure tools with rules appropriate to your stack — disable irrelevant rules to reduce false positives
- Run secret detection tools (`gitleaks`, `detect-secrets`, `trufflehog`) in CI to catch committed secrets
- Use type checking (`mypy`, `TypeScript`, `go vet`) to catch type-related bugs before runtime
- Review and triage findings regularly — do not let a backlog of ignored warnings accumulate
- Document any suppressed warnings with a justification comment explaining why the finding is a false positive
- Keep SAST tools and rulesets up to date to catch newly discovered vulnerability patterns
- Combine static analysis with code review — tools catch patterns, humans catch logic flaws

## Example

```yaml
# Good: CI pipeline with security scanning
name: Security Analysis
on: [pull_request]

jobs:
  semgrep:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: returntocorp/semgrep-action@v1
        with:
          config: >-
            p/security-audit
            p/owasp-top-ten
            p/secrets

  codeql:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: github/codeql-action/init@v3
        with:
          languages: javascript, python
      - uses: github/codeql-action/analyze@v3

  secrets:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: gitleaks/gitleaks-action@v2
```

```python
# When suppressing a finding, always document why
password_hash = get_hash(input)  # nosec B105 - not a hardcoded password, variable name is misleading
```
