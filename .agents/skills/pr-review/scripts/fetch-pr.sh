#!/usr/bin/env bash
#
# PR のレビューに必要な情報を 1 つの JSON で出力する。
#
# PR の情報に加えて、次を返す。
#   reviewLevel: PR 本文で選ばれたレビューレベル（Lv1〜Lv3）。選ばれていなければ null
#   issues: PR が close する Issue の本文とコメント
#   checks: CI のチェックの結果
#   diffRanges: コメントを付けられる行の範囲（diff-ranges.sh の出力）
#   threads: PR にすでに付いているレビューのスレッド
#   reviews: PR にすでに付いている、本文のある総評
#
# Usage: fetch-pr.sh <PR の番号>

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "usage: fetch-pr.sh <PR の番号>" >&2
  exit 2
fi

number="$1"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pr=$(gh pr view "$number" --json number,title,body,state,url,author,baseRefName,headRefOid,closingIssuesReferences,files,reviews)

issues=$(
  jq -r '.closingIssuesReferences[].url' <<<"$pr" |
    while read -r url; do
      gh issue view "$url" --json number,title,body,url,comments \
        --jq '{number, title, body, url, comments: [.comments[] | {author: .author.login, body}]}'
    done |
    jq -s '.'
)

# チェックが実行中のときは終了コード 8、チェックがないときは 1 になるため、出力だけを見る
checks=$(gh pr checks "$number" --json name,state,bucket,workflow 2>/dev/null || true)
if ! jq -e 'type == "array"' >/dev/null 2>&1 <<<"$checks"; then
  checks='[]'
fi

diff_ranges=$("$script_dir/diff-ranges.sh" "$number")

threads=$(
  gh api graphql --paginate --slurp \
    -F owner='{owner}' -F name='{repo}' -F number="$number" -f query='
      query($owner: String!, $name: String!, $number: Int!, $endCursor: String) {
        repository(owner: $owner, name: $name) {
          pullRequest(number: $number) {
            reviewThreads(first: 100, after: $endCursor) {
              pageInfo { hasNextPage endCursor }
              nodes {
                isResolved
                isOutdated
                path
                line
                originalLine
                comments(first: 50) {
                  nodes { author { login } body url }
                }
              }
            }
          }
        }
      }' |
    jq '[
      .[].data.repository.pullRequest.reviewThreads.nodes[]
      | .comments = [.comments.nodes[] | {author: .author.login, body, url}]
    ]'
)

printf '%s\n' "$pr" "$issues" "$checks" "$diff_ranges" "$threads" |
  jq -s '
    .[0] as $pr | .[1] as $issues | .[2] as $checks | .[3] as $diffRanges | .[4] as $threads |
    $pr
    | del(.closingIssuesReferences)
    | .author = .author.login
    | .reviewLevel = ([.body | match("- \\[[xX]\\] (Lv[1-3])"; "g") | .captures[0].string] | first)
    | .issues = $issues
    | .checks = $checks
    | .diffRanges = $diffRanges
    | .threads = $threads
    | .reviews = [.reviews[] | select(.body != "") | {author: .author.login, state, body}]
  '
