# Principles

At the start of every conversation, you MUST run the following script and then read `/tmp/claude-principles-active.md` before doing any work. These are non-negotiable coding standards -- if you are about to write code that violates a principle, stop and fix it. When reviewing code, flag any violations.

If the user asks you to work with a technology that wasn't initially detected, re-run the script with the category appended (e.g. `EXTRA_CATEGORIES="ansible kubernetes"`).

```sh
#!/bin/bash
set -euo pipefail

REPO_DIR="/tmp/claude-principles-repo"
OUTPUT="/tmp/claude-principles-active.md"
REPO_SSH="git@github.com:Exobitt/principles.git"
REPO_HTTPS="https://github.com/Exobitt/principles.git"

# Clone or update
if [ -d "$REPO_DIR/.git" ]; then
  git -C "$REPO_DIR" pull --ff-only -q 2>/dev/null || true
else
  rm -rf "$REPO_DIR"
  git clone --depth 1 -q "$REPO_SSH" "$REPO_DIR" 2>/dev/null || \
  git clone --depth 1 -q "$REPO_HTTPS" "$REPO_DIR" 2>/dev/null || \
  { echo "Failed to clone principles repo" >&2; exit 1; }
fi

# Detect relevant categories
CATEGORIES=""
# Shell: *.sh files
find . -maxdepth 3 -name '*.sh' -print -quit 2>/dev/null | grep -q . && CATEGORIES="$CATEGORIES shell"
# Terraform: *.tf files
find . -maxdepth 3 -name '*.tf' -print -quit 2>/dev/null | grep -q . && CATEGORIES="$CATEGORIES terraform"
# Ansible: ansible.cfg, playbooks/, roles/
{ [ -f ansible.cfg ] || [ -d playbooks ] || [ -d roles ]; } && CATEGORIES="$CATEGORIES ansible"
# Kubernetes: Chart.yaml, kustomization.yaml, or yaml with apiVersion
{ [ -f Chart.yaml ] || [ -f kustomization.yaml ] || find . -maxdepth 3 -name '*.yaml' -exec grep -l 'apiVersion:' {} + 2>/dev/null | head -1 | grep -q .; } && CATEGORIES="$CATEGORIES kubernetes"

# Append any extra categories passed via env var
CATEGORIES="$CATEGORIES ${EXTRA_CATEGORIES:-}"

# Fallback: if nothing detected, use all
if [ -z "$(echo "$CATEGORIES" | tr -d ' ')" ]; then
  CATEGORIES="shell ansible terraform kubernetes"
fi

# Concatenate relevant principles into a single file
> "$OUTPUT"
for cat in $CATEGORIES; do
  dir="$REPO_DIR/$cat"
  [ -d "$dir" ] || continue
  echo "# ${cat^^} PRINCIPLES" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
  for f in "$dir"/*.md; do
    [ -f "$f" ] || continue
    cat "$f" >> "$OUTPUT"
    echo -e "\n---\n" >> "$OUTPUT"
  done
done

echo "Loaded principles: $CATEGORIES"
```
