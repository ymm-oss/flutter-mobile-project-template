---
title: "[初期セットアップ] Merge Queue を導入"
labels: initialization
---

# マージキューの設定

GitHubのマージキュー機能を設定して、 PR のマージプロセスを効率化します。

## 背景

マージキューは複数の PR が同時にマージ待ちになっている場合に、CI 検証を並行して行いながら順番にマージを行う機能です。

これにより：

- CI/CD 処理の重複実行を減らせます
- マージ競合のリスクを軽減できます
- PR のマージプロセスが自動化され、効率的になります

## 設定手順

### 前提条件

- ブランチ保護ルールは、プロジェクトの方針に従って設定してください。
- その他、ステータスチェックなどに関する内容は [`docs/BRANCH.md`](../blob/main/docs/BRANCH.md) を参照してください。

### 設定

1. **ブランチ保護ルール**：
   - リポジトリの **Settings > Rules > Rulesets** に移動
   - **New rulesets > New branch rules** をクリック
     - ※ 既にルールセットがある場合は、既存のルールを編集してください
   - 「Require merge queue」を有効化
     - ※ 必要に応じて、他のオプションも設定

2. **ドキュメント**：
   - 概要は [`docs/MERGE_QUEUE.md`](../blob/main/docs/MERGE_QUEUE.md)を参照してください。

## 参考リンク

- [GitHub公式ドキュメント: マージキューの管理](https://docs.github.com/ja/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue)
