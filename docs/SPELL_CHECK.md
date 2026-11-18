# スペルチェック運用ルール

本プロジェクトでは、開発者間での表記揺れやスペルミスによる混乱を防ぐため、[CSpell] を利用したスペルチェックを導入・運用しています。

## CSpell の設定

設定は [cspell.jsonc] に記載しています。

このファイルでは、どのファイルをチェック対象・対象外にするか、どのカスタム辞書・外部辞書を使うかなど、細かな挙動を柔軟に制御できます。

設定例として、`cspell.jsonc` には以下のような内容が含まれます。

```jsonc
{
  "$schema": "https://raw.githubusercontent.com/streetsidesoftware/cspell/main/cspell.schema.json",
  "version": "0.2",
  "useGitignore": true,
  "enableGlobDot": true,
  "overrides": [
    {
      "filename": "**/*.{md,yaml,yml,dart}",
      "dictionaries": ["dart", "flutter"]
    }
  ],
  "dictionaryDefinitions": [
    {
      "name": "project-term",
      "path": "./.cspell/project-term.txt",
      "addWords": true
    }
    // ...他の辞書定義
  ],
  "dictionaries": [
    "project-term"
    // ...他の辞書
  ],
  "files": [
    "**/*.{md,yaml,yml,dart}"
    // ...他のチェック対象ファイル
  ],
  "ignorePaths": [
    "*.*.dart"
    // ...他のチェック対象外ファイル
  ],
  "ignoreRegExpList": [
    "(TODO|FIXME|HACK|UNDONE)\\([^)]*\\)"
    // ...他のチェック対象外パターン
  ],
  "import": [
    "@cspell/dict-software-terms/cspell-ext.json"
    // ...他の外部辞書
  ]
}
```

設定についての詳しい情報は、以下の公式ドキュメントをご覧ください。

<https://cspell.org/docs/Configuration>

## カスタム辞書の運用

プロジェクトやツールなどで使う単語や略語、固有名詞などは、`.cspell/` ディレクトリ内の各種 `*-term.txt` ファイルにまとめています。もしスペルチェックで誤検知（プロジェクト独自の単語など）があった場合は、該当する辞書ファイルに単語を追加してください。追加した内容は Pull Request として提出し、レビューを受けてから反映します。

カスタム辞書についての詳しい情報は、以下の公式ドキュメントをご覧ください。

<https://cspell.org/docs/dictionaries/custom-dictionaries>

## CI でのスペルチェック

Pull Request 作成時などに GitHub Actions によって自動的にスペルチェックが実行されます。

詳しい設定は以下のファイルをご覧ください。

- [.github/workflows/check-pr.yaml]
- [.github/workflows/wc-check-code-spell.yaml]

## 手元でのスペルチェック

まずは、プロジェクトで必要なツールやパッケージをインストールします。

```sh
# ツールのインストール
mise install

# パッケージのインストール
bun install --ignore-scripts
```

インストールが終わったら、以下のコマンドを実行してプロジェクト全体のスペルチェックを行います。

```sh
mise run cspell
```

## VS Code 拡張機能

CSpell の開発企業 [Street Side Software] から VS Code 拡張機能が提供されています。

<https://streetsidesoftware.com/vscode-spell-checker/>

拡張機能をインストールして有効化すると、`cspell.jsonc` やカスタム辞書も自動的に認識され、さまざまな便利な機能が利用できます。

<!-- Links -->

[CSpell]: https://cspell.org/
[cspell.jsonc]: ../cspell.jsonc
[.github/workflows/check-pr.yaml]: ../.github/workflows/check-pr.yaml
[.github/workflows/wc-check-code-spell.yaml]: ../.github/workflows/wc-check-code-spell.yaml
[Street Side Software]: https://streetsidesoftware.com/
