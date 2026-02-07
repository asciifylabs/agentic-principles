# Use Roles Over Monolithic Playbooks

> Organize Ansible code into single-purpose, reusable roles instead of large monolithic playbooks.

## Rules

- Organize related tasks, handlers, variables, and templates into roles
- Keep playbooks thin -- they should primarily call roles
- Roles must be single-purpose and reusable
- Use role dependencies for composition
- Store roles in separate directories or collections

## Example

```yaml
# playbook.yml (thin playbook)
- name: Configure web server
  hosts: webservers
  roles:
    - common
    - nginx
    - ssl

# roles/nginx/tasks/main.yml
- name: Install nginx
  package:
    name: nginx
    state: present
```
