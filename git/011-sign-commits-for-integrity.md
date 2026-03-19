# Sign Commits for Integrity

> Use GPG or SSH signing to verify commit authorship and prevent impersonation.

## Rules

- Sign all commits with GPG or SSH keys
- Configure `commit.gpgsign = true` in git config for automatic signing
- Upload your public key to GitHub/GitLab for verified badges
- Use SSH signing (`gpg.format = ssh`) for simpler key management
- Require signed commits on protected branches via branch protection rules
- Never share or commit private signing keys

## Example

```bash
# Configure SSH signing (recommended)
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true

# Configure GPG signing
git config --global user.signingkey YOUR_GPG_KEY_ID
git config --global commit.gpgsign true

# Verify a signed commit
git log --show-signature -1

# Sign a tag
git tag -s v1.0.0 -m "Release v1.0.0"
```
