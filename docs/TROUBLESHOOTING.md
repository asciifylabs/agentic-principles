# Troubleshooting Guide

Common issues and solutions for the coding principles hook system.

## Table of Contents

- [Git Hooks Not Running](#git-hooks-not-running)
- [Permission Errors](#permission-errors)
- [Network/Firewall Issues](#networkfirewall-issues)
- [Slow Performance](#slow-performance)
- [Cache Issues](#cache-issues)
- [Claude Code Not Loading Principles](#claude-code-not-loading-principles)
- [Wrong Categories Detected](#wrong-categories-detected)
- [Hooks Not Chaining](#hooks-not-chaining)
- [Formatting Tools Not Found](#formatting-tools-not-found)
- [Pre-commit Hook Blocking Commits](#pre-commit-hook-blocking-commits)
- [Formatter Configuration Conflicts](#formatter-configuration-conflicts)

---

## Git Hooks Not Running

**Symptoms:**

- Principles not updating after checkout/merge
- Pre-commit hook not running

**Solutions:**

1. **Check hook permissions:**

   ```bash
   ls -la .git/hooks/
   # Hooks should be executable (rwxr-xr-x)
   chmod +x .git/hooks/post-checkout .git/hooks/post-merge .git/hooks/pre-commit
   ```

2. **Verify hook installation:**

   ```bash
   cat .git/hooks/post-checkout
   # Should contain reference to fetch-principles.sh
   ```

3. **Check hook path:**

   ```bash
   # Hook should be in .git/hooks/, not .githooks/
   git config core.hooksPath
   # If this returns a custom path, hooks may be elsewhere
   ```

4. **Test hook manually:**
   ```bash
   bash .git/hooks/post-checkout 0 0 1
   # Should run without errors
   ```

---

## Permission Errors

**Symptoms:**

- "Permission denied" errors
- Cannot write to /tmp

**Solutions:**

1. **Check /tmp write access:**

   ```bash
   touch /tmp/test-write && rm /tmp/test-write
   # If this fails, /tmp is not writable
   ```

2. **Use alternative output directory:**

   ```bash
   # In your shell profile or git hook:
   export PRINCIPLES_OUTPUT="$HOME/.cache/claude-principles-active.md"
   export PRINCIPLES_REPO_DIR="$HOME/.cache/claude-principles-repo"
   ```

3. **Check file ownership:**

   ```bash
   ls -la /tmp/claude-principles*
   # Files should be owned by your user
   ```

4. **Clear and recreate:**
   ```bash
   rm -rf /tmp/claude-principles-repo /tmp/claude-principles-active.md
   bash .git/hooks/fetch-principles.sh
   ```

---

## Network/Firewall Issues

**Symptoms:**

- "Failed to clone principles repository"
- Slow downloads
- SSH connection failures

**Solutions:**

1. **Check GitHub connectivity:**

   ```bash
   ping github.com
   curl -I https://github.com
   ```

2. **Test SSH access:**

   ```bash
   ssh -T git@github.com
   # Should respond with authentication message
   ```

3. **Use HTTPS instead of SSH:**
   The script automatically falls back to HTTPS if SSH fails.

4. **Use cached version:**
   If network is unavailable, the script will use the cached repository in /tmp.

5. **Corporate firewall:**
   If behind a corporate firewall:
   ```bash
   # Configure git proxy
   git config --global http.proxy http://proxy.example.com:8080
   git config --global https.proxy https://proxy.example.com:8080
   ```

---

## Slow Performance

**Symptoms:**

- Git operations feel slow
- Hook takes too long to run

**Solutions:**

1. **Check for stale locks:**

   ```bash
   rm -f /tmp/claude-principles.lock
   ```

2. **Run hooks in background:**
   The hooks already run in background by default (`&`), but you can verify:

   ```bash
   # In the hook file, ensure line ends with &
   bash "$FETCH_SCRIPT" &>/dev/null &
   ```

3. **Use shallow clone:**
   The script already uses `--depth 1`, but you can verify:

   ```bash
   git -C /tmp/claude-principles-repo rev-parse --is-shallow-repository
   # Should return "true"
   ```

4. **Disable hooks temporarily:**

   ```bash
   # For one commit:
   git commit --no-verify

   # Disable all hooks:
   git config core.hooksPath /dev/null

   # Re-enable:
   git config --unset core.hooksPath
   ```

---

## Cache Issues

**Symptoms:**

- Old principles still loading
- Changes not reflected

**Solutions:**

1. **Clear cache:**

   ```bash
   rm -rf /tmp/claude-principles-repo
   bash .git/hooks/fetch-principles.sh
   ```

2. **Force update:**

   ```bash
   git -C /tmp/claude-principles-repo fetch --all
   git -C /tmp/claude-principles-repo reset --hard origin/main
   bash .git/hooks/fetch-principles.sh
   ```

3. **Check last update time:**
   ```bash
   ls -la /tmp/claude-principles-repo
   # Check modification time
   ```

---

## Claude Code Not Loading Principles

**Symptoms:**

- Claude doesn't mention principles
- Session hook not running

**Solutions:**

1. **Verify settings.json:**

   ```bash
   cat ~/.claude/settings.json
   # Should contain sessionStartHooks configuration
   ```

2. **Check JSON syntax:**

   ```bash
   # Validate JSON:
   python3 -m json.tool ~/.claude/settings.json
   # Or:
   jq . ~/.claude/settings.json
   ```

3. **Verify script path:**

   ```json
   {
     "sessionStartHooks": [
       {
         "args": [
           "-c",
           "bash /full/path/to/fetch-principles.sh && cat /tmp/claude-principles-active.md"
         ]
       }
     ]
   }
   ```

4. **Test command manually:**

   ```bash
   bash ~/.local/share/claude-principles/fetch-principles.sh && cat /tmp/claude-principles-active.md
   # Should output principles
   ```

5. **Check Claude Code logs:**
   Look for errors in Claude Code output when starting a session.

---

## Wrong Categories Detected

**Symptoms:**

- Missing expected principles
- Unwanted categories included

**Solutions:**

1. **Check detection logic:**

   ```bash
   # Test detection:
   cd /path/to/your/project
   find . -maxdepth 3 -name '*.sh' -print -quit  # Shell
   find . -maxdepth 3 -name '*.tf' -print -quit  # Terraform
   [ -f package.json ] && echo "nodejs"           # Node.js
   ```

2. **Add extra categories:**

   ```bash
   EXTRA_CATEGORIES="ansible kubernetes" bash .git/hooks/fetch-principles.sh
   ```

3. **Adjust maxdepth:**
   Edit the script to increase maxdepth if your files are deeper:

   ```bash
   # In fetch-principles.sh:
   find . -maxdepth 5 -name '*.sh' -print -quit
   ```

4. **Force specific categories:**
   ```bash
   # Skip auto-detection, use specific categories:
   # Edit the script to set CATEGORIES directly
   CATEGORIES="shell nodejs" bash .git/hooks/fetch-principles.sh
   ```

---

## Hooks Not Chaining

**Symptoms:**

- Original hooks stopped working after installation
- Multiple hooks don't all run

**Solutions:**

1. **Check for backup:**

   ```bash
   ls -la .git/hooks/*.backup-original
   # Should exist if there were existing hooks
   ```

2. **Verify chaining code:**

   ```bash
   tail -5 .git/hooks/post-checkout
   # Should contain:
   # [ -f "$0.backup-original" ] && exec "$0.backup-original" "$@"
   ```

3. **Restore original hooks:**

   ```bash
   cd .git/hooks
   for hook in *.backup-original; do
     mv "$hook" "${hook%.backup-original}"
   done
   ```

4. **Reinstall with chaining:**
   Run the installer again - it will detect and preserve existing hooks.

---

## Formatting Tools Not Found

**Symptoms:**

- "Tool not found" messages
- Pre-commit hook skips formatting

**Solutions:**

1. **Install missing tools:**

   ```bash
   # Node.js tools (recommended):
   npm install -g prettier eslint shellcheck shfmt

   # Or using package managers:
   # macOS:
   brew install shellcheck shfmt prettier

   # Ubuntu/Debian:
   sudo apt-get install shellcheck
   npm install -g shfmt prettier eslint

   # Manual Go install (shfmt):
   go install mvdan.cc/sh/v3/cmd/shfmt@latest
   ```

2. **Verify installation:**

   ```bash
   command -v shellcheck && echo "shellcheck ✓"
   command -v shfmt && echo "shfmt ✓"
   command -v prettier && echo "prettier ✓"
   command -v eslint && echo "eslint ✓"
   ```

3. **Auto-install with installer:**

   ```bash
   curl -sSL https://raw.githubusercontent.com/asciifylabs/agentic-principles/main/install.sh | bash -s -- --auto-install-tools
   ```

4. **Skip formatting temporarily:**
   ```bash
   git commit --no-verify
   ```

---

## Pre-commit Hook Blocking Commits

**Symptoms:**

- Cannot commit due to formatting errors
- "Formatting/linting failed" message

**Solutions:**

1. **View the errors:**

   ```bash
   # Run the formatter manually to see issues:
   bash .git/hooks/format-lint.sh
   ```

2. **Auto-fix formatting:**

   ```bash
   # The hook should auto-fix, but you can run manually:
   FORMAT_LINT_MODE=fix bash .git/hooks/format-lint.sh
   git add .
   git commit
   ```

3. **Check specific file:**

   ```bash
   # For shell scripts:
   shellcheck problematic-file.sh
   shfmt -d problematic-file.sh

   # For JS/TS:
   prettier --check problematic-file.js
   eslint problematic-file.js
   ```

4. **Skip hook once:**

   ```bash
   git commit --no-verify -m "message"
   ```

5. **Disable formatting hook:**

   ```bash
   # Temporarily rename the hook:
   mv .git/hooks/pre-commit .git/hooks/pre-commit.disabled

   # Re-enable later:
   mv .git/hooks/pre-commit.disabled .git/hooks/pre-commit
   ```

---

## Formatter Configuration Conflicts

**Symptoms:**

- Formatting changes don't match team style
- Constant formatting conflicts

**Solutions:**

1. **Use project configuration files:**
   Create configuration files in your project root:

   **`.prettierrc`:**

   ```json
   {
     "printWidth": 100,
     "tabWidth": 2,
     "useTabs": false,
     "semi": true,
     "singleQuote": false,
     "trailingComma": "es5"
   }
   ```

   **`.eslintrc.json`:**

   ```json
   {
     "extends": ["eslint:recommended"],
     "rules": {
       "indent": ["error", 2],
       "quotes": ["error", "single"]
     }
   }
   ```

   **`.editorconfig`:**

   ```ini
   root = true

   [*]
   indent_style = space
   indent_size = 2
   end_of_line = lf
   charset = utf-8
   trim_trailing_whitespace = true
   insert_final_newline = true
   ```

2. **Check configuration hierarchy:**

   ```bash
   # Formatters check for config in this order:
   # 1. Project root (.prettierrc, .eslintrc)
   # 2. Home directory (~/.prettierrc, ~/.eslintrc)
   # 3. Tool defaults
   ```

3. **Ignore specific files:**

   **`.prettierignore`:**

   ```
   # Ignore artifacts:
   build/
   dist/
   node_modules/
   *.min.js
   ```

   **`.eslintignore`:**

   ```
   node_modules/
   dist/
   build/
   ```

4. **Team sync:**
   Commit your config files so the whole team uses the same formatting:
   ```bash
   git add .prettierrc .eslintrc.json .editorconfig
   git commit -m "Add formatting configuration"
   ```

---

## Still Having Issues?

If none of these solutions work:

1. **Enable verbose mode:**

   ```bash
   VERBOSE=true bash .git/hooks/fetch-principles.sh
   VERBOSE=true bash .git/hooks/format-lint.sh
   ```

2. **Check system requirements:**
   - Git 2.0+
   - Bash 4.0+
   - Curl or wget
   - Write access to /tmp

3. **Report an issue:**
   - GitHub Issues: https://github.com/asciifylabs/agentic-principles/issues
   - Include error messages and verbose output
   - Mention your OS and versions

4. **Manual fallback:**
   If hooks don't work, you can always run scripts manually:

   ```bash
   # Fetch principles:
   bash .git/hooks/fetch-principles.sh

   # Format code:
   bash .git/hooks/format-lint.sh
   ```
