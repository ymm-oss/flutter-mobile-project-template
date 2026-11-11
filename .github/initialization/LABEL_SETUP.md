---
title: "[初期セットアップ] Issue と Pull Request のラベルを整理する"
labels: initialization
---

## 概要

このプロジェクトでは、リポジトリのラベルを [.github/labels.yml] で管理しています。

[.github/labels.yml] を変更して main に push すると、[.github/workflows/labels.yml] のワークフローが定義どおりにラベルを作成・更新します。
**定義にないラベルはリポジトリから削除される** ため、GitHub の画面で直接ラベルを作った場合も、[.github/labels.yml] に追記してください。

テンプレートの初期状態のラベルは、プロジェクトの運用に合わない場合があります。
プロジェクトの運用に合わせて、ラベルを整理してください。

## 現在のラベル

| ラベル                                                                                                                  | 使われている場所                                                               |
| ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| `bug` / `feature` / `improve` / `triage`                                                                                | [Issue テンプレート] で Issue を作成したときに付く                             |
| `initialization` / `optional`                                                                                           | 初期セットアップの Issue（この Issue など）に付く                              |
| `package_update`                                                                                                        | [.github/workflows/issue-dependabot.yml] が作成する Issue に付く               |
| `@apps/...` / `@packages/...` などのパッケージ名                                                                        | [.github/labeler.yml] によって、変更したパッケージに応じて Pull Request に付く |
| `documentation` / `duplicate` / `enhancement` / `good first issue` / `help wanted` / `invalid` / `question` / `wontfix` | GitHub のデフォルトのラベル                                                    |

パッケージ名のラベルは `# <!-- This is an auto-generated label -->` の行より下にあり、パッケージを追加・削除したときに次のコマンドで更新します。

```shell
dart run melos run gen:labels
dart run melos run gen:labeler
```

## Todo

- [ ] 使わないラベルを [.github/labels.yml] から削除する
  - [Issue テンプレート] やワークフローで使っているラベルを削除する場合は、そちらも合わせて変更する
- [ ] プロジェクトで必要なラベルがあれば [.github/labels.yml] に追加する
  - 自動生成の行より上に追加する
- [ ] [Issue テンプレート] で付けるラベルを、プロジェクトの運用に合わせて見直す
- [ ] 変更を main にマージし、[.github/workflows/labels.yml] のワークフローが成功したことを確認する

<!-- Links -->

[.github/labels.yml]: /.github/labels.yml
[.github/labeler.yml]: /.github/labeler.yml
[.github/workflows/labels.yml]: /.github/workflows/labels.yml
[.github/workflows/issue-dependabot.yml]: /.github/workflows/issue-dependabot.yml
[Issue テンプレート]: /.github/ISSUE_TEMPLATE
