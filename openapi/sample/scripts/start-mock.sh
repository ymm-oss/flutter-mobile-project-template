#!/usr/bin/env bash
#
# OpenAPI の仕様書からローカルのモックサーバーを起動する。
#
# openapi/<api_name>/openapi.yaml を Prism で読み込み、http://127.0.0.1:4010 で待ち受ける。
# 引数はそのまま Prism に渡す。
#
# Usage: openapi/<api_name>/scripts/start-mock.sh [prism mock のオプション]

set -euo pipefail

api_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
root_dir="$(cd "$api_dir/../.." && pwd)"

cd "$root_dir"

exec bun --bun run prism mock "$api_dir/openapi.yaml" --port 4010 "$@"
