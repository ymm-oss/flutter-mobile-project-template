# はじめに

## IDE バージョン

| IDE            | バージョン        |
| -------------- | ----------------- |
| Android Studio | Rabbit 1 2026.2.1 |
| Xcode          | 27.0              |

**注意**: 記載されているバージョンでの動作を確認しています。これより古いバージョン、または新しいバージョンでは正常に動作しない可能性があります。

## 事前準備

- IDE をインストールしてください。
  - [IntelliJ IDEA], [Android Studio] または [Visual Studio Code]
  - [Xcode]

- [mise] コマンドを有効にしてください。

  - また、以下のコマンドを実行して`mise.toml`で指定されたバージョンを有効化してください
    (melosはmise経由でのアクセスを行うと問題が起こり得るため、miseで現在のバージョンをglobalに設定するようにしている)

  ```shell
  mise i
  FLUTTER_VERSION=$(grep '^flutter =' mise.toml | awk -F'"' '{print $2}') && mise use -g flutter@$FLUTTER_VERSION
  ```

- [melos] はルートの `pubspec.yaml` の dev_dependencies に含まれています。グローバルにインストールせず、`dart run melos` で実行してください。

## Mise を使用するように IDE を設定

[Visual Studio Code] を使用している場合は、ウィンドウをリロードして SDK を再読み込みしてください。

[IntelliJ IDEA] または [Android Studio] を使っている場合以下の手順で設定してください

```shell
# Flutter SDK の絶対パスを表示
mise where flutter

# <USER_PATH>/.local/share/mise/installs/flutter/<FLUTTER_VERSION>
```

1. 上記のコマンドを実行しSDKの絶対パスをコピーします。
2. 「Languages & Frameworks」 > 「Flutter」に移動するか、「Flutter」を検索して、Flutter SDK のパスを変更します。
3. 変更を適用します。
4. 新しい設定が反映されるようにエディタを再起動します。

### エディターの設定

Visual Studio Code を使用する場合は、`.vscode/extensions.json` に列挙された推奨拡張機能をインストールしてください。

