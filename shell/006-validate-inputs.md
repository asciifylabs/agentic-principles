# Validate All Inputs

> Check every argument, file, and environment variable before use -- fail early with a clear error message.

## Rules

- Verify the correct number of arguments at script start
- Check file/directory existence (`-f`, `-d`) before operating on them
- Check permissions (`-r`, `-w`, `-x`) before file operations
- Validate data formats (numeric, non-empty) where applicable
- Print a usage message to stderr and exit non-zero on invalid input
- Sanitize inputs to prevent injection attacks

## Example

```bash
#!/bin/bash
set -euo pipefail

usage() {
    echo "Usage: $0 <source_file> <destination_dir>" >&2
    exit 1
}

validate_inputs() {
    if [ $# -ne 2 ]; then
        usage
    fi

    local source="$1"
    local dest="$2"

    if [ ! -f "$source" ]; then
        echo "Error: Source file '$source' does not exist" >&2
        exit 1
    fi

    if [ ! -d "$dest" ]; then
        echo "Error: Destination directory '$dest' does not exist" >&2
        exit 1
    fi

    if [ ! -w "$dest" ]; then
        echo "Error: Destination directory '$dest' is not writable" >&2
        exit 1
    fi
}

validate_inputs "$@"
```
