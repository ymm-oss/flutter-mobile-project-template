# AGENTS.md

このプロジェクトは、Flutter モバイルアプリケーション開発を迅速に開始し、一定の品質基準を保つための標準テンプレートである。
ユーザーの目的は「テンプレートの改善・進化」であり、「テンプレートを使ってプロジェクトを作る」ではない。

## 環境

- Flutter SDK は mise で管理している。
- clone や worktree を新しく作ったら `mise bs` を実行する。実行しないと依存が入らず、コミット時のフック（husky）も動かない。
- 複数のパッケージを Melos でまとめて管理しており、`dart run melos` で実行する。
  - ルートの `pubspec.yaml` の `melos.command.bootstrap` に載っている依存は、ルート側で管理する。

## 生成されたファイル

- `*.g.dart`、`*.freezed.dart` などの生成されたファイルは直接直さない。元のファイルを直し、コード生成で作り直す。

## レイヤーの依存方向

- 依存の向きは `presentation` → `composition_root` → `application` / `infrastructure` → `domain_logic` → `domain_model` の一方向にする。逆向きの依存や循環参照は作らない。
- `domain_model` はほかのレイヤーに依存しない。`shared` と `util_*` はどこにも依存せず、どこからでも参照できる。
- `application` と `infrastructure` は互いに依存しない。データ取得や外部連携は `infrastructure` に置き、`domain_logic` のインターフェースを通して使う。
- 依存性の注入は `apps/app/lib/composition_root` で行う。
- `debug` は `apps/app/lib/debug/debug_features_impl.dart` からだけ参照する。リリースビルドから外すため。
- 詳しくは [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) を見る。

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
