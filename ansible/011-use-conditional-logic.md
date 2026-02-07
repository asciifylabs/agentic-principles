# Use Conditional Logic Appropriately

> Use `when` clauses to make tasks adapt to different OS families, environments, and host states.

## Rules

- Use `when` clause for task-level conditionals
- Combine conditions with `and`, `or`, `not`
- Use facts and variables in conditions
- Keep conditions readable
- Use `failed_when` and `changed_when` for complex scenarios
- Avoid deeply nested conditionals

## Example

```yaml
- name: Install package (Debian)
  apt:
    name: nginx
    state: present
  when: ansible_os_family == "Debian"

- name: Install package (RedHat)
  yum:
    name: nginx
    state: present
  when: ansible_os_family == "RedHat"

- name: Configure SSL
  template:
    src: ssl.conf.j2
    dest: /etc/nginx/ssl.conf
  when:
    - ssl_enabled | default(false)
    - ssl_cert_path is defined
    - ssl_key_path is defined

- name: Restart service
  systemd:
    name: nginx
    state: restarted
  when: nginx_config_changed | default(false)
```
