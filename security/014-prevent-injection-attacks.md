# Prevent Injection Attacks

> Use safe APIs, parameterized inputs, and allowlists to prevent OS command injection, LDAP injection, template injection, and other injection vectors beyond SQL.

## Rules

- Never pass user input directly to OS commands, shell interpreters, or `eval()`-like functions
- Use language-native APIs instead of shell commands: use `fs.readdir()` instead of `exec("ls")`, use `subprocess.run([...])` with list arguments instead of shell strings
- When shell execution is unavoidable, use allowlists for permitted values — never interpolate raw user input
- Use `subprocess.run(["cmd", "arg"], shell=False)` (Python), `execFile` (Node.js), or `exec.Command` (Go) with argument arrays — never `shell=True` with user input
- Prevent template injection: never pass user input as template source — only use it as template data/context
- Prevent LDAP injection: escape special characters or use parameterized LDAP queries
- Prevent XML injection (XXE): disable external entity processing in XML parsers
- Prevent header injection: validate and sanitize values before setting HTTP headers
- Prevent log injection: sanitize log inputs to prevent log forging (strip newlines, control characters)
- Apply the principle of least authority: run processes with minimal OS permissions

## Example

```python
# Bad: OS command injection
import os
os.system(f"convert {user_filename} output.png")  # Shell injection

# Good: safe subprocess with argument list
import subprocess
subprocess.run(["convert", user_filename, "output.png"], check=True, shell=False)
```

```javascript
// Bad: eval with user input
const result = eval(userExpression); // Code injection

// Bad: shell command with interpolation
exec(`grep ${userInput} /var/log/app.log`); // Command injection

// Good: safe child process with argument array
execFile("grep", [userInput, "/var/log/app.log"], (err, stdout) => {
  // userInput is passed as an argument, not interpolated into shell
});
```

```python
# Bad: template injection
from jinja2 import Template
Template(user_input).render()  # User controls the template itself

# Good: user input as template data only
from jinja2 import Template
Template("Hello, {{ name }}!").render(name=user_input)
```
