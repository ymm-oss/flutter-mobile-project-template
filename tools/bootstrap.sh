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
print_step "mise install"
if type mise >/dev/null 2>&1; then
  if mise install; then
    print_result 0 "mise install"
  else
    print_result $? "mise install"
  fi
else
  echo -e "${YELLOW}[!] mise install: Skip because it could not be found.${NC}"
  echo -e "${YELLOW}[!] See https://mise.jdx.dev/getting-started.html for installation.${NC}"
fi

##############################################################################
##
##  bun
##
##############################################################################
echo ""
print_step "bun install --ignore-scripts"
if type bun >/dev/null 2>&1; then
  if bun install --ignore-scripts; then
    print_result 0 "bun install --ignore-scripts"
  else
    print_result $? "bun install --ignore-scripts"
  fi
else
  echo -e "${YELLOW}[!] bun install --ignore-scripts: Skip because it could not be found.${NC}"
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
