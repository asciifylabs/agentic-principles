# Use Blocks for Error Handling

> Group related tasks in blocks with `rescue` and `always` sections for structured error handling and guaranteed cleanup.

## Rules

- Group related tasks in blocks
- Use `rescue` section for error handling and rollback
- Use `always` section for cleanup tasks that must run regardless of success or failure
- Combine with `ignore_errors` sparingly
- Do not hide real errors behind overly broad rescue blocks

## Example

```yaml
- name: Deploy application
  block:
    - name: Stop application
      systemd:
        name: app
        state: stopped

    - name: Copy new version
      copy:
        src: app.jar
        dest: /opt/app/app.jar

    - name: Start application
      systemd:
        name: app
        state: started

  rescue:
    - name: Restore previous version
      command: cp /opt/app/app.jar.backup /opt/app/app.jar

    - name: Start application
      systemd:
        name: app
        state: started

    - name: Notify failure
      debug:
        msg: "Deployment failed, restored previous version"

  always:
    - name: Cleanup temporary files
      file:
        path: /tmp/deploy
        state: absent
```
