# AI スキルの配置

Cursor、GitHub Copilot、Claude Code で共有するスキルの実体は `.agents/skills/` の一箇所に置く。ここが共有スキルの単一の実体である。ホームディレクトリの個人設定ではなく、リポジトリにコミットし、clone したメンバーが同じスキルを使えるようにする。

公式スキルの取り込みと更新は [#700] で行う。このドキュメントは配置と、ツールごとの読み取り方を決める。

## ツールごとの読み取り

| ツール         | 読み取る場所                     | このリポジトリでの対応                                   |
| -------------- | -------------------------------- | -------------------------------------------------------- |
| Cursor         | `.agents/skills/`                | 実体を直接読む。`.cursor/skills` は作らない              |
| GitHub Copilot | `.agents/skills/`                | 実体を直接読む。`.copilot/skills` は作らない             |
| Claude Code    | `.claude/skills/<name>/SKILL.md` | `.claude/skills` を `.agents/skills` への symlink にする |
| OpenAI Codex   | `.agents/skills/`                | 実体を直接読む。追加の symlink は作らない                |

Copilot は VS Code の Agent Mode に加え、Copilot CLI、Cloud Agent、Code Review でも `.agents/skills/` を読む。`chat.agentSkillsLocations` の追加設定はしない。

Claude Code 用には、`.claude/skills` ディレクトリそのものを `../.agents/skills` への symlink にする。スキルを追加や削除しても、リンクを張り直す必要はない。

`.claude/skills/` には Claude Code 専用のスキルを置けない。置いたものは `.agents/skills/` に入り、ほかのツールからも見える。Claude Code 専用のスキルが必要になったら、スキルごとの symlink に切り替えるかを改めて検討する。

Cursor は互換のため `.claude/skills/` も探索する。`.agents/skills/` と symlink の両方が見えると、スキル一覧に同じスキルが二度出る可能性がある。一覧が二重になる場合は、そのツールの表示を確認して Issue にする。

## ディレクトリ

```text
.agents/skills/<name>/SKILL.md    # 実体。編集はここだけ
.claude/skills                    # ../.agents/skills への symlink
.cursor/rules/*.mdc               # Cursor に残す規約と Cursor 固有の手順
```

`SKILL.md` の先頭には `name` と `description` を書く。`name` はディレクトリ名と一致させ、小文字・数字・ハイフンだけを使う。`description` は、どの依頼でそのスキルを使うかを 1 行で書く。`>` や `|` を使った複数行の書き方はしない。

## 既存の Cursor Rules との境界

スキルは、依頼されたときに読む作業手順である。アーキテクチャや命名のように、スキルが選ばれなくても守る規約は Rules に残す。共通の規約を `AGENTS.md` へまとめる作業は、この配置の変更とは分けて検討する。

| ファイル                | 扱い                                   | 理由                                               |
| ----------------------- | -------------------------------------- | -------------------------------------------------- |
| `architecture-rule.mdc` | `.cursor/rules/` に残す                | レイヤー責務は、スキルの選択に依存させない制約     |
| `branch-rule.mdc`       | `.cursor/rules/` に残す                | ブランチの命名と運用は、作業のたびに参照する規約   |
| `memory.mdc`            | `.cursor/rules/` に残す                | `.cursor/memories/` への保存は Cursor 固有の操作   |
| `pr-creation-rule.mdc`  | `.agents/skills/pr-creation/` へ移した | プルリクエスト作成は、依頼されたときに実行する手順 |

`architecture-rule.mdc` は常時適用にする。レイヤー責務は、エージェントがルールを選ばなかった会話でも守る。

`pr-creation` は現在のリポジトリに対してプルリクエストを作る。以前のルールにあった `owner: yumemi-inc` の固定は、テンプレートから作成したリポジトリでは成り立たないため、スキルには引き継がない。

## スキルの追加と削除

`.agents/skills/<name>/SKILL.md` を追加または削除してコミットする。`.claude/skills` は symlink なので、ほかに作業はいらない。

`.claude/skills` の symlink が壊れたときは、リポジトリのルートで次を実行する。

```shell
scripts/sync-ai-skills.sh
```

スクリプトは `.claude/skills` を `../.agents/skills` への symlink に戻す。`.claude/skills` が実ディレクトリになっている場合は、スクリプトが作ったコピーと空のディレクトリだけを置き換え、それ以外は削除せずにエラーで止まる。

確認だけ行う場合は `scripts/sync-ai-skills.sh --check` を使う。不一致があると終了コード 1 で終わり、ファイルは変更しない。CI は同じコマンドで、symlink と `SKILL.md` の `name` / `description` を検査する。

[#700] で公式の Dart / Flutter スキルを `.agents/skills/` に加えるときも、symlink の作業はいらない。`skills-lock.json` は使わない。導入したスキルの台帳は [#700] の `.config/dart_skills/` が担う。

## Windows

Git は `core.symlinks=false` のとき、symlink をリンクではなく、リンク先のパスが書かれた通常ファイルとして checkout する。Windows ではこの設定が既定になることがあり、そのファイルのままだと Claude Code は `.claude/skills` を読めない。Cursor と Copilot は `.agents/skills/` を直接読むため、この影響を受けない。

symlink を使う場合は、次を満たしてから clone する。

1. Windows の開発者モードを有効にするか、symlink を作成できる権限で Git を動かす。
2. `git config --global core.symlinks true` を設定する。

すでに clone 済みで `.claude/skills` がパス文字列のファイルになっている場合は、開発者モードを有効にしたうえで、リポジトリのルートで次を実行する。clone 時に symlink を作れなかったリポジトリには `core.symlinks=false` が書き込まれており、`--global` の設定より優先されるため、リポジトリ側の設定も変える。

```shell
git config core.symlinks true
scripts/sync-ai-skills.sh
```

symlink を作成できない環境では、同じスクリプトが `.claude/skills` を `.agents/skills` のコピーとして復元する。これはその環境で Claude Code が読むための一時的な復元である。

- コピーはコミットしない。`git status` では `.claude/skills` が変更として表示される。
- コピー側は編集しない。編集は `.agents/skills/` に行い、スクリプトを再実行する。
- スキルを追加、削除、変更したあとは、その環境でもスクリプトを再実行する。コピーは自動では追従しない。

<!-- Links -->

[#700]: https://github.com/ymm-oss/flutter-mobile-project-template/issues/700
