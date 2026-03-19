# Use ShellCheck and shfmt

> Run static analysis and formatting tools on all shell scripts to catch bugs, portability issues, and style inconsistencies.

## Rules

- Run `shellcheck` on all scripts before committing to catch common pitfalls
- Use `shfmt` to enforce consistent formatting across the project
- Address ShellCheck warnings; suppress only with inline comments and justification
- Configure ShellCheck directives at the top of scripts for project-wide settings
- Enable ShellCheck in your editor for real-time feedback
- Run both tools in CI to block non-compliant code
- Use `shfmt -d` in CI to check formatting without modifying files

## Example

```bash
#!/bin/bash
# shellcheck shell=bash
# shellcheck disable=SC2034  # VAR appears unused but is exported by sourcing script

# Run ShellCheck on a script
shellcheck script.sh

# Run ShellCheck on all scripts recursively
find . -name '*.sh' -exec shellcheck {} +

# Format a script in place
shfmt -w -i 2 -ci script.sh

# Check formatting without modifying (for CI)
shfmt -d -i 2 -ci script.sh
```

```bash
# Bad: ShellCheck would catch these
echo $unquoted_var         # SC2086: Double quote to prevent globbing
cat $file | grep pattern   # SC2002: Useless use of cat
cd /some/dir               # SC2164: Use cd ... || exit

# Good: ShellCheck-clean code
echo "${unquoted_var}"
grep pattern "$file"
cd /some/dir || exit 1
```
