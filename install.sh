#!/bin/bash
# Asciify Skills installer
# Usage:
#   install.sh [--global|--local] [--agent claude|codex|both]
#   install.sh --uninstall [--agent claude|codex|both]

set -euo pipefail

REPO="asciifylabs/asciify-skills"
BRANCH="main"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

SKILL_NAMES=(
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

COMMAND_FILES=(
  asciify-skills-update.md
  asciify-skills-uninstall.md
  asciify-skills-help.md
)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }
warning() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

MODE=""
AGENT="both"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --global)    MODE="global"; shift ;;
    --local)     MODE="local"; shift ;;
    --uninstall) MODE="uninstall"; shift ;;
    --agent)
      [[ $# -ge 2 ]] || error "--agent requires claude, codex, or both"
      AGENT="$2"
      shift 2
      ;;
    --claude) AGENT="claude"; shift ;;
    --codex)  AGENT="codex"; shift ;;
    --both)   AGENT="both"; shift ;;
    *)        error "Unknown option: $1. Usage: $0 [--global|--local|--uninstall] [--agent claude|codex|both]" ;;
  esac
done

case "${AGENT}" in
  claude|codex|both) ;;
  *) error "Invalid agent '${AGENT}'. Expected claude, codex, or both." ;;
esac

SCRIPT_DIR=""
if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
  candidate_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if [[ -f "${candidate_dir}/skills/security-principles/SKILL.md" ]]; then
    SCRIPT_DIR="${candidate_dir}"
  fi
fi

agent_enabled() {
  case "${AGENT}:$1" in
    both:*|claude:claude|codex:codex) return 0 ;;
    *) return 1 ;;
  esac
}

resolve_mode() {
  case "${MODE}" in
    global|local|uninstall) return 0 ;;
    "")
      echo ""
      echo "Asciify Skills installer"
      echo ""
      echo "Where would you like to install?"
      echo "  1) Global - all projects"
      echo "  2) Local  - this project only"
      echo ""
      read -r -p "Select [1/2]: " choice
      case "${choice}" in
        1) MODE="global" ;;
        2) MODE="local" ;;
        *) error "Invalid choice" ;;
      esac
      ;;
    *) error "Invalid mode '${MODE}'" ;;
  esac
}

download_file() {
  local path="$1"
  local dest="$2"

  if [[ -n "${SCRIPT_DIR}" && -f "${SCRIPT_DIR}/${path}" ]]; then
    cp "${SCRIPT_DIR}/${path}" "${dest}"
    return 0
  fi

  local url="${RAW_BASE}/${path}"
  if ! curl -sSfL "${url}" -o "${dest}" 2>/dev/null; then
    error "Failed to download ${url}"
  fi
}

install_skill_to_root() {
  local root="$1"
  local skill="$2"
  local dest="${root}/${skill}"

  mkdir -p "${dest}/references" "${dest}/agents"
  download_file "skills/${skill}/SKILL.md" "${dest}/SKILL.md"
  download_file "skills/${skill}/references/principles.md" "${dest}/references/principles.md"
  download_file "skills/${skill}/agents/openai.yaml" "${dest}/agents/openai.yaml"

  {
    echo "repo=${REPO}"
    echo "skill=${skill}"
  } > "${dest}/.asciify-skills"
}

install_skills_root() {
  local label="$1"
  local root="$2"

  info "Installing ${label} skills to ${root}"
  mkdir -p "${root}"

  for skill in "${SKILL_NAMES[@]}"; do
    install_skill_to_root "${root}" "${skill}"
    success "Installed ${label} skill ${skill}"
  done

  download_file "skills/.version" "${root}/.asciify-skills-version"
}

install_claude_commands() {
  local commands_dir="$1"

  info "Installing Claude commands to ${commands_dir}"
  mkdir -p "${commands_dir}"

  for cmd in "${COMMAND_FILES[@]}"; do
    local dest_name="${cmd#asciify-skills-}"
    download_file "skills/${cmd}" "${commands_dir}/${dest_name}"
    success "Installed command ${dest_name}"
  done
}

