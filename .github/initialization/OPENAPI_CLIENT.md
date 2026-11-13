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
openapi/<api_name>/
  configs/dart-dio.yaml        # ジェネレーターのオプション
  scripts/generate-client.sh   # 生成スクリプト
  templates/                   # 既定のテンプレートを上書きするファイル
  openapi.yaml                 # 仕様書
```

生成スクリプトは、ディレクトリ名の `<api_name>` を API 名として、`packages/api/<api_name>` に `internal_api_<api_name>` パッケージを生成します。
API が複数ある場合は、API ごとにディレクトリを分けてください。

OpenAPI Generator と、その実行に必要な Java のバージョンは [mise.toml] で固定しています。

## Todo

- [ ] `openapi/sample` を `openapi/<api_name>` に改名する
  - `<api_name>` は Dart のパッケージ名に使うため、`snake_case` にする
- [ ] `openapi/<api_name>/openapi.yaml` をプロジェクトの仕様書に差し替える
- [ ] `openapi/<api_name>/configs/dart-dio.yaml` の `pubDescription` を書き換える
- [ ] クライアントを生成する

  ```shell
  mise install
  openapi/<api_name>/scripts/generate-client.sh
  ```

- [ ] ルートの [pubspec.yaml] の `workspace` に `packages/api/<api_name>` を追加する
- [ ] 依存関係を解決し、`*.g.dart` を生成する

  ```shell
  mise bs
  dart run melos run gen:build
  ```

- [ ] 生成した `packages/api/<api_name>` と、`mise bs` が更新した [.github/labeler.yml] と [.github/labels.yml] をコミットする
- [ ] [docs/ARCHITECTURE.md] に、生成したパッケージをどのパッケージから使うかを追記する

仕様書を更新したときは、生成スクリプト、`mise bs`、`dart run melos run gen:build` を同じ順で実行してください。

OpenAPI を使わない場合は、次を削除してください。

- [ ] `openapi` ディレクトリ
- [ ] [mise.toml] の `java` と `aqua:OpenAPITools/openapi-generator`（削除後に `mise lock` を実行する）
- [ ] [dprint.jsonc]、[cspell.jsonc]、[.gitattributes] の `packages/api` の行
- [ ] [docs/ARCHITECTURE.md] の `openapi` と `packages/api` の行

<!-- Links -->

[OpenAPI Generator]: https://openapi-generator.tech/docs/generators/dart-dio/
[openapi/sample]: ../tree/main/openapi/sample
[mise.toml]: ../blob/main/mise.toml
[pubspec.yaml]: ../blob/main/pubspec.yaml
[dprint.jsonc]: ../blob/main/dprint.jsonc
[cspell.jsonc]: ../blob/main/cspell.jsonc
[.gitattributes]: ../blob/main/.gitattributes
[.github/labeler.yml]: ../blob/main/.github/labeler.yml
[.github/labels.yml]: ../blob/main/.github/labels.yml
[docs/ARCHITECTURE.md]: ../blob/main/docs/ARCHITECTURE.md
