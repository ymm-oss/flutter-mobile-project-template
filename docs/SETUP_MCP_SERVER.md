# Model Context Protocol (MCP) Server

## 概要

Model Context Protocol (MCP) は、AIアシスタントがローカル環境やクラウドサービスと安全に対話するためのプロトコルです。以下のような特徴があります：

- AIアシスタントが外部ツールやサービスを利用可能
- 標準化されたインターフェースによる安全な操作
- 拡張可能なツールセットの提供

MCPサーバーは、特定のドメインやサービス（Flutterアプリの操作、Dartの解析等）に対して、AIアシスタントが実行可能な操作を提供します。各サーバーは独自の機能セットを持ち、それらを安全に実行するための仕組みを提供します。

本ドキュメントでは、

- [Marionette MCP Server](#marionette-mcp-server)
- [Dart and Flutter MCP Server](#dart-and-flutter-mcp-server)

の設定方法を記載する。

## 前提条件

> [!Note]
> Claude Code で使用されることを想定しています。

1. プロジェクトの要件に応じ、有効化する MCP Server を選定し、以後の作業を実施する
2. [.mcp.sample.json] をリポジトリのルートに `.mcp.json` としてコピーし、使わない MCP Server を消す。`.mcp.json` は gitignore しているため、各自の設定はコミットされない
3. 後述する各種 MCP Server のセットアップを実施する
4. Claude Code を起動し直す。`.mcp.json` の MCP Server を使ってよいか確認されたら承認する。接続の状態は `/mcp` で確かめられる

Cursor を使う場合は、`.mcp.json` と同じ内容を `.cursor/mcp.json` に書いてください。

Codex 用の設定例は、このドキュメントでは扱いません。

## 利用上の注意点

### プライバシーとセキュリティ

- AIアシスタントとのやり取りでも機密情報の共有は避けてください

### コミュニケーションのベストプラクティス

- 明確で具体的な指示を出すことで、意図した操作が行われやすくなります
- 複雑な操作は、段階的に指示することをおすすめします

## Marionette MCP Server

### Marionette MCP Server 概要

[Marionette MCP]は、DebugまたはProfileモードで実行中のFlutterアプリにVM Service経由で接続し、AIアシスタントから次の操作を可能にします。

- 画面上の対話可能なWidgetと状態の取得
- テキストやWidget種別を使ったタップ、スクロール、文字入力
- スクリーンショット、ログ、操作レポートの取得
- Hot reload、Hot restart

Releaseビルドや自動回帰テストの代替には使用しません。再現性が必要なシナリオはWidget testまたはIntegration testとして実装してください。

### セットアップ

[前提条件](#前提条件)のとおり `.mcp.json` を用意し、`marionette` を残してください。

MCP Server の `marionette_mcp` は、ルートの `pubspec.yaml` の `dev_dependencies` にあります。`mise run bootstrap` で入るため、追加のインストールは不要です。`.mcp.json` の `dart run marionette_mcp` は、リポジトリの外で実行すると `marionette_mcp` を見つけられません。

`marionette_mcp` のバージョンを変えるときは、アプリの依存の `marionette_flutter`（`apps/app` と `apps/catalog`）とそろえてください。

### アプリの起動

VS CodeまたはIntelliJ IDEAでは、次のRun Configurationを使用できます。

- `dev-debug-marionette`
- `ui-catalog-marionette`

CLIから起動する場合は次のコマンドを使用します。

```shell
# 本体アプリ
cd apps/app
mise exec -- flutter run \
  --target lib/main_marionette.dart \
  --dart-define-from-file=flavor/dev.json

# UI Catalog（例: macOS）
cd ../catalog
mise exec -- flutter run \
  --target lib/main_marionette.dart \
  --device-id macos
```

起動ログに表示されるVM Service URIを、AIアシスタントからMarionetteの`connect`へ渡します。接続後は`get_interactive_elements`で要素を取得してから操作してください。

### Bindingの制約

- `MarionetteBinding`はFlutterプロセスで最初に初期化する必要があります。
- 通常起動は`main.dart`、Marionetteを使用する場合だけ`main_marionette.dart`を選択してください。
- `flutter test`ではTest Bindingを使用するため、`main_marionette.dart`を呼び出さないでください。
- Marionette用entrypointはDebug/Profile確認専用です。Release buildには通常の`main.dart`を使用してください。
- セッションレポートは`.marionette/sessions/`へ出力されます。

## Dart and Flutter MCP Server

### Dart and Flutter MCP Server 概要

[Dart and Flutter MCP Server]は、Dart SDK に含まれる MCP Server です。mise で管理している Dart SDK の `dart mcp-server` で起動するため、追加のインストールは不要です。AI アシスタントから次の操作ができます。

- 実行中のアプリのランタイムエラーと Widget ツリーの取得
- Hot reload、Hot restart
- 静的解析、シンボルの検索
- pub.dev の検索、依存パッケージのソースの参照
- アプリの起動と停止（既定では無効）

依存パッケージのソースを検索する `rip_grep_packages` は ripgrep（`rg`）を使います。ripgrep がない環境では、`read_package_uris` でソースを読んでください。

一部の公式スキルは、この Server のツールを前提にしています。対象のスキルは [AI スキルの配置] を見てください。

### Dart and Flutter MCP Server 有効化

[前提条件](#前提条件)のとおり `.mcp.json` を用意し、`dart` を残してください。追加のインストールは不要です。

[.mcp.sample.json] では、既定で有効なツールだけを使います。アプリは `flutter run` か IDE で起動し、AI アシスタントは DTD を経由して接続します（[実行中のアプリへの接続](#実行中のアプリへの接続)）。

`launch_app` を使うスキル（`flutter-add-integration-test` など）を使うときは、`.mcp.json` の `dart` の `args` の末尾に `--enable` と `flutter_app_lifecycle` を足してください。`launch_app`、`stop_app`、`list_devices`、`get_app_logs`、`list_running_apps` が有効になります。

```json
"args": ["exec", "--", "dart", "mcp-server", "--disable", "pub", "--enable", "flutter_app_lifecycle"]
```

`dart_fix`、`dart_format`、`run_tests`、`create_project` も既定では無効です。フォーマットとテストは [AGENTS.md] のとおり `mise run` のタスクで実行するため、有効にしません。`analyze_files` は既定で有効ですが、作業を終える前の検査は `mise run check` で行ってください。

### 実行中のアプリへの接続

ランタイムエラーや Widget ツリーの取得など、実行中のアプリを扱うツールは、Dart Tooling Daemon（DTD）への接続が必要です。AI アシスタントが `dtd` ツールで DTD を探し、接続します。

`flutter run` や IDE で起動したアプリに接続できます。`flutter run` に追加の引数は不要です。`launch_app` を有効にした場合は、`launch_app` で起動したアプリにも接続できます。

### Flutter Driver の制約

`flutter_driver_command`（`tap`、`enter_text` など）を使うには、アプリで `enableFlutterDriverExtension()` を呼び出す必要があります。呼び出していないアプリでは、このツールはエラーになります。

- `enableFlutterDriverExtension()` は Flutter Driver 用の Binding を初期化します。Flutter のアプリが持てる Binding は 1 つだけのため、`MarionetteBinding` を使う `main_marionette.dart` とは同時に使えません。
- テンプレートには Flutter Driver 用の entrypoint がありません。使う場合は、`flutter_driver` を `dev_dependencies` に追加し、別の entrypoint を用意してください。

### Marionette MCP との使い分け

| 目的                                                 | 使う Server                 |
| ---------------------------------------------------- | --------------------------- |
| 画面をタップ、スクロール、文字入力して動作を確かめる | Marionette MCP              |
| ランタイムエラーや Widget ツリーを調べる             | Dart and Flutter MCP Server |
| 静的解析、シンボルの検索、依存パッケージを調べる     | Dart and Flutter MCP Server |

- Marionette MCP は、Flutter Driver の拡張を入れなくても、テキストや Widget の種類で要素を指定して操作できます。
- Marionette MCP は、ランタイムエラーの取得、Widget ツリーの検査、静的解析の代わりになりません。
- どちらも、実行中のアプリには VM Service を経由して接続するため、Debug または Profile モードのアプリにしか接続できません。OS のネイティブの UI（許可ダイアログなど）も操作できません。

## 参考

- [Marionette MCP]
- [Dart and Flutter MCP Server]

<!-- URLs -->

[.mcp.sample.json]: ../.mcp.sample.json
[Marionette MCP]: https://marionette.leancode.co/docs/
[Dart and Flutter MCP Server]: https://github.com/dart-lang/ai/tree/main/pkgs/dart_mcp_server
[AI スキルの配置]: AI_SKILLS.md#dart-and-flutter-mcp-server-を前提にするスキル
[AGENTS.md]: ../AGENTS.md
