# マージキュー

## 概要

マージキューは、プルリクエストのマージを安全に管理するための GitHub 機能です。複数の PR が同時にマージされる際の競合リスクを軽減し、main ブランチの品質を維持するのに役立ちます。

詳細については [GitHub公式ドキュメント: マージキューの管理](https://docs.github.com/ja/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue) を参照してください。

## 使用方法

マージキューが有効になると、プルリクエストをマージする際に「**Confirm merge when ready**」ボタンが表示されます。このオプションを選択すると、プルリクエストはマージキューに追加され、[merge-queue.yaml](../.github/workflows/merge-queue.yaml) ワークフローによって処理されます。

## メリット

マージキューには以下のメリットがあります：

- **競合リスクの軽減**: 複数のPRが同時にマージされる際の競合問題を防ぎます
- **品質の維持**: マージ前に最新のmainブランチとマージした状態でCIチェックを実行します
- **自動化と標準化**: マージプロセスを自動化し、一貫した方法でコードをマージします

## 設定方法

リポジトリの設定で、以下の手順でマージキューを有効化します：

1. リポジトリの **`Settings` > `Rules` > `Rulesets`** タブに移動
2. **`New ruleset` > `New branch ruleset`** セクションを選択
   - 既存のルールセットがある場合は、既存のルールを編集してください
   - 新しいルールセットを作成する場合は、適切な名前を付けてください
3. **`Require merge queue`** を有効化

![merge-queue-check.png](./images/merge-queue-check.png)

## ワークフロー処理

マージキューに追加されたPRは、[merge-queue.yaml](../.github/workflows/merge-queue.yaml) ワークフローによって処理されます。このワークフローは [check-pr.yaml](../.github/workflows/check-pr.yaml) と同様の検証を行いますが、いくつかの重要な違いがあります。

### 主な特徴

- 最新の main ブランチとマージされた状態でチェックを行うため、予期せぬ競合を事前に発見できます
- check-pr と同じく、変更したファイルに関係するチェックだけを実行します

merge queue で実行しないチェックと、生成コードのチェック（diff-gen）の対象の違いは、[CI](./CI.md) を参照してください。

すべてのチェックが成功した場合のみ、PR は main ブランチに自動的にマージされます。
