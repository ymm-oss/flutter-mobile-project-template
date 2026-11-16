---
title: "[初期セットアップ（任意）] プルリクエスト方針策定"
labels:
  - initialization
  - optional
---

# [初期セットアップ] プルリクエスト方針策定

## 目的

このプロジェクトにおけるプルリクエスト（PR）の運用方針を決定し、チーム全体で一貫した開発プロセスを確立する。

## 背景

- テンプレートプロジェクトには PR リベース検出ワークフロー（`.github/workflows/pr-rebase-detector.yaml`）が含まれています
- プロジェクトの特性やチームの運用方針によって、最適なPR管理方法は異なります
- 初期段階で明確な方針を定めることで、後の混乱を防ぎ開発効率を向上させます

## 検討事項

### PRリベース検出ワークフローの取り扱い

- このワークフローを**維持する**か**削除する**か
- 維持する場合の運用ルール（警告発生時の対応フロー等）
- 削除する場合の代替ルールの策定

> [!NOTE]
> その他、PR 運用ポリシーやレビュープロセス等はプロジェクトの特性に応じて策定する必要があります。

## 成果物

- PR運用方針ドキュメントの追加編集（`docs/PR_GUIDELINES.md`等）
- 必要に応じたワークフローの調整

## 関連資料

- [workflows/pr-rebase-detector.yaml](../blob/main/.github/workflows/pr-rebase-detector.yaml)
- [PR_GUIDELINES.md](../blob/main/docs/PR_GUIDELINES.md)
