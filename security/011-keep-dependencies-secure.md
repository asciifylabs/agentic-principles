# Keep Dependencies Secure

> Audit dependencies regularly, pin versions, monitor for CVEs, and remove unused packages to minimize supply chain risk.

## Rules

- Run dependency vulnerability scans regularly: `npm audit`, `pip-audit`, `cargo audit`, `go vuln check`, `bundler-audit`
- Integrate dependency scanning into CI/CD pipelines — fail builds on critical or high severity vulnerabilities
- Pin dependency versions in lock files (`package-lock.json`, `poetry.lock`, `go.sum`, `Cargo.lock`) and commit them
- Review dependency updates before applying — use tools like Dependabot, Renovate, or Snyk for automated PRs
- Remove unused dependencies — every dependency is an attack surface
- Prefer well-maintained dependencies with active communities, frequent releases, and security policies
- Verify package integrity: use checksum verification and package signing where available
- Limit the number of transitive dependencies — prefer packages with fewer sub-dependencies
- Never install packages from untrusted sources or registries
- Establish a process for emergency patching when critical CVEs are disclosed in your dependencies
- Use software composition analysis (SCA) tools to maintain a software bill of materials (SBOM)

## Example

```yaml
# Good: CI pipeline with dependency scanning
# GitHub Actions example
name: Security Scan
on: [push, pull_request]

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm audit --audit-level=high
        # Fails on high or critical vulnerabilities

  snyk:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
```

```bash
# Regular audit commands by ecosystem
npm audit                    # Node.js
pip-audit                    # Python
cargo audit                  # Rust
govulncheck ./...            # Go
bundler-audit check          # Ruby
```
