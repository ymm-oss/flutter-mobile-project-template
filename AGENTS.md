# AGENTS.md

このプロジェクトは、Flutter モバイルアプリケーション開発を迅速に開始し、一定の品質基準を保つための標準テンプレートである。
ユーザーの目的は「テンプレートの改善・進化」であり、「テンプレートを使ってプロジェクトを作る」ではない。

## 環境

- Flutter SDK は mise で管理している。
- 複数のパッケージを Melos でまとめて管理しており、`dart run melos` で実行する。
  - 共通の依存パッケージは各 `pubspec.yaml` を直接変更せず、ルートの `pubspec.yaml`（`melos.command.bootstrap`）を変更して `dart run melos bootstrap` を実行する。

## コマンド

- 解析: `dart analyze`
- フォーマット: `dart run melos run format`
- コード生成: `dart run melos run gen`（未コミットの変更があるパッケージだけなら `gen:diff:head`）
- テスト: `dart run melos run test`

作業を終える前に、次を確かめる。

- `dart analyze` で info も含めて何も出ないこと
- `dart run melos run format:check` が通ること
- `dart run melos run test` が通ること
- パッケージの依存を変えたときは、`dart run melos list --cycles` で循環がないこと
- `debug` への参照を変えたときは、`dart run melos run check:debug_tree_shaking` が通ること

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
