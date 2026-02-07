# Use Arrays for Multiple Values

> Store lists of values in bash arrays instead of space-separated strings to correctly handle entries with spaces and special characters.

## Rules

- Use arrays for any list of items: files, options, arguments
- Always quote array expansions: `"${array[@]}"`
- Append with `+=`: `array+=("new_item")`
- Get length with `"${#array[@]}"`
- Iterate with `for item in "${array[@]}"; do ... done`
- Never use unquoted space-separated strings as a substitute for arrays
- Note: arrays require bash -- they are not available in POSIX sh

## Example

```bash
#!/bin/bash
set -euo pipefail

# Good: Using arrays
files=("file1.txt" "file with spaces.txt" "file2.txt")

for file in "${files[@]}"; do
    echo "Processing: $file"
done

# Appending to array
files+=("newfile.txt")

# Array length
echo "Total files: ${#files[@]}"

# Bad: Space-separated string (breaks with spaces)
files="file1.txt file with spaces.txt"
for file in $files; do  # This will split incorrectly
    echo "$file"
done
```
