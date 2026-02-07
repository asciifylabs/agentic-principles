# Use `set -euo pipefail`

> Start every shell script with `set -euo pipefail` to fail fast on errors, unset variables, and broken pipes.

## Rules

- Always place `set -euo pipefail` immediately after the shebang line
- `-e`: exits immediately if any command returns non-zero
- `-u`: exits if an unset variable is referenced
- `-o pipefail`: exits if any command in a pipeline fails, not just the last one
- Use `|| true` or `|| :` for commands where failure is intentionally acceptable
- Do not remove these flags to silence errors -- fix the root cause instead

## Example

```bash
#!/bin/bash
set -euo pipefail

# Script will exit if any command fails
# Script will exit if $UNDEFINED_VAR is used
# Script will exit if grep fails in: cat file | grep pattern
```
