# Use Functions for Reusability

> Encapsulate reusable logic in functions to reduce duplication and improve readability.

## Rules

- Extract repeated or logically distinct operations into named functions
- Define functions before they are called
- Use `local` for all variables inside functions
- Return success/failure via exit codes (0 for success, non-zero for failure)
- Give functions descriptive verb-noun names (e.g., `check_disk_space`, `log_error`)
- Keep functions focused on a single responsibility

## Example

```bash
#!/bin/bash
set -euo pipefail

log_error() {
    local message="$1"
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $message" >&2
}

check_disk_space() {
    local threshold="${1:-80}"
    local usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

    if [ "$usage" -gt "$threshold" ]; then
        log_error "Disk usage is ${usage}%, exceeding threshold of ${threshold}%"
        return 1
    fi
    return 0
}
```
