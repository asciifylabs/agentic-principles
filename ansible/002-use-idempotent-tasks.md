# Write Idempotent Tasks

> Ensure every task produces the same result regardless of how many times it runs.

## Rules

- Use Ansible modules instead of raw commands when possible
- Use `state` parameters (present/absent) rather than create/delete commands
- Check conditions before making changes
- Use `changed_when` and `failed_when` for complex scenarios
- Avoid `command` and `shell` modules unless necessary

## Example

```yaml
# Good: Idempotent
- name: Ensure user exists
  user:
    name: appuser
    state: present
    shell: /bin/bash

# Bad: Not idempotent
- name: Create user
  command: useradd appuser

# Good: Idempotent with condition
- name: Install package if not present
  package:
    name: "{{ item }}"
    state: present
  loop:
    - nginx
    - python3
```
