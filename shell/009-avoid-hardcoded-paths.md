# Avoid Hardcoded Paths

> Use environment variables with defaults and dynamic path detection instead of hardcoded absolute paths.

## Rules

- Define configurable paths via environment variables with sensible defaults: `"${VAR:-default}"`
- Detect the script's own directory dynamically using `BASH_SOURCE`
- Use standard variables (`$HOME`, `$USER`, `$TMPDIR`) instead of hardcoding equivalents
- Never embed machine-specific paths (e.g., `/home/alice/`) in scripts
- Provide overrides for every path so scripts work across dev, CI, and production environments

## Example

```bash
#!/bin/bash
set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Use environment variables with defaults
BACKUP_DIR="${BACKUP_DIR:-$HOME/backups}"
LOG_DIR="${LOG_DIR:-/var/log}"
CONFIG_FILE="${CONFIG_FILE:-$SCRIPT_DIR/config.conf}"

echo "Script location: $SCRIPT_DIR"
echo "Backup directory: $BACKUP_DIR"
```
