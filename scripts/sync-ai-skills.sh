#!/usr/bin/env bash
#
# .agents/skills/ を共有スキルの実体とし、Claude Code 用の
# .claude/skills/<name> を相対 symlink で同期する。
#
# Cursor と GitHub Copilot は .agents/skills/ を直接読むため、
# それらの配置先には symlink を作らない。
#
# Usage:
#   scripts/sync-ai-skills.sh           # 同期する
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

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
agents_dir="$root_dir/.agents/skills"
claude_dir="$root_dir/.claude/skills"
link_mode="${AI_SKILLS_LINK_MODE:-auto}"
failed=0

fail() {
  echo "error: $*" >&2
  failed=1
}

can_symlink() {
  local tmp
  tmp="$(mktemp -d)"
  if ln -s "target" "$tmp/link" 2>/dev/null; then
    rm -rf "$tmp"
    return 0
  fi
  rm -rf "$tmp"
  return 1
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
  awk -v key="$key" '
    NR == 1 && $0 != "---" { exit 1 }
    NR == 1 { in_fm = 1; next }
    in_fm && $0 == "---" { exit 1 }
    in_fm && index($0, key ":") == 1 {
      line = $0
      sub("^" key ":[[:space:]]*", "", line)
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

expected_target() {
  printf '%s\n' "../../.agents/skills/$1"
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
  local skill_file value

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
  value="$(frontmatter_value "$skill_file" description)" || value=""
  if [[ -z "$value" ]]; then
    fail "$skill_file の description を 1 行で書いてください。"
  else
    chars="$(printf '%s' "$value" | wc -m | tr -d '[:space:]')"
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

skill_known() {
  local needle="$1"
  local name
  while IFS= read -r name; do
    [[ "$name" == "$needle" ]] && return 0
  done < <(list_names "$agents_dir")
  return 1
}

check_git_symlink() {
  local name="$1"
  local path=".claude/skills/$name"
  local expected line mode oid recorded
  expected="$(expected_target "$name")"
  line="$(git -C "$root_dir" ls-files -s -- "$path")"
  if [[ -z "$line" ]]; then
    fail "$path が Git に登録されていません。scripts/sync-ai-skills.sh を実行してコミットしてください。"
    return 0
  fi
  mode="$(printf '%s\n' "$line" | awk '{print $1}')"
  oid="$(printf '%s\n' "$line" | awk '{print $2}')"
  if [[ "$mode" != "120000" ]]; then
    fail "$path は Git 上で symlink (mode 120000) である必要があります (現在: $mode)。"
    return 0
  fi
  recorded="$(git -C "$root_dir" cat-file -p "$oid")"
  if [[ "$recorded" != "$expected" ]]; then
    fail "$path の Git 上のリンク先は $expected である必要があります (現在: $recorded)。"
  fi
}

check_worktree_link() {
  local name="$1"
  local path="$claude_dir/$name"
  local expected current
  expected="$(expected_target "$name")"
  if [[ ! -L "$path" ]]; then
    fail "$path は $expected への symlink である必要があります。"
    return 0
  fi
  current="$(readlink "$path")"
  if [[ "$current" != "$expected" ]]; then
    fail "$path のリンク先は $expected である必要があります (現在: $current)。"
    return 0
  fi
  if [[ ! -e "$path" ]]; then
    fail "$path のリンク先が存在しません。"
  fi
}

check_links() {
  local name
  while IFS= read -r name; do
    [[ -n "$name" ]] || continue
    check_worktree_link "$name"
    check_git_symlink "$name"
  done < <(list_names "$agents_dir")

  while IFS= read -r name; do
    [[ -n "$name" ]] || continue
    if ! skill_known "$name"; then
      fail ".claude/skills/$name は .agents/skills/ に対応するスキルがありません。"
    fi
  done < <(list_names "$claude_dir")
}

remove_claude_entry() {
  local path="$1"
  if [[ -L "$path" || -f "$path" ]]; then
    rm -f "$path"
  elif [[ -d "$path" ]]; then
    rm -rf "$path"
  else
    rm -rf "$path"
  fi
}

apply_one() {
  local name="$1"
  local actual_mode="$2"
  local path="$claude_dir/$name"
  local source="$agents_dir/$name"
  local expected current

  expected="$(expected_target "$name")"
  mkdir -p "$claude_dir"

  if [[ "$actual_mode" == "symlink" && -L "$path" ]]; then
    current="$(readlink "$path")"
    if [[ "$current" == "$expected" && -e "$path" ]]; then
      return 0
    fi
  fi

  remove_claude_entry "$path"
  if [[ "$actual_mode" == "symlink" ]]; then
    ln -s "$expected" "$path"
    echo "linked .claude/skills/$name -> $expected"
  else
    cp -R "$source" "$path"
    echo "warning: .claude/skills/$name をコピーしました。symlink を作れない環境の一時復元です。編集もコミットもしないでください。" >&2
  fi
}

apply_links() {
  local actual_mode="$1"
  local name
  while IFS= read -r name; do
    [[ -n "$name" ]] || continue
    apply_one "$name" "$actual_mode"
  done < <(list_names "$agents_dir")

  while IFS= read -r name; do
    [[ -n "$name" ]] || continue
    if ! skill_known "$name"; then
      remove_claude_entry "$claude_dir/$name"
      echo "removed stale .claude/skills/$name"
    fi
  done < <(list_names "$claude_dir")
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
  check_links
  if [[ "$failed" -ne 0 ]]; then
    exit 1
  fi
  echo "OK: AI skill symlinks are consistent."
  exit 0
fi

actual_mode="$(resolve_link_mode)"
if [[ "$actual_mode" == "copy" ]]; then
  echo "warning: symlink を作成できないため、.claude/skills/ をコピーで復元します。この結果はコミットしないでください。" >&2
  echo "warning: Windows では開発者モードを有効にし、git config --global core.symlinks true にしたうえで clone し直すと symlink を使えます。" >&2
fi
apply_links "$actual_mode"
echo "OK: synced .claude/skills ($actual_mode)."
