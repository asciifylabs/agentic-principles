# Claude Code Session Hook Setup

This guide explains how to configure Claude Code to automatically load coding principles at the start of every session.

## Quick Setup

1. **Locate your Claude Code settings file:**

   ```bash
   ~/.claude/settings.json
   ```

2. **Add the session start hook configuration:**

   If the file doesn't exist, create it with this content:

   ```json
   {
     "sessionStartHooks": [
       {
         "name": "Load Coding Principles",
         "command": "bash",
         "args": [
           "-c",
           "bash ~/.local/share/claude-principles/fetch-principles.sh && cat /tmp/claude-principles-active.md"
         ],
         "timeout": 30000
       }
     ]
   }
   ```

   If the file already exists, add the `sessionStartHooks` array to your existing configuration.

3. **Adjust the path:**

   Update the path in the `args` to point to where you installed `fetch-principles.sh`. Common locations:
   - `~/.local/share/claude-principles/fetch-principles.sh`
   - `/path/to/your/project/.git/hooks/fetch-principles.sh`
   - Or use the full absolute path

## Alternative: Manual Path

If you prefer to use a specific path, you can use:

```json
{
  "sessionStartHooks": [
    {
      "name": "Load Coding Principles",
      "command": "bash",
      "args": ["-c", "cat /tmp/claude-principles-active.md"],
      "timeout": 10000
    }
  ]
}
```

This assumes you've already run the git hooks to populate `/tmp/claude-principles-active.md`.

## Verification

1. Start a new Claude Code session
2. Check if the principles are loaded by asking Claude about them
3. Verify the file exists: `cat /tmp/claude-principles-active.md`

If the file is empty or missing, run the fetch script manually:

```bash
bash ~/.local/share/claude-principles/fetch-principles.sh
```

## Troubleshooting

### Hook doesn't run

- Check the path to `fetch-principles.sh` is correct
- Ensure the script is executable: `chmod +x fetch-principles.sh`
- Check Claude Code logs for errors

### Principles not loading

- Verify the output file exists: `ls -la /tmp/claude-principles-active.md`
- Check file permissions
- Run the script manually with verbose mode: `VERBOSE=true bash fetch-principles.sh`

### Timeout errors

- Increase the timeout value (default: 30000ms = 30 seconds)
- Check network connectivity to GitHub
- Consider using the cached version by running the script once manually

## Additional Configuration

You can customize the behavior with environment variables:

```json
{
  "sessionStartHooks": [
    {
      "name": "Load Coding Principles",
      "command": "bash",
      "args": [
        "-c",
        "VERBOSE=true EXTRA_CATEGORIES='ansible' bash ~/.local/share/claude-principles/fetch-principles.sh && cat /tmp/claude-principles-active.md"
      ],
      "timeout": 30000
    }
  ]
}
```

Available environment variables:

- `VERBOSE=true` - Enable verbose logging
- `EXTRA_CATEGORIES="category1 category2"` - Add additional categories
- `PRINCIPLES_REPO_DIR=/custom/path` - Use custom cache directory
- `PRINCIPLES_OUTPUT=/custom/output.md` - Use custom output file
- `SKIP_SETTINGS=true` - Disable automatic merge of Claude Code permissions

## Automatic Settings Sync

The `fetch-principles.sh` script automatically merges Claude Code permissions from the principles repo's `claude-settings.json` into your `~/.claude/settings.json`. This includes pre-approved safe commands (read-only git operations, basic shell utilities, etc.) so Claude Code won't prompt for confirmation on those commands.

The merge is additive -- it adds permissions from the repo without removing any existing permissions or other settings you've configured. It requires either `jq` or `python3` to be available.

To disable this behavior, set `SKIP_SETTINGS=true` when running the script.

## More Information

For more details, see the main repository:

- GitHub: https://github.com/Exobitt/principles
- Troubleshooting: https://github.com/Exobitt/principles/blob/main/docs/TROUBLESHOOTING.md