このプロジェクトでは、コミットメッセージの一貫性を保つために、[Conventional Commits](https://www.conventionalcommits.org/) を使用しています。
各エディターにおいて、コミットメッセージの形式をチェックするための拡張機能を導入することをお勧めします。

- Visual Studio Codeを使用する場合は、[Conventional Commits](https://marketplace.visualstudio.com/items?itemName=vivaxy.vscode-conventional-commits)の導入が推奨されます。
- Android Studioを使用する場合は、以下の拡張機能の導入が推奨されます。
  - [Conventional Commit](https://plugins.jetbrains.com/plugin/13389-conventional-commit)
  - [Commitlint Conventional Commit](https://plugins.jetbrains.com/plugin/14046-commitlint-conventional-commit)

### 開発環境のセットアップ

```shell
mise bs
```

上記のコマンドを実行すると、mise, bun, melos の依存関係がインストールされ、プロジェクトの初期セットアップが行われます。
コミット時に実行されるフック（husky）も、このコマンドで有効になります。

`git worktree` で作業ツリーを追加したときは、その作業ツリーでも `mise bs` を実行してください。
実行しないと、その作業ツリーではコミット時のフックが動きません。

### アプリの実行

このアプリを実行するための実行構成が設定されています。

Please check:

- [Visual Studio Code] の場合、`.vscode/launch.json` を確認してください。
- [IntelliJ IDEA] または [Android Studio] の場合、`.idea/runConfigurations/~.xml` を確認してください。

### モックサーバーの起動

次のコマンドで、OpenAPI の仕様書（`openapi/<api_name>/openapi.yaml`）の `example` を返すモックサーバーが起動します。

```shell
mise run mock
```

`openapi` に API が複数あるときは、`mise run mock <api_name>` で API 名を指定してください。

モックサーバーの URL は `http://127.0.0.1:4000` に仕様書の `servers` の 1 つ目の URL のパスを付けたものです。たとえば `servers` の URL が `https://api.example.com/v1` なら `http://127.0.0.1:4000/v1` になります。起動時にもこの URL を表示します。生成したクライアントの接続先には、この URL を渡してください。Android エミュレーターでは `127.0.0.1` がエミュレーター自身を指すため、`127.0.0.1` を `10.0.2.2` に替えて渡してください。

- 各 operation の 2xx（なければ `2XX`、`default` の順）の応答から、media type の `example`、`examples` の最初の `value`、`schema` の `example`、`schema` の `examples` の最初の値の順に探して返します。`example` がない operation には 501 を返し、起動時にもその一覧を表示します。
- JSON でない media type（`text/plain` など）の `example` は文字列で書いてください。オブジェクトや配列の `example` には 501 を返します。
- ほかのファイルへの `$ref` は読めません。起動時に、読めなかったパスと、`$ref` を読めずに 501 を返す operation の一覧を表示します。
- ポートは `mise run mock --port 4011` のように変えられます。Firebase Local Emulator Suite の UI も既定で 4000 を使うため、同時に動かすときは別のポートにしてください。
- 使い方は `mise run mock -- --help` で表示します。`--` を付けないと、mise が `--help` を受け取ります。
- 仕様書を変えたときは、モックサーバーを起動し直してください。

## AI コーディングツール

Cursor、GitHub Copilot、Claude Code で共有するスキルは `.agents/skills/` に含まれています。Claude Code は `.agents/skills/` への symlink である `.claude/skills` から読みます。Windows で symlink がパス文字列のファイルとして checkout されたときは、次のスクリプトで復元します。手順と Windows での設定は [AI スキルの配置] を参照してください。

```shell
scripts/sync-ai-skills.sh
```

公式の Dart / Flutter スキルも `.agents/skills/` に含まれているため、clone 後に追加の作業はいりません。更新するときは `dart run skills@1.0.4 get` で差分を確認し、`.agents/skills/` と `.config/dart_skills/` の差分をプルリクエストにします。手順は [AI スキルの配置] を参照してください。

AI が常に守る規約は、ルートの [AGENTS.md] に書いています。公式スキルとこのリポジトリの決まりが異なる場合は、[AGENTS.md] と [アーキテクチャ] を優先してください。

## ワークスペースの設定

### `<workspace-name>.code-workspace` ファイルの作成

```json
{
  "folders": [
    {
      "path": "<flutter-mobile-project-templateのpath>"
    },
    {
      "path": "<flutter-mobile-project-docs-templateのpath>"
    }
  ]
}
```

上記のフォーマットに従って`<workspace-name>.code-workspace`ファイルを作成し、以下の項目を適切に設定してください：

- `<workspace-name>`: プロジェクトのワークスペース名
- `<flutter-mobile-project-templateのpath>`: [flutter-mobile-project-template]から作成したプロジェクトの絶対パスまたは相対パス
- `<flutter-mobile-project-docs-templateのpath>`: [flutter-mobile-project-docs-template]から作成したドキュメントの絶対パスまたは相対パス

### ワークスペースの読み込み

1. メニューから`File` > `Open`を選択
2. 作成した`<workspace-name>.code-workspace`ファイルを開く

ワークスペースが正しく読み込まれると

- `folders`で指定したフォルダ内のファイルが一覧表示される
- ウィンドウタイトルが`<workspace-name> (Workspace)`と表示される

<!-- Links -->

[IntelliJ IDEA]: https://www.jetbrains.com/idea/
[Android Studio]: https://developer.android.com/studio
[Visual Studio Code]: https://code.visualstudio.com/
[Xcode]: https://developer.apple.com/xcode/
[mise]: https://mise.jdx.dev/
[melos]: https://melos.invertase.dev/
[flutter-mobile-project-template]: https://github.com/ymm-oss/flutter-mobile-project-template/tree/main
[flutter-mobile-project-docs-template]: https://github.com/ymm-oss/flutter-mobile-project-docs-template
[AI スキルの配置]: AI_SKILLS.md
[AGENTS.md]: ../AGENTS.md
[アーキテクチャ]: ARCHITECTURE.md
