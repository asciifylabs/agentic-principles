# Always Quote Variables

> Wrap all variable expansions and command substitutions in double quotes to prevent word splitting and glob expansion.

## Rules

- Always quote variable expansions: `"$var"` not `$var`
- Always quote command substitutions: `"$(command)"` not `$(command)`
- Always quote array expansions: `"${array[@]}"`
- Use `"$@"` to pass through all positional parameters
- Use `"$*"` only when you intentionally want a single concatenated string
- Never leave variables unquoted unless you explicitly need word splitting

## Example

```bash
#!/bin/bash
set -euo pipefail

# Good: Quoted variables
filename="/path/to/file with spaces.txt"
cp "$filename" "/backup/$filename"

# Bad: Unquoted (will break with spaces)
cp $filename /backup/$filename

# Good: Quoted command substitution
count=$(wc -l < "$filename")

# Good: Quoted array expansion
files=("file1.txt" "file2.txt")
for file in "${files[@]}"; do
    echo "Processing: $file"
done
```
