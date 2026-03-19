# Follow Security Best Practices

> Write shell scripts that are resistant to injection, privilege escalation, and information leakage.

## Rules

- Never pass unsanitized input to `eval`, `source`, or command substitution
- Use `--` to separate options from arguments when passing user input to commands
- Avoid storing secrets in variables; use files with restricted permissions or environment variables from a secrets manager
- Set restrictive `umask` (0077) before creating files with sensitive content
- Drop privileges with `su` or `runuser` as soon as elevated access is no longer needed
- Validate all inputs against expected patterns; reject anything unexpected
- Use `mktemp` for temporary files; never use predictable filenames in `/tmp`

## Example

```bash
# Bad: command injection via unsanitized input
user_input="$1"
eval "echo $user_input"           # Arbitrary command execution
grep $user_input /etc/passwd      # Glob expansion, option injection

# Good: safe input handling
user_input="$1"

# Validate input against expected pattern
if [[ ! "$user_input" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo "Error: invalid input" >&2
    exit 1
fi

# Use -- to prevent option injection
grep -- "$user_input" /etc/passwd

# Safe temporary file creation
tmpfile="$(mktemp)" || exit 1
trap 'rm -f "$tmpfile"' EXIT

# Restrict permissions before writing secrets
umask 0077
echo "$secret_value" > "$tmpfile"
```
