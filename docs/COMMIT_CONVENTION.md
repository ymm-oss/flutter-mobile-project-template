# コミットメッセージ規約

このプロジェクトでは、[`@commitlint/config-conventional`]に基づいたコミットメッセージのフォーマットを採用しています。
詳細なルールについては、[`commitlint`]の設定ファイル（`.commitlintrc.yaml`）や[`@commitlint/config-conventional`]を参照してください。

## フォーマット

```text
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### コミットタイプ

コミットタイプは以下の通りです：

- `feat`: 新機能
- `fix`: バグ修正
- `docs`: ドキュメントのみの変更
- `style`: コードの意味に影響を与えない変更（空白、フォーマット、セミコロンの欠落など）
- `refactor`: リファクタリング（バグ修正や機能追加ではない）
- `perf`: パフォーマンス改善
- `test`: テストの追加や既存のテストの修正
- `build`: ビルドシステムや外部依存関係の変更
- `ci`: CI設定ファイルやスクリプトの変更
- `chore`: その他の変更（ビルドプロセスやツールの変更など）
- `revert`: 以前のコミットの取り消し

## 例

### シンプルな例

```text
feat: ログイン画面にパスワード表示トグルを追加
```

```text
fix: ユーザー名のバリデーションエラーを修正
```

```text
docs: インストール手順を更新
```

### スコープを使用した例

```text
feat(auth): パスワードリセット機能を追加
```

```text
fix(api): ユーザー情報取得APIのエラーハンドリングを修正
```

### 本文とフッターを使用した例

```text
feat(auth): パスワードリセット機能を追加

ユーザーがパスワードを忘れた場合に、メールでリセットリンクを送信する機能を追加しました。
BREAKING CHANGE: パスワードリセットのエンドポイントが変更されました。
```

```text
fix(api): ユーザー情報取得APIのエラーハンドリングを修正

ユーザー情報取得APIで、ユーザーが存在しない場合に適切なエラーメッセージを返すように修正しました。
関連するチケット: #123
```

## 自動検証

このプロジェクトでは、[`husky`]を使用してコミットメッセージの自動検証を設定しています。
[`husky`]によってコミット時に自動で[`commitlint`]のチェックが実行され、規約に従っていない場合はコミットが拒否されます。

また、コミットの前にステージしたファイルを以下のように検査し、違反があればコミットを止めます。
自動では直さないため、表示されたコマンドで直してからコミットし直してください。

| 検査           | 対象                               | 直すコマンド  |
| -------------- | ---------------------------------- | ------------- |
| `dart format`  | `*.dart`（自動生成ファイルを除く） | `dart format` |
| `dprint check` | [`dprint.jsonc`] の対象            | `dprint fmt`  |
| `cspell lint`  | [`cspell.jsonc`] の対象            | -             |
| `gitleaks git` | すべてのファイル                   | -             |

部分的にステージしたファイル（`git add -p` など）は、ステージした内容ではなく作業ツリーの内容を検査します。

急ぎのときは、`git commit --no-verify` で検査を飛ばせます。
ただし、コミットメッセージの検査も飛ばされます。
ファイルの検査の違反は CI で検出されますが、コミットメッセージは CI では検査しません。

CI の `gitleaks git` は、`.gitleaks.toml` と `.gitleaksignore` を PR の base のコミットから読みます。
マージキューでは直前のエントリのマージ結果から読みます。
PR で足したり変えたりした設定と除外は、マージされるまで CI では使われません。
`.gitattributes` と行コメントの `gitleaks:allow` は使いません。
`.gitleaks.toml` の `[extend] path` で別のファイルを読むと、CI の検査は失敗します。

コミットの前に実行する `gitleaks git --staged` は、作業ツリーの `.gitleaks.toml`、`.gitleaksignore`、`gitleaks:allow` を使います。
そのため、PR で足した除外は手元では効いても CI では効きません。

### 秘密情報ではない値が検出されたとき

CI の `gitleaks git` が秘密情報ではない値（テスト用のダミーの値など）を検出したら、次の順で除外します。
CI を無視してマージする必要はありません。

1. 除外だけを足す PR を別に作り、マージします。
   この PR には検出されたコミットが入っていないので、CI は通ります。
2. 元の PR に push するか、Update branch で更新します。
   CI を再実行するだけでは、除外は反映されません。
   CI が設定を読む base のコミットは、PR を最後に更新したときのものに決まるためです。

除外は `.gitleaks.toml` の allowlist に書きます。
`[extend] useDefault = true` は必ず書いてください。
書かないと gitleaks の既定のルールが使われなくなり、ほかの秘密情報も検出されなくなります。

```toml
[extend]
useDefault = true

[allowlist]
# ファイルやディレクトリごと除外する
paths = ['''^test/fixtures/''']
# 特定の値だけを除外する
regexes = ['''^dummy-api-key-for-tests$''']
```

`.gitleaksignore` に検出結果の指紋（fingerprint）を書く方法は使いません。
指紋には検出したコミットの SHA が入るので、元の PR を rebase すると効かなくなります。
SHA を除いた指紋は行番号に結び付くので、同じ値が別の行に出ると検出されます。

<!-- Links -->

[`@commitlint/config-conventional`]: https://github.com/conventional-changelog/commitlint/tree/master/%40commitlint/config-conventional
[`husky`]: https://typicode.github.io/husky/
[`commitlint`]: https://commitlint.js.org/
[`dprint.jsonc`]: ../dprint.jsonc
[`cspell.jsonc`]: ../cspell.jsonc
