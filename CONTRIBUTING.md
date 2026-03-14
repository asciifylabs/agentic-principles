# Contributing to Asciify Skills

Thanks for your interest in contributing! This project thrives on community input — whether it's fixing a typo, improving an existing principle, or adding support for a new technology.

## Ways to Contribute

- **Improve existing principles** — clarify wording, add better examples, fix inaccuracies
- **Add new principles** — for existing or new technology categories
- **Report issues** — found a bug in the install script? Let us know
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
2. Add a trigger entry in `build-skills.sh` (`get_trigger` function)
3. Add at least 5 initial principles
4. Run `./build-skills.sh` to generate the skill file
5. Add the skill to `SKILL_FILES` in `install.sh`
6. Add the category to `README.md` (skills table, supported technologies, and principles reference)

## Development Setup

```bash
git clone https://github.com/asciifylabs/asciify-skills.git
cd asciify-skills

# Build skill files from source principles
./build-skills.sh

# Test installation locally
bash install.sh --local

# Run tests
bash test.sh
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
