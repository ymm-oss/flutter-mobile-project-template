#!/usr/bin/env bash
#
# Claude Code SessionStart hook: bootstrap the workspace of the session when it has not
# been bootstrapped yet. The check and the bootstrap live in tools/ensure-bootstrap.sh;
# this script only adapts the hook's input and output.
#
# The workspace comes from "cwd" in the hook input (JSON on stdin). In the desktop app,
# hooks are read from the main checkout and run at its root even when the session works
# in a git worktree, so neither the current directory nor $CLAUDE_PROJECT_DIR tells
# which workspace the session uses.
#
# Prints nothing when the workspace is ready. When bootstrap fails, it prints a notice to
# stdout and still exits 0: Claude Code adds the plain stdout of a SessionStart hook to
# Claude's context only on exit 0, shows stderr to the user only, and never lets this
# hook block the session.

set -uo pipefail

# With CDPATH set, cd prints the directory it moved to, which breaks $(cd ... && pwd).
unset CDPATH

input="$(cat)"
root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# jq is a mise tool of this repository; macOS also ships one.
read_session_dir() {
  if command -v jq >/dev/null 2>&1; then
    jq -r '.cwd // empty'
  elif command -v mise >/dev/null 2>&1; then
    (cd "$root_dir" && mise exec -- jq -r '.cwd // empty')
  fi
}
session_dir="$(printf '%s' "$input" | read_session_dir 2>/dev/null || true)"
# Without jq the input cannot be read. The current directory is right except for
# a worktree session in the desktop app; the mise tasks still guard that case.
[ -n "$session_dir" ] || session_dir="$PWD"

# Only handle a clone or worktree of this repository. The session can be somewhere else,
# for example after it moved to another directory and was resumed.
common_dir() {
  git -C "$1" rev-parse --path-format=absolute --git-common-dir 2>/dev/null
}
[ -d "$session_dir" ] || exit 0
session_common_dir="$(common_dir "$session_dir")" || exit 0
[ "$session_common_dir" = "$(common_dir "$root_dir")" ] || exit 0

log_file="$(mktemp "${TMPDIR:-/tmp}/ensure-bootstrap.XXXXXX")"
if "$root_dir/tools/ensure-bootstrap.sh" "$session_dir" >"$log_file" 2>&1; then
  rm -f "$log_file"
  exit 0
fi

workspace_dir="$(git -C "$session_dir" rev-parse --show-toplevel 2>/dev/null || echo "$session_dir")"
# Drop the color codes of bootstrap.sh.
plain_log() {
  sed $'s/\x1b\\[[0-9;]*m//g' "$log_file"
}
cat <<EOF
Bootstrapping this workspace at session start failed: $workspace_dir
It had no .dart_tool/package_config.json, so \`mise run bootstrap\` ran there and did not finish successfully. Until bootstrap succeeds, Dart may resolve packages from a parent directory, so analysis and tests can pass against the wrong sources.
Tell the user about this, then run \`mise run bootstrap\` in that directory and fix the error before you analyze or test.
Failed steps, then the last lines of the log ($log_file):
EOF
# bootstrap.sh keeps going after a failed step, so the failure can be far from the end.
plain_log | grep -F '[✖]' || true
echo '...'
plain_log | tail -n 10
exit 0
