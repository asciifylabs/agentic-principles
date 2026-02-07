# Check Command Existence Before Use

> Verify all external command dependencies at script startup using `command -v` and fail immediately if any are missing.

## Rules

- Use `command -v cmd >/dev/null 2>&1` to test for command availability (prefer over `which`)
- Check all dependencies at the top of the script, before any work begins
- Report all missing commands at once, not one at a time
- Include the missing command names in the error message
- Exit non-zero if any required command is missing

## Example

```bash
#!/bin/bash
set -euo pipefail

check_dependencies() {
    local missing_deps=()

    for cmd in jq curl awk; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing_deps+=("$cmd")
        fi
    done

    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo "Error: Missing required commands: ${missing_deps[*]}" >&2
        echo "Please install: ${missing_deps[*]}" >&2
        exit 1
    fi
}

check_dependencies

# Now safe to use jq, curl, awk
```
