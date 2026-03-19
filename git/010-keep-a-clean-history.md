# Keep a Clean History

> Maintain a readable, linear git history that tells the story of the project's evolution.

## Rules

- Prefer rebase over merge to keep a linear history on feature branches
- Squash fixup commits before merging to main
- Never rewrite history on shared branches (main, develop, release)
- Use `git commit --fixup` and `git rebase --autosquash` for corrections
- Delete merged branches to keep the branch list clean
- Avoid merge commits in feature branches; rebase onto the target branch instead
- Each commit in the final history should compile and pass tests

## Example

```bash
# Fixup a previous commit during development
git commit --fixup=abc1234
git rebase -i --autosquash main

# Rebase feature branch onto latest main before merging
git fetch origin
git rebase origin/main

# Delete merged branch
git branch -d feature/my-feature
git push origin --delete feature/my-feature
```
