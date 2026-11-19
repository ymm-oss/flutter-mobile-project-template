# AGENTS.md

このプロジェクトは、Flutter モバイルアプリケーション開発を迅速に開始し、一定の品質基準を保つための標準テンプレートである。
ユーザーの目的は「テンプレートの改善・進化」であり、「テンプレートを使ってプロジェクトを作る」ではない。

## 環境

- Flutter SDK は mise で管理している。
- 複数のパッケージを Melos でまとめて管理しており、`dart run melos` で実行する。
  - 共通の依存パッケージは各 `pubspec.yaml` を直接変更せず、ルートの `pubspec.yaml`（`melos.command.bootstrap`）を変更して `dart run melos bootstrap` を実行する。

## コマンド

- コマンドは `mise run <タスク>` で実行する。中身は `mise.toml` の `[tasks]` にある。
  - 解析: `mise run analyze`
  - フォーマット: `mise run format`
  - コード生成: `mise run gen`
  - テスト: `mise run test`
- 作業を終える前に `mise run check` が通ることを確かめる。解析（info も含む）、フォーマット、循環参照、テストをまとめて検査する。
- `debug` への参照を変えたときは、`dart run melos run check:debug_tree_shaking` も通ることを確かめる。リリースビルドを作るため時間がかかり、`check` には含めていない。

## 生成されたファイル

- `*.g.dart`、`*.freezed.dart` などの生成されたファイルは直接直さない。元のファイルを直し、コード生成で作り直す。

## レイヤーと置き場所

- ドメインのロジックは `domain_logic` に、データ取得や外部連携は `infrastructure` に置く。`presentation` に直接書かない。
- `presentation` から `application` や `infrastructure` を直接 import しない。依存性の注入は `apps/app/lib/composition_root` で行う。
- `debug` は `apps/app/lib/debug/debug_features_impl.dart` からだけ参照する。リリースビルドから外すため。
- パッケージの依存や import を足す前に、[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) の図で依存方向を確かめる。

## 公式スキルとの関係

- 公式の Dart / Flutter スキルとこのリポジトリの決まりが違うときは、このリポジトリの決まりを優先する。
- 公式スキルは原則として書き換えない。

## コミットとブランチ

- コミットメッセージは Conventional Commits に従う（`<type>(<scope>): <description>`）。
  - コミット時の自動チェック（husky）を含めた詳細は [docs/COMMIT_CONVENTION.md](docs/COMMIT_CONVENTION.md) を見る。
- ブランチ名は `<種別>/GH-<Issue 番号>/<目的>` を推奨する（例: `feat/GH-123/add-new-feature`）。
  - あくまで推奨であり、柔軟に決めてよい。詳しくは [docs/BRANCH.md](docs/BRANCH.md) を見る。

## AI と人の分担

- 仕様やアーキテクチャの判断、規約やドキュメントの方針は、人と一緒に決める。それ以外の実装や検査の修正は AI に任せてよい。
- 確認したいことは 1 問ずつ聞く。選択肢とおすすめを添える。
- 重要な判断では、反対案と失敗するケースを出す。

## 改善

- AI が同じ間違いを 2 回以上したら、`AGENTS.md`、各ツールの hooks（Claude Code、Cursor、Codex）、スキルのどれかを改善するよう提案する。
