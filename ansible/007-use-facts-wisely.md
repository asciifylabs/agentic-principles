# Use Facts Wisely

> Leverage Ansible facts for host-aware conditional logic, but disable gathering when not needed for performance.

## Rules

- Facts are gathered automatically unless `gather_facts: false`
- Use `setup` module to inspect available facts
- Cache facts when possible using fact caching
- Use facts for conditional logic based on host properties
- Create custom facts when needed
- Disable fact gathering when not needed for performance

## Example

```yaml
- name: Configure based on OS
  hosts: all
  gather_facts: true
  tasks:
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

    - name: Configure based on memory
      template:
        src: config.j2
        dest: /etc/app/config
      vars:
        worker_processes: "{{ (ansible_memtotal_mb / 512) | int }}"
```
