# Use Vault for Secrets

> Encrypt all sensitive data with Ansible Vault -- never commit unencrypted secrets.

## Rules

- Encrypt sensitive variables with `ansible-vault encrypt`
- Store encrypted files in version control safely
- Use separate vault files for different environments
- Use `--ask-vault-pass` or vault password files for decryption
- Never commit unencrypted secrets
- Rotate vault passwords regularly

## Example

```bash
# Create encrypted variable file
ansible-vault create group_vars/production/vault.yml

# Edit encrypted file
ansible-vault edit group_vars/production/vault.yml

# Encrypt existing file
ansible-vault encrypt group_vars/production/secrets.yml
```

```yaml
# group_vars/production/vault.yml (encrypted)
db_password: !vault |
  $ANSIBLE_VAULT;1.1;AES256
  663864396539663164356362656636...

api_key: !vault |
  $ANSIBLE_VAULT;1.1;AES256
  3234323432343234323432343234...
```
