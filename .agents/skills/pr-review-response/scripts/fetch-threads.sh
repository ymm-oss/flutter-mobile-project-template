#!/usr/bin/env bash
#
# PR に付いたレビューのうち、対応が必要なものを JSON で出力する。
#
#   threads: 未解決で、最後のコメントが PR の作成者のものでないスレッド。
#            replyTo は、返信に使うスレッドの最初のコメントの ID
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
                  nodes { databaseId author { login } body url }
                }
              }
            }
          }
        }
      }' |
    jq '[.[].data.repository.pullRequest.reviewThreads.nodes[]]'
)

printf '%s\n' "$pr" "$threads" |
  jq -s '
    .[0] as $pr | .[1] as $threads | ($pr.author.login) as $author |
    {
      number: $pr.number,
      title: $pr.title,
      url: $pr.url,
      author: $author,
      threads: [
        $threads[]
        | select((.isResolved | not) and .comments.nodes[-1].author.login != $author)
        | {
            path, line, originalLine, isOutdated,
            replyTo: .comments.nodes[0].databaseId,
            comments: [.comments.nodes[] | {author: .author.login, body, url}]
          }
      ],
      reviews: [
        $pr.reviews[]
        | select(.author.login != $author and .body != "")
        | {author: .author.login, state, body}
      ]
    }
  '
