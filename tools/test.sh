#!/usr/bin/env bash
#
# Run the tests of all packages, or only the given test files or directories.
#
# Usage: tools/test.sh [path...]
#   path: a test file, a directory of tests, or a package directory.
#         Relative paths are resolved from the repository root.

set -euo pipefail

# With CDPATH set, cd prints the directory it moved to, which breaks $(cd ... && pwd).
unset CDPATH

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root_dir"

if [ $# -eq 0 ]; then
  exec dart run melos run test --no-select
fi

for target in "$@"; do
  if [ ! -e "$target" ]; then
    echo "Not found: $target (paths are resolved from the repository root)" >&2
    exit 1
  fi

  if [ -d "$target" ]; then
    target_path="$(cd "$target" && pwd)"
  else
    target_path="$(cd "$(dirname "$target")" && pwd)/$(basename "$target")"
  fi

  # The package is the nearest directory with a pubspec.yaml.
  package_dir="$target_path"
  [ -d "$package_dir" ] || package_dir="$(dirname "$package_dir")"
  while [ ! -f "$package_dir/pubspec.yaml" ] && [ "$package_dir" != "/" ]; do
    package_dir="$(dirname "$package_dir")"
  done
  # -ef compares the directories themselves, so another spelling of the root is caught too.
  if [ "$package_dir" -ef "$root_dir" ] || [ ! -f "$package_dir/pubspec.yaml" ]; then
    echo "Not inside a package: $target (pass a path under apps/, packages/ or samples/, or no path to test all packages)" >&2
    exit 1
  fi

  # Empty when the target is the package directory itself: run all its tests.
  test_path="${target_path#"$package_dir"}"
  test_path="${test_path#/}"

  # Anything else makes the test runner fail with an unclear error, or run more than asked.
  case "$test_path" in
    '' | test | test/*_test.dart) ;;
    *)
      if [ ! -d "$target_path" ] || [ "${test_path#test/}" = "$test_path" ]; then
        echo "Not a test: $target (pass a *_test.dart file, a directory under test/ or a package directory)" >&2
        exit 1
      fi
      ;;
  esac

  # Let melos choose the packages and the runner, so its packageFilters stay the only source.
  # The test script is made of steps, which ignore --scope, so call each step.
  # Packages excluded by the filters (for example catalog) run nothing, as in mise run check.
  package_name="$(sed -n 's/^name: *//p' "$package_dir/pubspec.yaml")"
  for script in test:flutter test:dart; do
    dart run melos run "$script" --no-select --scope="$package_name" ${test_path:+-- "$test_path"}
  done
done
