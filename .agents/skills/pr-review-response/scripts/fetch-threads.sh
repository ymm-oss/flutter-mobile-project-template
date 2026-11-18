#!/usr/bin/env bash
#
# PR に付いたレビューのうち、対応が必要なものを JSON で出力する。
#
#   threads: 未解決で、最後のコメントが PR の作成者のものでないスレッド。
#            replyTo は、返信に使うスレッドの最初のコメントの ID
#   botThreads: threads と同じ条件で、CI（reviewdog）が付けたスレッド。ほかの bot のスレッドは threads に入れる。
#               check は、コメントの先頭の [cspell] などから取り出した検査の名前
#   checks: CI のチェックの結果
#   reviews: PR の作成者以外が書いた、本文のある総評
#
# Usage: fetch-threads.sh [PR の番号]
#   番号を省くと、現在のブランチの PR を使う。

set -euo pipefail

if [ $# -gt 1 ]; then
  echo "usage: fetch-threads.sh [PR の番号]" >&2
  exit 2
fi

pr=$(gh pr view ${1:+"$1"} --json number,title,url,author,reviews)
number=$(jq -r '.number' <<<"$pr")

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
                  nodes { databaseId author { __typename login } body url }
                }
                lastComment: comments(last: 1) {
                  nodes { author { login } }
                }
              }
            }
          }
        }
      }' |
    jq '[.[].data.repository.pullRequest.reviewThreads.nodes[]]'
)

# チェックが実行中のときは終了コード 8、チェックがないときは 1 になるため、出力だけを見る
checks=$(gh pr checks "$number" --json name,state,bucket,workflow 2>/dev/null || true)
if ! jq -e 'type == "array"' >/dev/null 2>&1 <<<"$checks"; then
  checks='[]'
fi

printf '%s\n' "$pr" "$threads" "$checks" |
  jq -s '
    def reviewdog: .comments.nodes[0] | .author.__typename == "Bot" and (.body | test("reported by \\[reviewdog\\]"));
    .[0] as $pr | .[1] as $threads | .[2] as $checks | ($pr.author.login) as $author |
    [
      $threads[]
      | select((.isResolved | not) and .lastComment.nodes[0].author.login != $author)
    ] as $open |
    {
      number: $pr.number,
      title: $pr.title,
      url: $pr.url,
      author: $author,
      threads: [
        $open[]
        | select(reviewdog | not)
        | {
            path, line, originalLine, isOutdated,
            replyTo: .comments.nodes[0].databaseId,
            comments: [.comments.nodes[] | {author: .author.login, body, url}]
          }
      ],
      botThreads: [
        $open[]
        | select(reviewdog)
        | .comments.nodes[0] as $first
        | {
            path, line, isOutdated,
            check: ($first.body | capture("^\\*\\*\\[(?<name>[^\\]]+)\\]\\*\\*").name // null),
            url: $first.url
          }
      ],
      checks: $checks,
      reviews: [
        $pr.reviews[]
        | select(.author.login != $author and .body != "")
        | {author: .author.login, state, body}
      ]
    }
  '
