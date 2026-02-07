# Structured Logging

> Log with consistent levels (INFO/WARN/ERROR/DEBUG), timestamps, and script context to stderr.

## Rules

- Use log level functions (`log_info`, `log_error`, `log_warn`, `log_debug`) instead of raw `echo`
- Include ISO-8601 timestamps and the script name in every log line
- Send all log output to stderr (`>&2`) so stdout stays clean for data
- Gate DEBUG logs behind a `DEBUG` environment variable
- Use a single shared `log` function to enforce format consistency

## Example

```bash
#!/bin/bash
set -euo pipefail

SCRIPT_NAME=$(basename "$0")

log() {
    local level="$1"
    shift
    echo "[$level] [$(date '+%Y-%m-%d %H:%M:%S')] [$SCRIPT_NAME] $*" >&2
}

log_info()  { log "INFO" "$@"; }
log_error() { log "ERROR" "$@"; }
log_warn()  { log "WARN" "$@"; }
log_debug() { [ "${DEBUG:-0}" = "1" ] && log "DEBUG" "$@"; }

log_info "Starting backup process"
log_error "Failed to connect to server"
```
