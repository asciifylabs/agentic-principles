---
name: asciify-skills:uninstall
description: "Remove asciify-skills installations for Claude Code and Codex"
---

# Uninstall Asciify Skills

You are uninstalling asciify-skills. Follow these steps exactly.

## Steps

1. Check for installations in both locations:
   - Claude global skills: `~/.claude/skills/<skill>/`
   - Global commands: `~/.claude/commands/asciify-skills/`
   - Claude local skills: `.claude/skills/<skill>/`
   - Local commands (current project): `.claude/commands/asciify-skills/`
   - Codex global skills: `~/.agents/skills/<skill>/`
   - Codex local skills: `.agents/skills/<skill>/`

2. For each location that exists, confirm with the user before removing:
   - Show which location(s) will be removed
   - Ask "Remove asciify-skills from [location]? (y/n)"

3. Remove only Asciify-owned skill directories. A skill is Asciify-owned if it contains `.asciify-skills` or its `SKILL.md` contains `asciify-source: asciify-skills`.
   ```bash
   rm -rf <skills_root>/<skill>
   rm -rf <commands_dir>
   ```

4. Remove `.asciify-skills-version` from each affected skills root.

5. Check if `~/.claude/settings.json` contains any leftover `asciify-skills` or `agentic-principles` hook entries. If so, offer to clean them up.

6. Confirm removal is complete.

## Important

- Always confirm with the user before deleting
- Remove direct Asciify skill directories and Claude `commands/asciify-skills/`
- Do NOT remove unrelated files in `.claude/skills/`, `.agents/skills/`, or `.claude/commands/`
