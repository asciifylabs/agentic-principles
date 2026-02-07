# Proper Error Handling

> Use `trap`, explicit return code checks, and stderr for all error paths to ensure scripts fail gracefully and clean up after themselves.

## Rules

- Use `set -euo pipefail` as the foundation
- Use `trap cleanup EXIT` to guarantee cleanup runs on any exit (success or failure)
- Check return codes explicitly when a command's failure needs special handling
- Send all error messages to stderr (`>&2`), never stdout
- Exit with meaningful non-zero exit codes on failure
- Provide actionable error messages that name what failed and why

## Example

```bash
#!/bin/bash
set -euo pipefail

cleanup() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo "Script failed with exit code $exit_code" >&2
    fi
    rm -f /tmp/tempfile.$$
}

trap cleanup EXIT

if ! command -v required_tool >/dev/null 2>&1; then
    echo "Error: required_tool not found" >&2
    exit 1
fi
```
