# Use Here Documents for Multi-line Strings

> Use heredocs (`<<EOF`) to generate multi-line content instead of repeated echo statements or string concatenation.

## Rules

- Use heredocs for any multi-line output: config files, SQL, templates, usage text
- Use `<<-EOF` (with dash) to allow leading-tab indentation inside functions
- Use `<<'EOF'` (quoted delimiter) when you want to suppress variable expansion
- Prefer `cat <<EOF` over multiple `echo` statements for readability
- Do not use string concatenation or escaped newlines for multi-line content

## Example

```bash
#!/bin/bash
set -euo pipefail

generate_config() {
    local hostname="$1"
    local port="${2:-8080}"

    cat > /etc/app.conf <<-EOF
		# Application Configuration
		# Generated on $(date)

		server {
		    hostname = "$hostname"
		    port = $port
		    timeout = 30
		}

		logging {
		    level = "info"
		    file = "/var/log/app.log"
		}
	EOF
}
```
