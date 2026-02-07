# Use Inventories Effectively

> Organize inventories with logical host grouping and use `group_vars`/`host_vars` for per-group configuration.

## Rules

- Use INI or YAML format for inventories
- Group hosts logically by environment, function, or location
- Use `group_vars` and `host_vars` for configuration
- Use inventory plugins for dynamic inventories
- Keep inventories in version control

## Example

```ini
# inventories/production/hosts.ini
[webservers]
web1.example.com ansible_host=10.0.1.10
web2.example.com ansible_host=10.0.1.11

[dbservers]
db1.example.com ansible_host=10.0.2.10

[webservers:vars]
nginx_version=1.20
ssl_enabled=true

[dbservers:vars]
mysql_version=8.0
```

```yaml
# inventories/production/hosts.yml
all:
  children:
    webservers:
      hosts:
        web1.example.com:
          ansible_host: 10.0.1.10
        web2.example.com:
          ansible_host: 10.0.1.11
      vars:
        nginx_version: 1.20
    dbservers:
      hosts:
        db1.example.com:
          ansible_host: 10.0.2.10
```
