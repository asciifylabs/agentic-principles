# Use Tags for Selective Execution

> Tag tasks for logical grouping so playbooks can be run selectively with `--tags` and `--skip-tags`.

## Rules

- Tag related tasks for logical grouping
- Use descriptive tag names
- Tag tasks that are commonly run independently
- Use `--tags` and `--skip-tags` for selective execution
- Consider using `always` and `never` tags for tasks that should always or never run by default

## Example

```yaml
- name: Install packages
  package:
    name: "{{ item }}"
    state: present
  loop:
    - nginx
    - python3
  tags:
    - packages
    - install

- name: Configure application
  template:
    src: app.conf.j2
    dest: /etc/app/app.conf
  tags:
    - config
    - deploy

- name: Restart service
  systemd:
    name: app
    state: restarted
  tags:
    - deploy
    - restart
```
