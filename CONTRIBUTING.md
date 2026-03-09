# Contributing to Agentic Principles

Thanks for your interest in contributing! This project thrives on community input — whether it's fixing a typo, improving an existing principle, or adding support for a new technology.

## Ways to Contribute

- **Improve existing principles** — clarify wording, add better examples, fix inaccuracies
- **Add new principles** — for existing or new technology categories
- **Report issues** — found a bug in the install script or hooks? Let us know
- **Suggest features** — ideas for new technology detection, formatting tools, or workflow improvements

## Adding a New Principle

1. Choose the appropriate category directory (e.g., `python/`, `go/`, `security/`)
2. Create a new file following the naming convention: `NNN-short-descriptive-name.md`
3. Use the same structure as existing principles:
   - Title (H1)
   - Summary quote block
   - Rules (bullet list)
   - Examples (code blocks with bad/good patterns)
4. Add the principle to the table in `README.md`

## Adding a New Technology Category

1. Create a new directory at the repo root (e.g., `java/`)
2. Add detection logic in `.claude/hooks/fetch-principles.sh`
3. Add a trigger entry in `build-skills.sh` (`TRIGGERS` associative array)
4. Add at least 5 initial principles
5. Run `./build-skills.sh` to generate the skill file
6. Add the skill to `SKILL_FILES` in `install-skills.sh`
7. Add the category to `README.md` (skills table, supported technologies, and principles reference)

## Development Setup

```bash
git clone https://github.com/asciifylabs/agentic-principles.git
cd agentic-principles

# Build skill files from source principles
./build-skills.sh

# Test installation locally
bash install-skills.sh --local
```

## Pull Request Guidelines

- Keep PRs focused — one principle or one feature per PR
- Follow the existing file structure and naming conventions
- Test your changes locally before submitting
- Write clear commit messages

## Code Style

- Principles are written in Markdown with consistent formatting
- Shell scripts follow the project's own shell scripting principles (`shell/`)
- Use `shellcheck` and `shfmt` for any script changes

## Questions?

Open an issue — we're happy to help.
