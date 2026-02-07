# Use Variables and Defaults Effectively

> Parameterize all configurable values with variables and provide sensible defaults.

## Rules

- Define defaults in `defaults/main.yml` in roles
- Use `group_vars` and `host_vars` for environment-specific values
- Provide sensible defaults for every variable
- Document all variables
- Use variable precedence correctly
- Validate variables when appropriate

## Example

```yaml
# roles/nginx/defaults/main.yml
nginx_port: 80
nginx_worker_processes: auto
nginx_user: www-data

# group_vars/production.yml
nginx_port: 443
nginx_ssl_enabled: true

# tasks/main.yml
- name: Configure nginx
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  vars:
    port: "{{ nginx_port }}"
```
