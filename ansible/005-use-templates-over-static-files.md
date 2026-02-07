# Use Templates Over Static Files

> Use Jinja2 templates for configuration files instead of copying static files.

## Rules

- Use `template` module instead of `copy` for config files
- Leverage Jinja2 templating for dynamic content
- Store templates in `templates/` directory
- Use conditionals, loops, and filters in templates
- Keep templates readable and well-documented

## Example

```yaml
# tasks/main.yml
- name: Configure application
  template:
    src: app.conf.j2
    dest: /etc/app/app.conf
    owner: root
    group: root
    mode: '0644'

# templates/app.conf.j2
server {
    listen {{ app_port }};
    server_name {{ app_domain }};

    {% if ssl_enabled %}
    ssl_certificate {{ ssl_cert_path }};
    ssl_certificate_key {{ ssl_key_path }};
    {% endif %}

    {% for location in app_locations %}
    location {{ location.path }} {
        proxy_pass {{ location.backend }};
    }
    {% endfor %}
}
```
