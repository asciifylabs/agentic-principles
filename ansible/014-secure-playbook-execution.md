# Secure Playbook Execution

> Harden Ansible execution to prevent privilege escalation, credential exposure, and unauthorized access.

## Rules

- Use `become` with the least privilege needed; avoid blanket `become: true` at playbook level
- Never log sensitive data; use `no_log: true` on tasks that handle secrets
- Encrypt all secrets with Ansible Vault; never store plaintext passwords or keys
- Use SSH key-based authentication; disable password-based SSH access
- Restrict `ansible_user` to service accounts with limited permissions
- Validate downloaded content with checksums before executing
- Use `--check` (dry-run) and `--diff` to audit changes before applying

## Example

```yaml
# Bad: blanket become, logging secrets
- name: Deploy app
  hosts: all
  become: true
  tasks:
    - name: Set database password
      ansible.builtin.shell: "echo {{ db_password }}"

# Good: targeted become, secrets protected
- name: Deploy app
  hosts: all
  tasks:
    - name: Set database password
      ansible.builtin.copy:
        content: "{{ db_password }}"
        dest: /etc/app/db.conf
        mode: "0600"
        owner: app
      become: true
      become_user: app
      no_log: true

    - name: Download binary with checksum verification
      ansible.builtin.get_url:
        url: "https://releases.example.com/app-{{ version }}.tar.gz"
        dest: /tmp/app.tar.gz
        checksum: "sha256:{{ app_sha256 }}"
```
