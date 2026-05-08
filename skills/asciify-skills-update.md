---
name: asciify-skills:update
description: "Update asciify-skills installations for Claude Code and Codex"
---

# Update Asciify Skills

You are updating the asciify-skills installation. Follow these steps exactly.

## Steps

1. Determine installed locations by checking for Asciify marker files:
   - Claude global skills: `~/.claude/skills/<skill>/.asciify-skills`
   - Claude local skills: `.claude/skills/<skill>/.asciify-skills`
   - Codex global skills: `~/.agents/skills/<skill>/.asciify-skills`
   - Codex local skills: `.agents/skills/<skill>/.asciify-skills`
   - If no locations exist, tell the user to install first.

2. Read the current version from `.asciify-skills-version` in each skills root if it exists.

3. Fetch the latest version metadata:
   ```bash
   curl -sSfL "https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/skills/.version" 2>/dev/null
   ```

4. Download each skill directory from GitHub and overwrite the local copy. Skills use the `<skills-root>/<name>/SKILL.md` structure with supporting `references/` and `agents/` files:
   ```bash
   REPO_RAW="https://raw.githubusercontent.com/asciifylabs/asciify-skills/main/skills"
   for skill in \
     ai-principles \
     ansible-principles \
     docker-principles \
     git-principles \
     go-principles \
     kubernetes-principles \
     nodejs-principles \
     python-principles \
     rust-principles \
     security-principles \
     shell-principles \
     terraform-principles; do
     mkdir -p "${INSTALL_DIR}/${skill}"
     mkdir -p "${INSTALL_DIR}/${skill}/references" "${INSTALL_DIR}/${skill}/agents"
     curl -sSfL "${REPO_RAW}/${skill}/SKILL.md" -o "${INSTALL_DIR}/${skill}/SKILL.md"
     curl -sSfL "${REPO_RAW}/${skill}/references/principles.md" -o "${INSTALL_DIR}/${skill}/references/principles.md"
     curl -sSfL "${REPO_RAW}/${skill}/agents/openai.yaml" -o "${INSTALL_DIR}/${skill}/agents/openai.yaml"
     printf 'repo=asciifylabs/asciify-skills\nskill=%s\n' "${skill}" > "${INSTALL_DIR}/${skill}/.asciify-skills"
   done
   curl -sSfL "${REPO_RAW}/.version" -o "${INSTALL_DIR}/.asciify-skills-version"
   ```

5. For Claude installations only, update the slash command files in the commands directory:
   - For global installs, the commands directory is `~/.claude/commands/asciify-skills/`
   - For local installs, the commands directory is `.claude/commands/asciify-skills/`
   ```bash
   COMMANDS_DIR="${INSTALL_DIR/skills/commands}"
   mkdir -p "${COMMANDS_DIR}"
   for file in update.md uninstall.md help.md; do
     curl -sSfL "${REPO_RAW}/asciify-skills-${file}" -o "${COMMANDS_DIR}/${file}"
   done
   ```

6. Report what was updated: show the old and new version (SHA), and confirm success.

## Important

- Do NOT modify `~/.claude/settings.json`
- Do NOT register any hooks
- Do NOT create Codex slash commands; Codex uses skills from `.agents/skills`
- If `curl` fails for any file, report the error and stop
- Always show the user what changed before and after
