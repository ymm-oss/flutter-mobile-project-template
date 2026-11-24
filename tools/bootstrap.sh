#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# ---- Rich Output Setup ----
# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

bootstrap_result=0
step=0
START_TIME=$(date +%s)

print_step() {
  echo -e "${BLUE}Step $((++step)): $1${NC}"
}

print_result() {
  local code=$1; shift
  if [ "$code" -eq 0 ]; then
    echo -e "${GREEN}[✔] $*${NC}"
  else
    echo -e "${RED}[✖] $* (exit ${code})${NC}"
    bootstrap_result=1
  fi
}

trap 'echo -e "${RED}[✖] Aborted at step ${step}${NC}"; exit 1' ERR INT

# Move to project root
cd "$(dirname "$0")/../" || { echo -e "${RED}[✖] Failed to cd to project root${NC}"; exit 1; }
echo -e "${BLUE}[INFO] Working directory: $(pwd)${NC}"

##############################################################################
##
##  mise
##
##############################################################################
echo ""
print_step "mise install --locked"
if type mise >/dev/null 2>&1; then
  # Install only the tools in mise.toml, so global tools outside mise.lock do not fail --locked.
  project_tools=()
  while IFS=' ' read -r tool _; do
    project_tools+=("$tool")
  done < <(mise ls --local --no-header)
  if mise install --locked "${project_tools[@]}"; then
    print_result 0 "mise install --locked"
  else
    print_result $? "mise install --locked"
  fi
else
  echo -e "${YELLOW}[!] mise install --locked: Skip because it could not be found.${NC}"
  echo -e "${YELLOW}[!] See https://mise.jdx.dev/getting-started.html for installation.${NC}"
fi

##############################################################################
##
##  bun
##
##############################################################################
echo ""
print_step "bun install --frozen-lockfile --ignore-scripts"
if type bun >/dev/null 2>&1; then
  # --frozen-lockfile fails when package.json and bun.lock disagree, so the husky run below is the version in bun.lock.
  if bun install --frozen-lockfile --ignore-scripts; then
    print_result 0 "bun install --frozen-lockfile --ignore-scripts"
  else
    print_result $? "bun install --frozen-lockfile --ignore-scripts"
  fi
else
  echo -e "${YELLOW}[!] bun install --frozen-lockfile --ignore-scripts: Skip because it could not be found.${NC}"
  echo -e "${YELLOW}[!] This may be due to mise installation not completed.${NC}"
fi

echo ""
print_step "bun --bun run prepare"
if type bun >/dev/null 2>&1; then
  # bun install --ignore-scripts skips the prepare script, so run husky explicitly to enable Git hooks.
  if bun --bun run prepare; then
    print_result 0 "bun --bun run prepare"
    # husky exits 0 without enabling hooks when HUSKY=0 is set, and a worktree-level core.hooksPath overrides it.
    hooks_path=$(git config --get core.hooksPath || true)
    if [ "$hooks_path" != ".husky/_" ]; then
      echo -e "${YELLOW}[!] Git hooks are not enabled: core.hooksPath is '${hooks_path}', expected '.husky/_'.${NC}"
      echo -e "${YELLOW}[!] Check the HUSKY environment variable and 'git config --show-origin --get-all core.hooksPath'.${NC}"
    fi
  else
    print_result $? "bun --bun run prepare"
  fi
else
  echo -e "${YELLOW}[!] bun --bun run prepare: Skip because it could not be found.${NC}"
  echo -e "${YELLOW}[!] This may be due to mise installation not completed.${NC}"
fi

##############################################################################
##
##  melos
##
##############################################################################
echo ""
print_step "dart run melos bootstrap"
if type flutter >/dev/null 2>&1; then
  if flutter pub get && dart run melos bootstrap; then
    print_result 0 "dart run melos bootstrap"
  else
    print_result $? "dart run melos bootstrap"
  fi
else
  echo -e "${YELLOW}[!] dart run melos bootstrap: Skip because flutter could not be found.${NC}"
  echo -e "${YELLOW}[!] This may be due to mise installation not completed.${NC}"
fi

##############################################################################
##
##  Finish
##
##############################################################################
echo ""
ELAPSED=$(( $(date +%s) - START_TIME ))
echo -e "${BLUE}[INFO] Total elapsed time: ${ELAPSED}s${NC}"
echo -e "${BLUE}[END] Bootstrap finished${NC}"
exit $bootstrap_result
