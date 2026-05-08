# Lock Dependencies with Lock Files

> Always commit the package manager lock file to ensure reproducible installs across environments.

## Rules

- Commit exactly one lock file: `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, or `bun.lockb`
- Declare the intended package manager in `packageManager` and use Corepack when applicable
- Use reproducible installs in CI: `npm ci`, `pnpm install --frozen-lockfile`, `yarn install --immutable`, or `bun install --frozen-lockfile`
- Never manually edit lock files
- Update dependencies deliberately through reviewed PRs from Renovate, Dependabot, or the chosen package manager
- Use package manager audits plus SCA tools when dependency risk matters
- Document workspace layout and package manager behavior in README.md or repo docs
- Include `.npmrc`, `.yarnrc.yml`, or equivalent config when the install behavior depends on it

## Example

```json
// package.json - use semantic versioning appropriately
{
  "dependencies": {
    "express": "^4.18.2",        // Minor and patch updates allowed
    "lodash": "~4.17.21",         // Only patch updates allowed
    "critical-lib": "1.2.3"       // Exact version for critical dependencies
  },
  "devDependencies": {
    "vitest": "^3.0.0",
    "typescript": "^5.0.0",
    "eslint": "^9.0.0"
  },
  "packageManager": "pnpm@10.0.0"
}

// CI/CD script
{
  "scripts": {
    "ci:install": "pnpm install --frozen-lockfile",
    "audit": "pnpm audit --audit-level=moderate"
  }
}
```

```bash
# .gitignore - never ignore lock files
node_modules/
# package-lock.json  <- NEVER ignore this!
```
