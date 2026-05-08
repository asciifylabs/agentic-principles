#!/bin/bash
# Asciify Skills test suite.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="${SCRIPT_DIR}/skills"
PASS=0
FAIL=0
ERRORS=""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

pass() {
  PASS=$((PASS + 1))
  echo -e "  ${GREEN}PASS${NC} $1"
}

fail() {
  FAIL=$((FAIL + 1))
  ERRORS="${ERRORS}\n  - $1"
  echo -e "  ${RED}FAIL${NC} $1"
}

section() {
  echo ""
  echo -e "${YELLOW}=== $1 ===${NC}"
}

EXPECTED_SKILLS=(
  ai-principles
  ansible-principles
  docker-principles
  git-principles
  go-principles
  kubernetes-principles
  nodejs-principles
  python-principles
  rust-principles
  security-principles
  shell-principles
  terraform-principles
)

MGMT_COMMANDS=(
  asciify-skills-update.md
  asciify-skills-uninstall.md
  asciify-skills-help.md
)

section "Build Script"

if [[ -x "${SCRIPT_DIR}/build-skills.sh" ]]; then
  pass "build-skills.sh exists and is executable"
else
  fail "build-skills.sh missing or not executable"
fi

if bash "${SCRIPT_DIR}/build-skills.sh" >/dev/null 2>&1; then
  pass "build-skills.sh runs successfully"
else
  fail "build-skills.sh failed"
fi

if [[ -f "${SKILLS_DIR}/.version" ]]; then
  pass ".version generated"
else
  fail ".version missing"
fi

section "Generated Skill Structure"

for skill in "${EXPECTED_SKILLS[@]}"; do
  skill_dir="${SKILLS_DIR}/${skill}"
  skill_file="${skill_dir}/SKILL.md"
  reference_file="${skill_dir}/references/principles.md"
  openai_yaml="${skill_dir}/agents/openai.yaml"

  if [[ -f "${skill_file}" ]]; then
    pass "${skill}: SKILL.md exists"
  else
    fail "${skill}: SKILL.md missing"
    continue
  fi

  if head -1 "${skill_file}" | grep -q "^---$"; then
    pass "${skill}: has YAML frontmatter"
  else
    fail "${skill}: missing YAML frontmatter"
  fi

  if grep -q "^name: ${skill}$" "${skill_file}"; then
    pass "${skill}: name matches directory"
  else
    fail "${skill}: name does not match directory"
  fi

  if grep -q "^description:" "${skill_file}"; then
    pass "${skill}: has description"
  else
    fail "${skill}: missing description"
  fi

  if grep -q "asciify-source: asciify-skills" "${skill_file}"; then
    pass "${skill}: has Asciify metadata"
  else
    fail "${skill}: missing Asciify metadata"
  fi

  line_count=$(wc -l < "${skill_file}" | tr -d ' ')
  if [[ ${line_count} -le 500 ]]; then
    pass "${skill}: SKILL.md is concise (${line_count} lines)"
  else
    fail "${skill}: SKILL.md too large (${line_count} lines)"
  fi

  if [[ -f "${reference_file}" ]]; then
    pass "${skill}: detailed reference exists"
  else
    fail "${skill}: detailed reference missing"
  fi

  if [[ -f "${openai_yaml}" ]] && grep -Fq "default_prompt: \"Use \$${skill}" "${openai_yaml}"; then
    pass "${skill}: agents/openai.yaml exists"
  else
    fail "${skill}: agents/openai.yaml missing or invalid"
  fi
done

section "Management Commands"

for command in "${MGMT_COMMANDS[@]}"; do
  filepath="${SKILLS_DIR}/${command}"

  if [[ -f "${filepath}" ]]; then
    pass "${command}: exists"
  else
    fail "${command}: missing"
    continue
  fi

  if grep -q "^description:" "${filepath}"; then
    pass "${command}: has description"
  else
    fail "${command}: missing description"
  fi
done

section "Installer"

if [[ -x "${SCRIPT_DIR}/install.sh" ]]; then
  pass "install.sh exists and is executable"
else
  fail "install.sh missing or not executable"
fi

for skill in "${EXPECTED_SKILLS[@]}"; do
  if grep -q "${skill}" "${SCRIPT_DIR}/install.sh"; then
    pass "install.sh includes ${skill}"
  else
    fail "install.sh missing ${skill}"
  fi
done

