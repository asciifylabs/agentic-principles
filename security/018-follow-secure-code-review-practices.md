# Follow Secure Code Review Practices

> Review all code changes against a security checklist — flag authentication gaps, input validation issues, hardcoded secrets, and insecure patterns before merging.

## Rules

- Use a security review checklist for every pull request covering: authentication, authorization, input validation, output encoding, secrets, error handling, logging, and dependency changes
- Require at least one reviewer with security awareness for changes touching authentication, authorization, cryptography, or data handling
- Flag any hardcoded credentials, API keys, tokens, or secrets — treat as a blocking finding
- Verify that all user inputs are validated and sanitized before use in queries, commands, templates, or output
- Check that error handling does not leak sensitive information in responses
- Review dependency additions and updates: check for known vulnerabilities, assess the package's maintenance status and trust level
- Verify that new API endpoints have proper authentication and authorization checks
- Look for common anti-patterns: `eval()`, `exec()`, raw SQL concatenation, disabled security features, wildcard CORS
- Check that security-sensitive logic has corresponding test coverage
- Review infrastructure and configuration changes (Dockerfiles, CI/CD, Terraform) for security implications
- Document security decisions and trade-offs in review comments for future reference
- Never approve code that introduces a known vulnerability, even under deadline pressure

## Security Review Checklist

```markdown
## Security Review

- [ ] No hardcoded secrets, API keys, or credentials
- [ ] All inputs validated and sanitized at system boundaries
- [ ] Parameterized queries used (no SQL string concatenation)
- [ ] Output properly encoded for context (HTML, JS, URL)
- [ ] Authentication required on all protected endpoints
- [ ] Authorization checks verify resource ownership and role
- [ ] Error responses do not leak internal details
- [ ] Security events are logged (auth, access denied, etc.)
- [ ] New dependencies audited for vulnerabilities
- [ ] Security-sensitive changes have test coverage
```

## Example

```markdown
# Pull Request Review Comment Examples

## Blocking: Hardcoded secret
> Line 42: `const API_KEY = "sk-live-..."` — this must be moved to an
> environment variable. Secrets must never be committed to source code.

## Blocking: Missing authorization
> `DELETE /api/users/:id` has authentication but no authorization check.
> Any authenticated user can delete any other user. Add an ownership or
> role check before proceeding with deletion.

## Non-blocking: Improvement suggestion
> Consider adding rate limiting to this registration endpoint to prevent
> automated abuse. Not blocking, but should be addressed before GA.
```
