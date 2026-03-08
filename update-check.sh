#!/bin/bash
set -euo pipefail

# Update check for agentic-principles
# Called at session start to notify if a newer version is available.
# Non-blocking and fast — exits silently on any failure or if checked recently.

VERSION_FILE="${HOME}/.claude/scripts/.agentic-principles-version"

# If version file doesn't exist, nothing is installed — exit silently
if [ ! -f "$VERSION_FILE" ]; then
  exit 0
fi

# Source version file to get SHA, LAST_CHECK, INSTALL_DIR
# shellcheck source=/dev/null
source "$VERSION_FILE"

# Ensure required variables exist (set -u would catch this, but be explicit)
: "${SHA:=}"
: "${LAST_CHECK:=0}"

# Check if 24 hours have elapsed since last check
current_time="$(date +%s)"
elapsed=$(( current_time - LAST_CHECK ))
if [ "$elapsed" -lt 86400 ]; then
  exit 0
fi

# Fetch remote SHA with a 5-second timeout
remote_sha=""
remote_sha="$(timeout 5 git ls-remote --heads https://github.com/asciifylabs/agentic-principles.git refs/heads/main 2>/dev/null | awk '{print $1}')" || true

# If network unavailable (empty result), exit silently
if [ -z "$remote_sha" ]; then
  exit 0
fi

# Update LAST_CHECK timestamp in the version file regardless of result
if [ -f "$VERSION_FILE" ]; then
  if grep -q '^LAST_CHECK=' "$VERSION_FILE"; then
    sed -i "s/^LAST_CHECK=.*/LAST_CHECK=${current_time}/" "$VERSION_FILE"
  else
    echo "LAST_CHECK=${current_time}" >> "$VERSION_FILE"
  fi
fi

# If remote SHA differs from installed SHA, notify the user
if [ -n "$SHA" ] && [ "$remote_sha" != "$SHA" ]; then
  local_short="${SHA:0:7}"
  remote_short="${remote_sha:0:7}"
  echo "Agentic Principles update available (installed: ${local_short}, latest: ${remote_short}). To update, run:"
  echo "  curl -sSL https://raw.githubusercontent.com/asciifylabs/agentic-principles/main/install-skills.sh | bash -s -- --update"
fi
