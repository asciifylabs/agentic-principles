# Contributing to Asciify Skills

Thanks for your interest in contributing. This project accepts fixes to source principles, generated skill layout, installer behavior, and documentation for Claude Code and Codex.

## Ways to Contribute

- **Improve existing principles** — clarify wording, add better examples, fix inaccuracies
- **Add new principles** — for existing or new technology categories
- **Report issues** — found a bug in the install script or generated skill layout? Let us know
- **Suggest features** — ideas for new categories, validation tools, or workflow improvements

## Adding a New Principle

1. Choose the appropriate category directory (e.g., `python/`, `go/`, `security/`)
2. Create a new file following the naming convention: `NNN-short-descriptive-name.md`
3. Use the same structure as existing principles:
   - Title (H1)
   - Summary quote block
   - Rules (bullet list)
   - Examples (code blocks with bad/good patterns)
4. Run `bash build-skills.sh`
5. Run `bash test.sh`

## Adding a New Technology Category

1. Create a new directory at the repo root (e.g., `java/`)
2. Add a trigger entry in `build-skills.sh` (`get_trigger` function)
3. Add at least 5 initial principles
4. Add a path entry in `build-skills.sh` (`get_paths` function) when file-based activation is useful for Claude Code
5. Add a checklist in `build-skills.sh` (`generate_core_checklist` and `generate_validation_section`)
6. Add the skill name to `SKILL_NAMES` in `install.sh`
7. Update `README.md`, `skills/README.md`, and `test.sh`
8. Run `bash build-skills.sh` and `bash test.sh`

## Development Setup

```bash
git clone https://github.com/asciifylabs/asciify-skills.git
cd asciify-skills

# Build skill files from source principles
bash build-skills.sh

# Test installation locally for both supported agents
bash install.sh --local --agent both

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
- Generated `SKILL.md` files should stay concise; detailed examples belong in `references/principles.md`
- Shell scripts follow the project's own shell scripting principles (`shell/`)
- Use `shellcheck` and `shfmt` for any script changes

## Questions?

Open an issue — we're happy to help.
