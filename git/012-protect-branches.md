# Protect Branches

> Use branch protection rules to enforce quality gates and prevent accidental or unauthorized changes to critical branches.

## Rules

- Enable branch protection on main, develop, and release branches
- Require pull request reviews before merging
- Require status checks (CI/CD) to pass before merging
- Prevent force pushes to protected branches
- Require branches to be up to date before merging
- Enable CODEOWNERS files to enforce review from domain experts
- Restrict who can push directly to protected branches

## Example

```bash
# GitHub CLI: set branch protection
gh api repos/{owner}/{repo}/branches/main/protection -X PUT -f \
  required_status_checks='{"strict":true,"contexts":["ci/build","ci/test"]}' \
  enforce_admins=true \
  required_pull_request_reviews='{"required_approving_review_count":1}'
```

```text
# CODEOWNERS
* @team/backend
/frontend/ @team/frontend
/infra/ @team/platform
*.tf @team/platform
```
