# Lock Dependencies with Lock Files

> Always commit lock files (package-lock.json or yarn.lock) to ensure reproducible builds across environments.

## Rules

- Commit `package-lock.json` (npm) or `yarn.lock` (yarn) or `pnpm-lock.yaml` (pnpm) to version control
- Use exact versions for production dependencies in package.json when stability is critical
- Use `npm ci` or `yarn install --frozen-lockfile` in CI/CD pipelines
- Never manually edit lock files
- Update dependencies regularly but deliberately using `npm update` or `yarn upgrade`
- Use `npm audit` or `yarn audit` to check for security vulnerabilities
- Document the package manager being used in README.md
- Include `.npmrc` if using specific npm configurations

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
    "jest": "^29.0.0",
    "eslint": "^8.0.0"
  }
}

// CI/CD script
{
  "scripts": {
    "ci:install": "npm ci",       // Use ci for reproducible installs
    "audit": "npm audit --audit-level=moderate"
  }
}
```

```bash
# .gitignore - never ignore lock files
node_modules/
# package-lock.json  <- NEVER ignore this!
```
