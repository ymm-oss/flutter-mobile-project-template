---
title: "[初期セットアップ（任意）] OpenAPI から API クライアントを生成する"
labels:
  - initialization
  - optional
---

## 概要

この Issue の対応は任意です。

このプロジェクトには、OpenAPI の仕様書から [OpenAPI Generator] で Dart Dio の API クライアントを生成する骨格が [openapi/sample] にあります。

```text
openapi/
  mise.toml                      # OpenAPI Generator と Java のバージョン
  mise.lock
  <api_name>/
    configs/dart-dio.yaml        # ジェネレーターのオプション
    scripts/generate-client.sh   # 生成スクリプト
    templates/                   # 既定のテンプレートを上書きするファイル
    openapi.yaml                 # 仕様書
```

生成スクリプトは、ディレクトリ名の `<api_name>` を API 名として、`packages/api/<api_name>` に `internal_api_<api_name>` パッケージを生成します。
API が複数ある場合は、API ごとにディレクトリを分けてください。

OpenAPI Generator と、その実行に必要な Java のバージョンは [openapi/mise.toml] で固定しています。
ルートの `mise.toml` に置くと、リポジトリ全体の `JAVA_HOME` が変わり、Android のビルドに使う JDK も変わるため、分けています。
`mise bs` ではインストールされません。

同じ仕様書の `example` を返すモックサーバー（[packages/mock_server]）も、`mise run mock <api_name>` で起動できます。使い方は [docs/MOCK_SERVER.md] を参照してください。

## Todo

- [ ] `openapi/sample` を `openapi/<api_name>` に改名する
  - `<api_name>` は Dart のパッケージ名に使うため、`snake_case` にする
- [ ] `openapi/<api_name>/openapi.yaml` をプロジェクトの仕様書に差し替える
- [ ] `openapi/<api_name>/configs/dart-dio.yaml` の `pubDescription` を書き換える
- [ ] クライアントを生成する

  ```shell
  mise -C openapi install
  openapi/<api_name>/scripts/generate-client.sh
  ```

- [ ] ルートの [pubspec.yaml] の `workspace` に `packages/api/<api_name>` を追加する
- [ ] 依存関係を解決し、`*.g.dart` を生成する

  ```shell
  mise bs
  dart run melos run gen:build
  ```

- [ ] モックサーバーを起動し、仕様書の `example` が返ることを確かめる

  ```shell
  mise run mock <api_name>
  ```

  `example` がない operation には 501 を返すため、モックで確かめたい operation には `example` を書く

- [ ] 生成した `packages/api/<api_name>` と、`mise bs` が更新した [.github/labeler.yml] と [.github/labels.yml] をコミットする
- [ ] 生成したパッケージを `infrastructure` 以外から使う場合は、[docs/ARCHITECTURE.md] の依存の向きを書き換える

仕様書を更新したときは、生成スクリプト、`mise bs`、`dart run melos run gen:build` を同じ順で実行してください。モックサーバーを起動しているときは、起動し直してください。
`openapi` か `packages/api`、ルートの依存や解析の設定を変えた PR では、CI が生成し直した結果とコミット済みのものが一致するかを確かめます。

OpenAPI を使わない場合は、次を削除してください。

- [ ] `openapi` ディレクトリ
- [ ] [.github/workflows/wc-check-openapi.yaml] と、[.github/workflows/check-pr.yaml]、[.github/workflows/merge-queue.yaml]、[.github/workflows/wc-changes.yml] の `openapi` の記述
- [ ] `packages/mock_server` ディレクトリと、ルートの [pubspec.yaml] の `workspace` の `packages/mock_server`
- [ ] [mise.toml] の `mock` タスク
- [ ] [dprint.jsonc]、[cspell.jsonc]、[.gitattributes] の `packages/api` の行
- [ ] [docs/ARCHITECTURE.md] のディレクトリ構造の `openapi`、`packages/api`、`packages/mock_server` と、依存の図の `api`
- [ ] [docs/GET_STARTED.md] の「モックサーバーの起動」と、末尾の `[モックサーバー]` のリンク定義、[docs/MOCK_SERVER.md]

削除したあとに `mise bs` を実行し、更新された [.github/labeler.yml] と [.github/labels.yml] もコミットしてください。

<!-- Links -->

[OpenAPI Generator]: https://openapi-generator.tech/docs/generators/dart-dio/
[openapi/sample]: ../tree/main/openapi/sample
[openapi/mise.toml]: ../blob/main/openapi/mise.toml
[pubspec.yaml]: ../blob/main/pubspec.yaml
[dprint.jsonc]: ../blob/main/dprint.jsonc
[cspell.jsonc]: ../blob/main/cspell.jsonc
[.gitattributes]: ../blob/main/.gitattributes
[.github/labeler.yml]: ../blob/main/.github/labeler.yml
[.github/labels.yml]: ../blob/main/.github/labels.yml
[.github/workflows/wc-check-openapi.yaml]: ../blob/main/.github/workflows/wc-check-openapi.yaml
[.github/workflows/check-pr.yaml]: ../blob/main/.github/workflows/check-pr.yaml
[.github/workflows/merge-queue.yaml]: ../blob/main/.github/workflows/merge-queue.yaml
[.github/workflows/wc-changes.yml]: ../blob/main/.github/workflows/wc-changes.yml
[docs/ARCHITECTURE.md]: ../blob/main/docs/ARCHITECTURE.md
[docs/GET_STARTED.md]: ../blob/main/docs/GET_STARTED.md
[docs/MOCK_SERVER.md]: ../blob/main/docs/MOCK_SERVER.md
[packages/mock_server]: ../tree/main/packages/mock_server
