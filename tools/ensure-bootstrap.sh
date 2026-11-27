#!/usr/bin/env bash
#
# Bootstrap a workspace only when it has not been bootstrapped yet.
#
# Usage: tools/ensure-bootstrap.sh [directory]
#   directory: any directory inside the workspace to check (a clone or a git worktree).
#              Defaults to the workspace this script belongs to.
#
# A workspace counts as bootstrapped when it has .dart_tool/package_config.json.
# Without that file, Dart looks for one in the parent directories. A git worktree
# under .claude/worktrees/ then resolves packages from the main checkout, so
# analysis and tests pass against the wrong sources instead of failing.
#
# Only the existence of the file is checked. This does not notice that
# pubspec.lock changed after the last bootstrap, or that a bootstrap failed
# after it had created the file.
#
# Without a directory, this also fails when the mise task was started in another
# workspace. mise reads the mise.toml of the parent directories too: in a worktree
# whose mise.toml does not define a task, the task of the main checkout runs, in
# the main checkout. Its results would be about the wrong sources.

set -euo pipefail

# With CDPATH set, a relative cd can move to another directory, and cd prints
# where it went, which breaks $(cd ... && pwd).
unset CDPATH

if [ $# -gt 1 ]; then
  echo "Usage: tools/ensure-bootstrap.sh [directory]" >&2
  exit 2
fi

if [ $# -eq 1 ]; then
  if [ ! -d "$1" ]; then
    echo "Not a directory: $1" >&2
    exit 1
  fi
  # The root of the clone or worktree that contains the directory.
  # git explains a failure on stderr (not a repository, git not found, ...).
  if ! workspace_dir="$(git -C "$1" rev-parse --show-toplevel)"; then
    echo "Could not find the git work tree that contains: $1" >&2
    exit 1
  fi
else
  workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

  # mise sets MISE_ORIGINAL_CWD to the directory where `mise run` was started.
  # Both sides go through git, so symlinks in the paths do not matter.
  # When either side cannot be resolved, the check is skipped.
  caller_dir="${MISE_ORIGINAL_CWD:-}"
  if [ -n "$caller_dir" ] && [ -d "$caller_dir" ]; then
    caller_workspace="$(git -C "$caller_dir" rev-parse --show-toplevel 2>/dev/null || true)"
    this_workspace="$(git -C "$workspace_dir" rev-parse --show-toplevel 2>/dev/null || true)"
    if [ -n "$caller_workspace" ] && [ -n "$this_workspace" ] &&
      [ "$caller_workspace" != "$this_workspace" ]; then
      {
        echo "This mise task was started in $caller_workspace, but it runs in $this_workspace."
        echo "The mise.toml in $caller_workspace probably does not define the task, so mise took it from a parent directory."
        echo "Its results would be about $this_workspace, not about $caller_workspace."
        echo "Run the task on a branch whose mise.toml defines it, for example after merging main into the branch."
      } >&2
      exit 1
    fi
  fi
fi

package_config="$workspace_dir/.dart_tool/package_config.json"

if [ -f "$package_config" ]; then
  exit 0
fi

echo "Not bootstrapped yet: $workspace_dir" >&2
echo "Running bootstrap there first (no .dart_tool/package_config.json)." >&2

# A hook can run without the PATH of an interactive shell, so look in the usual places too.
mise_bin="$(command -v mise || true)"
if [ -z "$mise_bin" ]; then
  for candidate in "$HOME/.local/bin/mise" /opt/homebrew/bin/mise /usr/local/bin/mise; do
    if [ -x "$candidate" ]; then
      mise_bin="$candidate"
      # bootstrap.sh looks for mise on PATH and skips `mise install` without it.
      # Append, so that nothing already on PATH is hidden.
      PATH="$PATH:$(dirname "$candidate")"
      break
    fi
  done
fi
if [ -z "$mise_bin" ]; then
  echo "mise was not found, so bootstrap could not run. See https://mise.jdx.dev/getting-started.html" >&2
  exit 1
fi

# Run the bootstrap of that workspace, not the one next to this script:
# a worktree can be on a branch whose bootstrap differs.
# Output goes to stderr, so stdout stays empty for callers that read it.
(cd "$workspace_dir" && "$mise_bin" run bootstrap) >&2

# bootstrap skips steps whose tools are missing and can still exit 0, so check the result.
if [ ! -f "$package_config" ]; then
  echo "bootstrap finished, but $package_config is still missing." >&2
  exit 1
fi
