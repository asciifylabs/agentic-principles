# Use Virtual Environments

> Always use virtual environments to isolate project dependencies and avoid version conflicts between projects.

## Rules

- Create a virtual environment for every Python project using `venv`, `virtualenv`, or `conda`
- Never install project dependencies globally with `pip install` outside a virtual environment
- Add `.venv/`, `venv/`, or `env/` to `.gitignore` to avoid committing virtual environments
- Activate the virtual environment before running project code or installing dependencies
- Document the Python version requirement in `README.md` or `pyproject.toml`
- Use `python -m venv` instead of the `virtualenv` command for consistency with standard library

## Example

```bash
# Bad: installing globally
pip install requests flask

# Good: using virtual environment
# Create virtual environment
python3.10 -m venv .venv

# Activate (Linux/macOS)
source .venv/bin/activate

# Activate (Windows)
.venv\Scripts\activate

# Install dependencies
pip install requests flask

# Save dependencies
pip freeze > requirements.txt

# Deactivate when done
deactivate
```

**.gitignore:**

```
# Virtual environments
.venv/
venv/
env/
ENV/
```
