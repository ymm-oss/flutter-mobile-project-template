#!/usr/bin/env bash
#
# .agents/skills/ を共有スキルの実体とし、Claude Code 用の
# .claude/skills を ../.agents/skills への相対 symlink にする。
#
# Cursor と GitHub Copilot は .agents/skills/ を直接読むため、
# それらの配置先には symlink を作らない。
#
# Usage:
#   scripts/sync-ai-skills.sh           # .claude/skills を復元する
#   scripts/sync-ai-skills.sh --check   # 不一致なら終了コード 1（変更しない）
#
# 環境変数:
#   AI_SKILLS_LINK_MODE=auto|symlink|copy
#     auto（既定）: symlink を作れるときは symlink、作れないときはディレクトリをコピーする
#     symlink: symlink を必須にする。作れなければ失敗する
#     copy: 実体のコピーで復元する。コピーはコミットしない

set -euo pipefail

mode="apply"
case "${1:-}" in
  "") ;;
  --check) mode="check" ;;
  *)
    echo "usage: scripts/sync-ai-skills.sh [--check]" >&2
    exit 2
    ;;
esac

# Git Bash の ln -s は設定によって symlink の代わりにコピーを作るため、
# symlink を作れないときは失敗させる。
case "${MSYS:-}" in
  *winsymlinks*) ;;
  *) export MSYS="${MSYS:+$MSYS }winsymlinks:nativestrict" ;;
esac

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
agents_dir="$root_dir/.agents/skills"
claude_link="$root_dir/.claude/skills"
claude_path=".claude/skills"
expected_target="../.agents/skills"
copy_marker=".ai-skills-copy"
link_mode="${AI_SKILLS_LINK_MODE:-auto}"
failed=0

fail() {
  echo "error: $*" >&2
  failed=1
}

can_symlink() {
  local tmp
  local ok=1
  tmp="$(mktemp -d)"
  mkdir "$tmp/target"
  if ln -s "target" "$tmp/link" 2>/dev/null && [[ -L "$tmp/link" ]]; then
    ok=0
  fi
  rm -rf "$tmp"
  return "$ok"
}

resolve_link_mode() {
  case "$link_mode" in
    symlink)
      if ! can_symlink; then
        echo "error: symlink を作成できません。OS の symlink 権限と git config core.symlinks を確認してください。" >&2
        exit 1
      fi
      printf '%s\n' symlink
      ;;
    copy)
      printf '%s\n' copy
      ;;
    auto)
      if can_symlink; then
        printf '%s\n' symlink
      else
        printf '%s\n' copy
      fi
      ;;
    *)
      echo "error: AI_SKILLS_LINK_MODE は auto, symlink, copy のいずれかです。" >&2
      exit 2
      ;;
  esac
}

frontmatter_value() {
  local file="$1"
  local key="$2"
  # CRLF で checkout された SKILL.md も読めるように、行末の \r を除く。
  # 複数行の値（> や |）は 1 行で書くルールに反するため、値なしとして扱う。
  awk -v key="$key" '
    { sub(/\r$/, "") }
    NR == 1 && $0 != "---" { exit 1 }
    NR == 1 { in_fm = 1; next }
    in_fm && $0 == "---" { exit 1 }
    in_fm && index($0, key ":") == 1 {
      line = $0
      sub("^" key ":[[:space:]]*", "", line)
      sub(/[[:space:]]+$/, "", line)
      if (line ~ /^[>|][-+]?$/) exit 1
      if (line ~ /^".*"$/ || line ~ /^'\''.*'\''$/) {
        line = substr(line, 2, length(line) - 2)
      }
      if (line == "") exit 1
      print line
      exit 0
    }
  ' "$file"
}

is_skill_name() {
  local name="$1"
  case "$name" in
    *[!a-z0-9-]*) return 1 ;;
    -* | *- | *--*) return 1 ;;
    "") return 1 ;;
  esac
  case "$name" in
    [a-z0-9]*) return 0 ;;
    *) return 1 ;;
  esac
}

is_official_skill() {
  case "$1" in
    dart-* | flutter-*) return 0 ;;
    *) return 1 ;;
  esac
}

