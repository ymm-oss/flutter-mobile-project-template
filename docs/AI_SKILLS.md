# AI スキルの配置

Cursor、GitHub Copilot、Claude Code で共有するスキルの実体は `.agents/skills/` の一箇所に置く。ここが共有スキルの単一の実体である。ホームディレクトリの個人設定ではなく、リポジトリにコミットし、clone したメンバーが同じスキルを使えるようにする。

このドキュメントは、配置とツールごとの読み取り方、公式の Dart / Flutter スキルの取り込み方を決める。

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
.agents/skills/dart-*/            # 公式の Dart スキル。skills パッケージが管理する
.agents/skills/flutter-*/         # 公式の Flutter スキル。skills パッケージが管理する
.config/dart_skills/              # 公式スキルの設定ファイル。skills パッケージが管理する
.claude/skills                    # ../.agents/skills への symlink
.cursor/rules/*.mdc               # Cursor に残す規約と Cursor 固有の手順
```

`dart-` と `flutter-` で始まる名前は公式スキル用に空けておく。このリポジトリ固有のスキルには使わない。

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

公式の Dart / Flutter スキルを加えるときも、symlink の作業はいらない。`skills-lock.json` は使わない。導入したスキルは `.config/dart_skills/` の設定ファイルに記録される。

## 公式の Dart / Flutter スキル

Dart と Flutter の公式スキルは、依存パッケージに同梱されていないため、`.agents/skills/` に取り込んでコミットする。clone したメンバーは、追加の作業なしで同じスキルを使える。

| 取り込み元                                 | 取り込むスキル | 理由                                                                     |
| ------------------------------------------ | -------------- | ------------------------------------------------------------------------ |
| <https://github.com/dart-lang/skills>      | すべて         | Dart スキルの正本                                                        |
| <https://github.com/flutter/agent-plugins> | `flutter-*`    | 同じリポジトリの `dart-*` は Dart 側の写しで、修正が遅れることがあるため |

`flutter/agent-plugins` は旧名の `flutter/skills` からリネームされた。

取り込みと更新には、Dart SDK から実行できる [skills] パッケージを使う。`--agent generic` を指定すると `.agents/skills/` に配置される。実行のたびに同じ版が動くよう、`skills@1.0.4` のように版を固定して実行する。ツールの版を上げるときは、スキルの更新とは別のプルリクエストにする。

[skills] パッケージは `package:unified_analytics` で利用状況を送る。送信するかは Dart / Flutter 共通のテレメトリー設定に従い、`dart --disable-analytics` で止められる。

### 設定ファイル

`.config/dart_skills/skills_config.json` は、どの取り込み元からどのスキルを入れ、どれを外したかの記録である。外したスキルは `"isInstalled": false` として残る。このファイルがないと、次に `dart run skills@1.0.4 get` したとき、外したスキルが未導入として再び候補に出る。そのため `.config/dart_skills/` もコミットし、gitignore しない。

設定ファイルとスキル本体は手で編集しない。`contentHash` と内容がずれると、そのスキルは手元の編集として扱われ、更新を検出できなくなる。

### 更新

リポジトリのルートで次を実行し、更新を確認する。このコマンドはファイルを変更しない。

```shell
dart run skills@1.0.4 get --agent generic
```

出力には取り込み元ごとに次の状態が表示される。

| 状態                 | 意味                                                               |
| -------------------- | ------------------------------------------------------------------ |
| `Update available`   | 取り込んだスキルに上流の更新がある                                 |
| `New`                | 上流に新しいスキルが追加された。まだ取り込むか決めていない         |
| `Skipped previously` | 設定ファイルで外したスキル。`--skill` で指定しない限り再び入らない |
| `Local edits`        | 取り込んだスキルが手元で編集されている                             |

取り込むスキルを `--skill` で指定して更新する。

```shell
dart run skills@1.0.4 get --agent generic --skill <name> --skill <name>
```

- `--all` は使わない。外したスキルや、`flutter/agent-plugins` の `dart-*` まで取り込まれる。
- `--skill` で指定しなかった `New` のスキルは、外したスキルとして設定ファイルに記録される。取り込むかを決めてから実行する。
- 依存パッケージが同梱するスキル（`package:melos` など）も候補に表示される。公式の Dart / Flutter スキル以外は、取り込む理由ができるまで入れない。

更新したら、`.agents/skills/` と `.config/dart_skills/` の差分をまとめてプルリクエストにする。

- プルリクエストの本文に、取り込み元ごとのコミット SHA を書く。設定ファイルには SHA を残す欄がないため、どの時点の上流を取り込んだかがリポジトリに残らない。SHA は `git ls-remote <取り込み元の URL> HEAD` で確認できる。
- レビューでは、公式スキルの本文の差分も読む。公式スキルはエージェントが従う指示そのものである。`contentHash` は変更を検出するためのハッシュで、改ざんは防げない。
- 公式スキルには `.gitattributes` で `linguist-generated` を付けない。付けるとプルリクエストの差分が折りたたまれ、レビューで読まれなくなる。

### 外した公式スキル

公式スキルは、一般的な Dart / Flutter プロジェクト向けに書かれている。エージェントは `description` を見てスキルを自動で使うため、このリポジトリの技術選定や構成と食い違うスキルは取り込まない。ルールで優先順位を書いても、ルールを読まないエージェントには届かない。

| スキル                                      | 外した理由                                                   |
| ------------------------------------------- | ------------------------------------------------------------ |
| `flutter-use-http-package`                  | HTTP 通信には dio を使う                                     |
| `flutter-implement-json-serialization`      | JSON の変換は freezed と json_serializable で生成する        |
| `flutter-setup-localization`                | 多言語対応には slang を使う                                  |
| `flutter-apply-architecture-best-practices` | レイヤー構成が [アーキテクチャ] のパッケージ構成と一致しない |

取り込み済みのスキルを外すときは、`remove` で消したあと、残すスキルを 1 つ指定して `get` する。指定しなかったスキルが外したスキルとして設定ファイルに記録され、`Skipped previously` になる。

```shell
dart run skills@1.0.4 remove --agent generic --git <取り込み元の URL> --skill <外すスキル>
dart run skills@1.0.4 get --agent generic --git <取り込み元の URL> --skill <残すスキル>
```

残した公式スキルとこのリポジトリのルールが異なる場合は、[.cursor/rules/] と [アーキテクチャ] を優先する。

公式スキルはこのリポジトリに合わせて書き換えない。書き換えると上流の更新を取り込めなくなる。補足が必要な場合は、ルールかドキュメントに書く。

### 検査の対象外

公式スキルは上流の書式のまま取り込む。そのため、次の検査からは公式スキルを外す。

- `scripts/sync-ai-skills.sh --check` の `description` の書式。対象は設定ファイルに導入済みとして記録されたスキルで、`name` とディレクトリ名の一致は検査する
- dprint（`.agents/skills/dart-*/`、`.agents/skills/flutter-*/`、`.config/dart_skills/`）
- cspell（`.agents/skills/dart-*/`、`.agents/skills/flutter-*/`）

代わりに、`scripts/sync-ai-skills.sh --check` は公式スキルの内容から `contentHash` を計算し、設定ファイルの値と照合する。手で編集した公式スキルや、設定ファイルにあってディレクトリが無いスキルはエラーになる。設定ファイルを読むために jq を使う。jq は `mise.toml` で管理している。

Dart の例のファイルは、ドットで始まるディレクトリにあるため `dart analyze` の対象にならない。

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

[skills]: https://pub.dev/packages/skills
[.cursor/rules/]: ../.cursor/rules/
[アーキテクチャ]: ARCHITECTURE.md
