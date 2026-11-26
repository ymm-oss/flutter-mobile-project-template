# AGENTS.md

このプロジェクトは、Flutter モバイルアプリケーション開発を迅速に開始し、一定の品質基準を保つための標準テンプレートである。
ユーザーの目的は「テンプレートの改善・進化」であり、「テンプレートを使ってプロジェクトを作る」ではない。

## 環境

- Flutter SDK は mise で管理している。
- clone や worktree を新しく作ったら `mise bs` を実行する。実行しないと依存が入らず、コミット時のフック（husky）も動かない。
- 複数のパッケージを Melos でまとめて管理している。
  - 共通の依存（ルートの `pubspec.yaml` の `melos.command.bootstrap`）のバージョンは、ルートだけで変える。
  - 共通の依存をパッケージに足すときは、そのパッケージの `pubspec.yaml` にもルートと同じバージョンで書く。ルートに書いただけでは、パッケージに入らない。
  - `pubspec.yaml` を変えたら `mise run bootstrap` を実行する。

## コマンド

- コマンドは原則 `mise run <タスク>` で実行する。中身は `mise.toml` の `[tasks]` にある。タスクに無い操作だけ、`mise exec -- <コマンド>` で実行する。
- 作業中は、変えたところだけを確かめる。パスはリポジトリのルートから書く。空白で区切って、複数渡せる。
  - 解析: `mise run analyze <ファイルやディレクトリ>...`
  - テスト: `mise run test <テストファイルやパッケージのディレクトリ>...`
- 作業を終える前に `mise run check` を実行する。失敗したら直し、通るまで繰り返す。
  - フォーマットを実行してから、解析（info も含む）、循環参照、テストを検査する。フォーマットはファイルを書き換える。対象は各パッケージの `lib/` だけで、`test/` は直さない。
  - 生成されたファイルが最新かは検査しない。作り直すのを忘れても `check` は通る。
  - 失敗した検査だけをやり直すときは、解析は `mise run analyze`、テストは `mise run test` を使う。フォーマットと循環参照は `check` をやり直す。
- `debug` への参照を変えたときは、`mise run check:debug_tree_shaking` も通ることを確かめる。リリースビルドを作るため時間がかかり、`check` には含めていない。

## 生成されたファイル

- `*.g.dart`、`*.freezed.dart` などの生成されたファイルは直接直さない。元のファイルを直す。
- 次のどれかを変えたら、`mise run gen` で作り直す。
  - `part` で `*.g.dart` や `*.freezed.dart` などを取り込んでいる Dart のファイル
  - `apps/catalog` の `@UseCase`（追加、削除、名前の変更）
  - i18n の定義（`*.i18n.json`）
  - `pubspec.yaml` の `flutter.assets` に載っている画像などのファイル（追加、削除、名前の変更）

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
