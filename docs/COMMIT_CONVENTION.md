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
ただし、コミットメッセージの検査も飛ばされ、違反は CI で検出されます。

<!-- Links -->

[`@commitlint/config-conventional`]: https://github.com/conventional-changelog/commitlint/tree/master/%40commitlint/config-conventional
[`husky`]: https://typicode.github.io/husky/
[`commitlint`]: https://commitlint.js.org/
[`dprint.jsonc`]: ../dprint.jsonc
[`cspell.jsonc`]: ../cspell.jsonc
