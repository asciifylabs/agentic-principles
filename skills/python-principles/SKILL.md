---
name: python-principles
description: "Python engineering standards for .py, pyproject.toml, requirements, setup files, tests, packaging, linting, or review."
license: MIT
paths: ["**/*.py", "**/pyproject.toml", "**/requirements*.txt", "**/setup.py", "**/setup.cfg", "**/uv.lock", "**/poetry.lock"]
globs: ["**/*.py", "**/pyproject.toml", "**/requirements*.txt", "**/setup.py", "**/setup.cfg", "**/uv.lock", "**/poetry.lock"]
metadata:
  asciify-source: asciify-skills
  asciify-category: python
---

# Python Principles

Use this skill as standing guidance for this domain. Apply the checklist first; read the detailed reference only when the task is substantial, risky, unfamiliar, or review-oriented.

## Operating Rules

- Prefer the repository's existing conventions, toolchain, and CI commands over generic defaults.
- Make the smallest coherent change that satisfies the request while preserving behavior.
- Treat tests, linting, dependency hygiene, and security review as part of completion.
- If a principle conflicts with higher-priority repository instructions or an explicit user request, follow the higher-priority instruction and call out the tradeoff.

## Core Checklist

- Use `pyproject.toml` for modern packaging, tool configuration, and Python version constraints.
- Prefer type hints for public and non-trivial internal functions; check them with pyright or mypy when configured.
- Use Ruff for linting and formatting unless the project has a different standard.
- Manage dependencies with a lock-capable workflow such as uv, Poetry, PDM, pip-tools, or an existing project convention.
- Use context managers for resources, pathlib for filesystem paths, and dataclasses or typed models for structured data.
- Avoid mutable defaults, broad exception swallowing, global runtime state, and unstructured logging.
- Write focused pytest tests for changed behavior, including edge cases and failure paths.
- Keep secrets out of source and client bundles; load them from environment or a secret manager.

## Validation

Run applicable checks when they exist in the project; if a tool is missing, report that it was skipped.

- `ruff check --fix .`
- `ruff format .`
- `pytest` for changed behavior
- `pyright` or `mypy` when configured for the project

## Detailed Reference

For the complete principle set with examples and edge cases, read [references/principles.md](references/principles.md) when deeper guidance is useful.
