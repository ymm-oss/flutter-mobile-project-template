#!/usr/bin/env bash
#
# リリースビルドの Dart AOT スナップショットにデバッグ機能が含まれていないことを確認する。
#
# `flutter build apk --analyze-size` が内部で実行するものと同じ `flutter assemble` の
# ターゲットを直接実行し、出力されるスナップショットのサイズプロファイルを検査する。
# Gradle や JDK を必要としないため、ローカルでも CI でも高速に実行できる。
#
# Usage: scripts/check-debug-tree-shaking.sh [flavor]
#   flavor: dev | stg | prd (default: prd)

set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
app_dir="$root_dir/apps/app"
flavor="${1:-prd}"

# リリースビルドに含まれてはいけない Dart ライブラリの URI プレフィックス
forbidden_libraries=(
  "package:internal_debug/"
  "package:flutter_app/debug/debug_features_impl.dart"
  "package:accessibility_tools/"
  "package:shake_gesture/"
  "package:talker_flutter/"
  "package:talker_riverpod_logger/"
)

# Flutter が生成する Dart プラグインレジストラント（dart_plugin_registrant.dart）は
# dev_dependencies のプラグインもリリースビルドで登録するため、プラグインの登録処理だけは残る。
# デバッグ機能の実装ではないため、警告に留める。
known_plugin_registrant_libraries=(
  "package:shake_gesture_android/"
  "package:shake_gesture_ios/"
  "package:shake_gesture_platform_interface/"
)

work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

# 出力先ディレクトリはビルド設定の一部となるため、毎回新しいディレクトリを指定することで
# キャッシュを使わずにスナップショットを生成する。
code_size_dir="$work_dir/code-size"
mkdir -p "$code_size_dir"

# flutter assemble は Gradle などから base64 エンコード済みの dart-define を受け取る前提のため、
# flavor ファイルの各値をエンコードして渡す。
dart_define_args=()
while IFS= read -r define; do
  dart_define_args+=("--dart-define=$(printf '%s' "$define" | base64)")
done < <(jq -r 'to_entries[] | "\(.key)=\(.value)"' "$app_dir/flavor/$flavor.json")

# Android 向けの AOT コンパイルに必要なアーティファクト（gen_snapshot）を取得する
flutter precache --android

echo "Building release AOT snapshot (flavor: $flavor)..."
(
  cd "$app_dir"
  flutter assemble \
    "${dart_define_args[@]}" \
    -dTargetPlatform=android-arm64 \
    -dBuildMode=release \
    -dTargetFile=lib/main.dart \
    -dTrackWidgetCreation=false \
    -dCodeSizeDirectory="$code_size_dir" \
    --output="$work_dir/out" \
    android_aot_bundle_release_android-arm64
)

snapshot_profile="$code_size_dir/snapshot.arm64-v8a.json"
if [ ! -f "$snapshot_profile" ]; then
  echo "error: snapshot profile was not generated: $snapshot_profile" >&2
  exit 1
fi

# JSON 内の "/" は "\/" とエスケープされている場合があるため元に戻してから検査する
libraries="$(grep -oE 'package:[^"]+' "$snapshot_profile" | sed 's#\\/#/#g' | sort -u)"

found=0
for library in "${forbidden_libraries[@]}"; do
  matches="$(grep -F "$library" <<<"$libraries" || true)"
  if [ -n "$matches" ]; then
    echo "error: '$library' is included in the release build:" >&2
    sed 's/^/  /' <<<"$matches" >&2
    found=1
  fi
done

for library in "${known_plugin_registrant_libraries[@]}"; do
  matches="$(grep -F "$library" <<<"$libraries" || true)"
  if [ -n "$matches" ]; then
    echo "warning: '$library' is included only for plugin registration (Flutter limitation)."
  fi
done

if [ "$found" -ne 0 ]; then
  echo "Debug features are not tree-shaken. Make sure they are referenced only from code guarded by kDebugMode." >&2
  exit 1
fi

echo "OK: debug features are not included in the release build."