do_install() {
  resolve_mode

  if [[ "${MODE}" == "local" ]]; then
    if [[ ! -d ".git" ]] && ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      error "Not inside a git repository. --local must be run from a project."
    fi
  fi

  if agent_enabled claude; then
    if [[ "${MODE}" == "global" ]]; then
      install_skills_root "Claude" "${HOME}/.claude/skills"
      install_claude_commands "${HOME}/.claude/commands/asciify-skills"
    else
      install_skills_root "Claude" ".claude/skills"
      install_claude_commands ".claude/commands/asciify-skills"
    fi
  fi

  if agent_enabled codex; then
    if [[ "${MODE}" == "global" ]]; then
      install_skills_root "Codex" "${HOME}/.agents/skills"
    else
      install_skills_root "Codex" ".agents/skills"
    fi
  fi

  echo ""
  success "Asciify Skills installed for ${AGENT} (${MODE})."
  echo ""
  if agent_enabled claude; then
    info "Claude scans ~/.claude/skills for global skills and .claude/skills for project skills."
  fi
  if agent_enabled codex; then
    info "Codex scans ~/.agents/skills for user skills and .agents/skills in repositories."
  fi
}

skill_is_asciify() {
  local dir="$1"

  [[ -f "${dir}/.asciify-skills" ]] && return 0
  [[ -f "${dir}/SKILL.md" ]] && grep -q "asciify-source: asciify-skills" "${dir}/SKILL.md"
}

remove_skills_root() {
  local label="$1"
  local root="$2"
  local removed=false

  [[ -d "${root}" ]] || return 0

  for skill in "${SKILL_NAMES[@]}"; do
    local dir="${root}/${skill}"
    if [[ -d "${dir}" ]] && skill_is_asciify "${dir}"; then
      rm -rf "${dir}"
      success "Removed ${label} skill ${skill}"
      removed=true
    fi
  done

  rm -f "${root}/.asciify-skills-version" 2>/dev/null || true

  local legacy_group="${root}/asciify-skills"
  if [[ -d "${legacy_group}" ]]; then
    rm -rf "${legacy_group}"
    success "Removed legacy grouped install ${legacy_group}"
    removed=true
  fi

  if [[ "${removed}" == false ]]; then
    info "No ${label} skills found in ${root}"
  fi
}

remove_dir_if_exists() {
  local label="$1"
  local dir="$2"

  if [[ -d "${dir}" ]]; then
    rm -rf "${dir}"
    success "Removed ${label} ${dir}"
  fi
}

do_uninstall() {
  info "Uninstalling Asciify Skills for ${AGENT}"

  if agent_enabled claude; then
    remove_skills_root "Claude" "${HOME}/.claude/skills"
    remove_skills_root "Claude" ".claude/skills"
    remove_dir_if_exists "Claude commands" "${HOME}/.claude/commands/asciify-skills"
    remove_dir_if_exists "Claude commands" ".claude/commands/asciify-skills"
  fi

  if agent_enabled codex; then
    remove_skills_root "Codex" "${HOME}/.agents/skills"
    remove_skills_root "Codex" ".agents/skills"
  fi

  # Legacy pre-rename cleanup.
  remove_dir_if_exists "legacy global skills" "${HOME}/.claude/skills/agentic-principles"
  remove_dir_if_exists "legacy local skills" ".claude/skills/agentic-principles"
  local legacy_hook="${HOME}/.claude/scripts/agentic-principles-update-check.sh"
  local legacy_version="${HOME}/.claude/scripts/.agentic-principles-version"
  rm -f "${legacy_hook}" "${legacy_version}" 2>/dev/null || true

  success "Asciify Skills uninstall complete."
}

case "${MODE}" in
  uninstall) do_uninstall ;;
  *) do_install ;;
esac
