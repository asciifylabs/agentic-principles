# Use pathlib Over os.path

> Use the modern `pathlib` module for path operations instead of string manipulation with `os.path` for cleaner, cross-platform code.

## Rules

- Import `Path` from `pathlib` and use it for all file path operations
- Use `/` operator to join paths instead of `os.path.join()`
- Use Path methods like `.exists()`, `.read_text()`, `.write_text()` for common operations
- Use `.glob()` and `.rglob()` for pattern matching instead of `glob.glob()`
- Convert Path objects to strings only when interfacing with legacy APIs
- Use `.resolve()` to get absolute paths instead of `os.path.abspath()`
- Leverage `.stem`, `.suffix`, `.parent`, `.name` properties for path components

## Example

```python
# Bad: using os.path with string manipulation
import os
import glob

config_dir = os.path.join(os.getcwd(), "config")
config_file = os.path.join(config_dir, "app.yaml")

if os.path.exists(config_file):
    with open(config_file) as f:
        content = f.read()

yaml_files = glob.glob(os.path.join(config_dir, "*.yaml"))

# Good: using pathlib
from pathlib import Path

config_dir = Path.cwd() / "config"
config_file = config_dir / "app.yaml"

if config_file.exists():
    content = config_file.read_text()

yaml_files = list(config_dir.glob("*.yaml"))

# Useful Path operations
filename = config_file.stem  # "app"
extension = config_file.suffix  # ".yaml"
parent = config_file.parent  # config_dir
absolute = config_file.resolve()  # full absolute path
```
