# Use Temporary Files Safely

> Create temp files with `mktemp` and always clean them up via a `trap` on EXIT.

## Rules

- Always use `mktemp` to create temporary files (never hand-craft temp file names)
- Use `mktemp -d` when you need a temporary directory
- Register a `trap cleanup EXIT` to remove temp files on any exit
- Set restrictive permissions on temp files containing sensitive data
- Never assume `/tmp/somefile` is safe to use directly -- another process may control it

## Example

```bash
#!/bin/bash
set -euo pipefail

TEMP_FILE=$(mktemp /tmp/script.XXXXXX)

cleanup() {
    rm -f "$TEMP_FILE"
}

trap cleanup EXIT

echo "Processing data" > "$TEMP_FILE"
# ... operations on TEMP_FILE

# Cleanup happens automatically on exit
```
