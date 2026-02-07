# Use Local Variables in Functions

> Declare all function variables with `local` to prevent accidental modification of global state.

## Rules

- Declare every variable inside a function with `local`
- Place `local` declarations at the top of the function body
- Only use global variables for intentionally shared script-wide state
- Never modify global variables from inside a function without explicit intent

## Example

```bash
#!/bin/bash
set -euo pipefail

global_config="/etc/config"

process_file() {
    local filename="$1"
    local temp_dir="/tmp/processing"
    local counter=0

    # These variables won't affect global scope
    mkdir -p "$temp_dir"
    # ... processing logic
}

# global_config remains unchanged by process_file
```
