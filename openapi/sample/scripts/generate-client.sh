#!/usr/bin/env bash
#
# OpenAPI の仕様書から Dart Dio の API クライアントを生成する。
#
# API 名はこのスクリプトがある openapi/<api_name> のディレクトリ名から決まり、
# packages/api/<api_name> に internal_api_<api_name> パッケージを生成する。
#
# Usage: openapi/<api_name>/scripts/generate-client.sh

set -euo pipefail

api_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
root_dir="$(cd "$api_dir/../.." && pwd)"
api_name="$(basename "$api_dir")"
output_dir="$root_dir/packages/api/$api_name"

cd "$root_dir"

if ! generator_jar="$(mise which openapi-generator 2>/dev/null)"; then
  echo "error: openapi-generator が見つかりません。mise install を実行してください。" >&2
  exit 1
fi

# 仕様書から消えた API やモデルのファイルを残さないため、生成先を作り直す。
rm -rf "$output_dir"

mise exec -- java -jar "$generator_jar" generate \
  --generator-name dart-dio \
  --input-spec "$api_dir/openapi.yaml" \
  --config "$api_dir/configs/dart-dio.yaml" \
  --additional-properties "pubName=internal_api_$api_name" \
  --template-dir "$api_dir/templates" \
  --output "$output_dir"

mise exec -- dart format "$output_dir"