list_names() {
  local dir="$1"
  local path name
  if [[ ! -d "$dir" ]]; then
    return 0
  fi
  for path in "$dir"/*; do
    [[ -e "$path" || -L "$path" ]] || continue
    name="$(basename "$path")"
    case "$name" in
      .*) continue ;;
    esac
    printf '%s\n' "$name"
  done
}

validate_skill() {
  local name="$1"
  local dir="$agents_dir/$name"
  local skill_file value chars

  if ! is_skill_name "$name"; then
    fail "$dir のディレクトリ名は小文字・数字・ハイフンだけにしてください。"
    return 0
  fi
  if [[ -L "$dir" || ! -d "$dir" ]]; then
    fail "$dir は実ディレクトリである必要があります。"
    return 0
  fi
  skill_file="$dir/SKILL.md"
  if [[ ! -f "$skill_file" || -L "$skill_file" ]]; then
    fail "$skill_file がありません。"
    return 0
  fi

  value="$(frontmatter_value "$skill_file" name)" || value=""
  if [[ "$value" != "$name" ]]; then
    fail "$skill_file の name はディレクトリ名 $name と一致させてください。"
  fi
  # dart run skills@ が管理する公式スキルは上流の書式のまま取り込むため、
  # description の書き方は検査しない。
  if is_official_skill "$name"; then
    return 0
  fi
  value="$(frontmatter_value "$skill_file" description)" || value=""
  if [[ -z "$value" ]]; then
    fail "$skill_file の description を 1 行で書いてください。"
  else
    # ロケールに依存しないよう、UTF-8 の継続バイトを除いたバイト数を文字数とする。
    chars="$(printf '%s' "$value" | LC_ALL=C tr -d '\200-\277' | wc -c | tr -d '[:space:]')"
    if [[ "$chars" -gt 1024 ]]; then
      fail "$skill_file の description は 1024 文字以内にしてください。"
    fi
  fi
}

validate_agents_skills() {
  local name
  if [[ ! -d "$agents_dir" ]]; then
    fail "$agents_dir がありません。"
    return 0
  fi
  while IFS= read -r name; do
    [[ -n "$name" ]] || continue
    validate_skill "$name"
  done < <(list_names "$agents_dir")
}

check_worktree_link() {
  local current
  if [[ ! -L "$claude_link" ]]; then
    fail "$claude_path は $expected_target への symlink である必要があります。"
    return 0
  fi
  current="$(readlink "$claude_link")"
  if [[ "$current" != "$expected_target" ]]; then
    fail "$claude_path のリンク先は $expected_target である必要があります (現在: $current)。"
    return 0
  fi
  if [[ ! -d "$claude_link" ]]; then
    fail "$claude_path のリンク先が存在しません。"
  fi
}

check_git_link() {
  local entries mode oid path recorded
  if ! entries="$(git -C "$root_dir" ls-files -s -- "$claude_path")"; then
    fail "Git の作業ツリーで実行してください。"
    return 0
  fi
  if [[ -z "$entries" ]]; then
    fail "$claude_path が Git に登録されていません。scripts/sync-ai-skills.sh を実行してコミットしてください。"
    return 0
  fi
  if [[ "$(printf '%s\n' "$entries" | wc -l | tr -d '[:space:]')" -ne 1 ]]; then
    fail "$claude_path が Git 上でディレクトリとして登録されています。symlink 1 つにしてください。"
    return 0
  fi
  mode="$(printf '%s\n' "$entries" | awk '{print $1}')"
  oid="$(printf '%s\n' "$entries" | awk '{print $2}')"
  path="$(printf '%s\n' "$entries" | cut -f 2)"
  if [[ "$path" != "$claude_path" || "$mode" != "120000" ]]; then
    fail "$claude_path は Git 上で symlink (mode 120000) である必要があります (現在: $mode $path)。"
    return 0
  fi
  recorded="$(git -C "$root_dir" cat-file -p "$oid")"
  if [[ "$recorded" != "$expected_target" ]]; then
    fail "$claude_path の Git 上のリンク先は $expected_target である必要があります (現在: $recorded)。"
  fi
}

remove_claude_link() {
  local physical agents_physical
  # symlink とパス文字列のファイル（core.symlinks=false の checkout）は、リンク先をたどらずに消す。
  if [[ -L "$claude_link" || -f "$claude_link" ]]; then
    rm -f "$claude_link"
    return 0
  fi
  if [[ ! -e "$claude_link" ]]; then
    return 0
  fi
  physical="$(cd "$claude_link" && pwd -P)"
  agents_physical="$(cd "$agents_dir" && pwd -P)"
  if [[ "$physical" == "$agents_physical" ]]; then
    fail "$claude_path が .agents/skills と同じ実体を指しています。親ディレクトリの symlink を確認してください。"
    return 1
  fi
  # 消してよい実ディレクトリは、このスクリプトが作ったコピーと空のディレクトリだけにする。
  if [[ -f "$claude_link/$copy_marker" ]]; then
    rm -rf "$claude_link"
  elif ! rmdir "$claude_link" 2>/dev/null; then
    fail "$claude_path は実ディレクトリです。スキルは .agents/skills/ に移してから、ディレクトリを削除して再実行してください。"
    return 1
  fi
}

apply_link() {
  local actual_mode="$1"

  if [[ "$actual_mode" == "symlink" && -L "$claude_link" ]]; then
    if [[ "$(readlink "$claude_link")" == "$expected_target" ]]; then
      return 0
    fi
  fi

  mkdir -p "$(dirname "$claude_link")"
  remove_claude_link || return 0
  if [[ "$actual_mode" == "symlink" ]]; then
    ln -s "$expected_target" "$claude_link"
    echo "linked $claude_path -> $expected_target"
  else
    cp -R "$agents_dir" "$claude_link"
    : >"$claude_link/$copy_marker"
    echo "copied .agents/skills to $claude_path"
  fi
}

shopt -s nullglob

validate_agents_skills
if [[ "$failed" -ne 0 ]]; then
  exit 1
fi

if [[ "$mode" == "check" ]]; then
  if ! can_symlink; then
    echo "error: この環境では symlink を検証できません。CI は symlink が使える環境で --check します。" >&2
    exit 1
  fi
  check_worktree_link
  check_git_link
  if [[ "$failed" -ne 0 ]]; then
    exit 1
  fi
  echo "OK: $claude_path is a symlink to $expected_target."
  exit 0
fi

actual_mode="$(resolve_link_mode)"
apply_link "$actual_mode"
if [[ "$failed" -ne 0 ]]; then
  exit 1
fi
if [[ "$actual_mode" == "copy" ]]; then
  if [[ "$link_mode" == "auto" ]]; then
    echo "warning: symlink を作成できないため、$claude_path をコピーで復元しました。" >&2
  fi
  echo "warning: コピーは編集もコミットもしないでください。スキルを変更したら、このスクリプトを再実行してください。" >&2
  echo "warning: Windows で symlink を使うには、開発者モードを有効にし、このリポジトリで git config core.symlinks true を実行してから、このスクリプトを再実行してください。" >&2
fi
echo "OK: synced $claude_path ($actual_mode)."