if grep -q ".agents/skills" "${SCRIPT_DIR}/install.sh" && grep -q ".claude/skills" "${SCRIPT_DIR}/install.sh"; then
  pass "install.sh supports Codex and Claude locations"
else
  fail "install.sh missing Codex or Claude locations"
fi

section "Install Integration"

TEMP_DIR="$(mktemp -d)"
TEMP_HOME="${TEMP_DIR}/home"
TEMP_PROJECT="${TEMP_DIR}/project"
mkdir -p "${TEMP_HOME}" "${TEMP_PROJECT}"
cd "${TEMP_PROJECT}" && git init --quiet

if HOME="${TEMP_HOME}" bash "${SCRIPT_DIR}/install.sh" --local --agent both >/dev/null 2>&1; then
  pass "Local install completed for both agents"
else
  fail "Local install failed"
fi

claude_count=0
codex_count=0
for skill in "${EXPECTED_SKILLS[@]}"; do
  [[ -f ".claude/skills/${skill}/SKILL.md" ]] && [[ -f ".claude/skills/${skill}/references/principles.md" ]] && claude_count=$((claude_count + 1))
  [[ -f ".agents/skills/${skill}/SKILL.md" ]] && [[ -f ".agents/skills/${skill}/references/principles.md" ]] && codex_count=$((codex_count + 1))
done

if [[ ${claude_count} -eq ${#EXPECTED_SKILLS[@]} ]]; then
  pass "All Claude skills installed directly"
else
  fail "Only ${claude_count}/${#EXPECTED_SKILLS[@]} Claude skills installed"
fi

if [[ ${codex_count} -eq ${#EXPECTED_SKILLS[@]} ]]; then
  pass "All Codex skills installed directly"
else
  fail "Only ${codex_count}/${#EXPECTED_SKILLS[@]} Codex skills installed"
fi

if [[ -f ".claude/commands/asciify-skills/update.md" ]] &&
   [[ -f ".claude/commands/asciify-skills/uninstall.md" ]] &&
   [[ -f ".claude/commands/asciify-skills/help.md" ]]; then
  pass "Claude management commands installed"
else
  fail "Claude management commands missing"
fi

if [[ -f ".claude/skills/.asciify-skills-version" ]] && [[ -f ".agents/skills/.asciify-skills-version" ]]; then
  pass "Version markers installed"
else
  fail "Version markers missing"
fi

if HOME="${TEMP_HOME}" bash "${SCRIPT_DIR}/install.sh" --uninstall --agent both >/dev/null 2>&1; then
  pass "Uninstall completed"
else
  fail "Uninstall failed"
fi

remaining=0
for skill in "${EXPECTED_SKILLS[@]}"; do
  [[ -d ".claude/skills/${skill}" ]] && remaining=$((remaining + 1))
  [[ -d ".agents/skills/${skill}" ]] && remaining=$((remaining + 1))
done

if [[ ${remaining} -eq 0 ]]; then
  pass "Uninstall removed installed skill directories"
else
  fail "Uninstall left ${remaining} skill directories"
fi

cd "${SCRIPT_DIR}"
rm -rf "${TEMP_DIR}"

section "Naming Consistency"

KEY_FILES=(
  install.sh
  build-skills.sh
  README.md
  CLAUDE.md
  AGENTS.md
  CONTRIBUTING.md
  skills/README.md
)

for kf in "${KEY_FILES[@]}"; do
  filepath="${SCRIPT_DIR}/${kf}"
  [[ -f "${filepath}" ]] || continue

  if [[ "${kf}" == "install.sh" ]]; then
    if grep "agentic-principles" "${filepath}" | grep -qv "legacy"; then
      fail "${kf}: references old name outside legacy cleanup"
    else
      pass "${kf}: legacy name only appears in cleanup"
    fi
  elif grep -q "agentic-principles" "${filepath}"; then
    fail "${kf}: references old name"
  else
    pass "${kf}: uses current naming"
  fi
done

echo ""
echo "================================"
total=$((PASS + FAIL))
echo -e "Results: ${GREEN}${PASS} passed${NC}, ${RED}${FAIL} failed${NC} (${total} total)"

if [[ ${FAIL} -gt 0 ]]; then
  echo -e "\nFailures:${ERRORS}"
  echo ""
  exit 1
fi

echo -e "\n${GREEN}All tests passed.${NC}"
echo ""
