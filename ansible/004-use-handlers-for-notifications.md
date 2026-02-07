# Use Handlers for Service Notifications

> Trigger service restarts and reloads through handlers so they only run when configuration actually changes.

## Rules

- Define handlers in `handlers/main.yml`
- Notify handlers only when changes occur
- Handlers run once at the end of the play, even if notified multiple times
- Use `restarted` for full restarts, `reloaded` for graceful reloads
- Handlers are idempotent by default

## Example

```yaml
# tasks/main.yml
- name: Configure nginx
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: restart nginx

- name: Update SSL certificate
  copy:
    src: cert.pem
    dest: /etc/nginx/ssl/cert.pem
  notify: reload nginx

# handlers/main.yml
- name: restart nginx
  systemd:
    name: nginx
    state: restarted

- name: reload nginx
  systemd:
    name: nginx
    state: reloaded
```
