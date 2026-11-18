#!/usr/bin/env bash
#
# PR の差分で、レビューコメントを付けられる行の範囲を JSON で出力する。
#
# ハンクごとに、RIGHT（変更後）と LEFT（変更前）の行の範囲を返す。
# 出力の例: {"lib/a.dart": {"RIGHT": [[10, 24]], "LEFT": [[10, 20]]}}
#
# Usage: diff-ranges.sh <PR の番号>

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "usage: diff-ranges.sh <PR の番号>" >&2
  exit 2
fi

gh pr diff "$1" --color=never |
  awk '
    function strip(path) {
      sub(/\t$/, "", path)
      sub(/^"/, "", path)
      sub(/"$/, "", path)
      sub(/^[ab]\//, "", path)
      return path
    }
    # ハンクの中の行は、行頭が "--- " でもファイルの見出しとして扱わない
    old_left > 0 || new_left > 0 {
      c = substr($0, 1, 1)
      if (c == "-") old_left--
      else if (c == "+") new_left--
      else if (c == " ") { old_left--; new_left-- }
      next
    }
    /^diff --git / { path = ""; next }
    /^--- / { p = substr($0, 5); if (p != "/dev/null") path = strip(p); next }
    /^\+\+\+ / { p = substr($0, 5); if (p != "/dev/null") path = strip(p); next }
    /^@@ / {
      split($2, o, ","); split($3, n, ",")
      old_start = substr(o[1], 2) + 0; old_count = (2 in o) ? o[2] + 0 : 1
      new_start = substr(n[1], 2) + 0; new_count = (2 in n) ? n[2] + 0 : 1
      if (new_count > 0) printf "%s\tRIGHT\t%d\t%d\n", path, new_start, new_start + new_count - 1
      if (old_count > 0) printf "%s\tLEFT\t%d\t%d\n", path, old_start, old_start + old_count - 1
      old_left = old_count; new_left = new_count
      next
    }
  ' |
  jq -Rn '
    reduce (inputs | split("\t")) as [$path, $side, $start, $end] ({};
      .[$path][$side] += [[($start | tonumber), ($end | tonumber)]])
  '
