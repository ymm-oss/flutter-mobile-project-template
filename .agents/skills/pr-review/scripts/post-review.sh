#!/usr/bin/env bash
#
# レビューの JSON を確かめてから、1 つのレビューとして PR に投稿する。
#
# 次のいずれかに当てはまる場合は、投稿せずに理由を出力して終了コード 1 で終了する。
#   - event が COMMENT でも REQUEST_CHANGES でもない
#   - commit_id が PR の現在の先端と違う（レビューのあとに push された）
#   - コメントの行が、差分のコメントを付けられる範囲に入っていない
#
# Usage: post-review.sh <PR の番号> <JSON ファイル> [--dry-run]
#   --dry-run: 確かめるだけで、投稿しない

set -euo pipefail

if [ $# -lt 2 ] || [ $# -gt 3 ] || { [ $# -eq 3 ] && [ "$3" != "--dry-run" ]; }; then
  echo "usage: post-review.sh <PR の番号> <JSON ファイル> [--dry-run]" >&2
  exit 2
fi

number="$1"
review_file="$2"
dry_run="${3:-}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! jq -e 'type == "object"' "$review_file" >/dev/null; then
  echo "$review_file を JSON のオブジェクトとして読めません。" >&2
  exit 1
fi

event=$(jq -r '.event // ""' "$review_file")
if [ "$event" != "COMMENT" ] && [ "$event" != "REQUEST_CHANGES" ]; then
  echo "event が \"$event\" です。COMMENT か、ユーザーが指示した場合だけ REQUEST_CHANGES にしてください。" >&2
  exit 1
fi

commit_id=$(jq -r '.commit_id // ""' "$review_file")
head_ref_oid=$(gh pr view "$number" --json headRefOid --jq '.headRefOid')
if [ -z "$commit_id" ]; then
  echo "commit_id がありません。レビューした時点の headRefOid を指定してください。" >&2
  exit 1
fi
if [ "$commit_id" != "$head_ref_oid" ]; then
  echo "commit_id（${commit_id}）が、PR の現在の先端（${head_ref_oid}）と違います。レビューのあとに push されたため、差分を見直してください。" >&2
  exit 1
fi

diff_ranges=$("$script_dir/diff-ranges.sh" "$number")

errors=$(
  printf '%s\n' "$diff_ranges" | jq -r -s '
    def fmt: map("\(.[0])-\(.[1])") | join(", ");
    def within($rs; $from; $to): any($rs[]; .[0] <= $from and $to <= .[1]);
    .[0] as $ranges |
    (.[1].comments // []) | to_entries[] | .key as $i | .value as $c |
    ($c.side // "RIGHT") as $side |
    ($ranges[$c.path] // {}) as $file |
    ($file[$side] // []) as $rs |
    "comments[\($i)] (\($c.path):\($c.line))" as $at |
    if ($c.body // "") == "" then "\($at): body が空です。"
    elif $file == {} then "\($at): \($c.path) は差分にないか、コメントできる行がありません。"
    elif ($side != "RIGHT" and $side != "LEFT") then "\($at): side は RIGHT か LEFT にしてください。"
    elif ($c.line | type) != "number" then "\($at): line を数値で指定してください。"
    elif $c.start_line == null then
      if within($rs; $c.line; $c.line) then empty
      else "\($at): \($side) の \($c.line) 行目は差分の範囲外です。コメントできる範囲: \($rs | fmt)"
      end
    elif ($c.start_side // "") != $side then "\($at): start_side を side と同じ \($side) にしてください。"
    elif $c.start_line >= $c.line then "\($at): start_line を line より小さくしてください。"
    elif within($rs; $c.start_line; $c.line) then empty
    else "\($at): \($side) の \($c.start_line)-\($c.line) 行目は 1 つのハンクに収まっていません。コメントできる範囲: \($rs | fmt)"
    end
  ' - "$review_file"
)

if [ -n "$errors" ]; then
  echo "次のコメントを直してください。" >&2
  echo "$errors" >&2
  exit 1
fi

if [ "$dry_run" = "--dry-run" ]; then
  echo "問題はありません。--dry-run のため投稿していません。"
  exit 0
fi

gh api --method POST "repos/{owner}/{repo}/pulls/$number/reviews" --input "$review_file" --jq '.html_url'
