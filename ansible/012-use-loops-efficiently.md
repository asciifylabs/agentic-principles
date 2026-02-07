# Use Loops Efficiently

> Use `loop` for iteration over lists and `until` for retries -- prefer `loop` over the deprecated `with_items`.

## Rules

- Use `loop` for simple iteration (preferred over `with_items`)
- Use `loop_control` for better variable names and labels
- Use `until` for retry loops
- Combine with `when` for conditional loops
- Use `include_tasks` with loops for complex scenarios
- Avoid nested loops when possible

## Example

```yaml
- name: Install multiple packages
  package:
    name: "{{ item }}"
    state: present
  loop:
    - nginx
    - python3
    - curl
  loop_control:
    label: "{{ item }}"

- name: Create users
  user:
    name: "{{ item.name }}"
    uid: "{{ item.uid }}"
    groups: "{{ item.groups }}"
  loop:
    - name: alice
      uid: 1001
      groups: sudo,www-data
    - name: bob
      uid: 1002
      groups: www-data

- name: Wait for service
  uri:
    url: "http://localhost:{{ item }}/health"
    status_code: 200
  loop: [8080, 8081, 8082]
  until: result.status == 200
  retries: 10
  delay: 5
```
