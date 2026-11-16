# Initialization Issues

このディレクトリには、Yumemi Flutter プロジェクトテンプレートの初期化に必要なタスクのマークダウンファイルが含まれています。

## 自動Issue作成システム

各マークダウンファイルには YAML frontmatter でメタデータが設定されており、GitHub Actions によって自動的にIssueが作成されます。

### マークダウンファイルの構造

```markdown
---
title: "[初期セットアップ] タスクのタイトル"
labels: |
  initialization
  optional
---

# タスクの内容

ここにタスクの詳細を記述...
```

### メタデータフィールド

- `title`: GitHubのIssueタイトルとして使用される
- `labels`: Issueに付与するラベル（文字列または配列形式）

### 新しいタスクの追加方法

1. `.github/initialization/` ディレクトリに新しいマークダウンファイルを作成
2. YAML frontmatter でメタデータを設定

### リポジトリ内のファイルへのリンク

このディレクトリのファイルは Issue の本文になるため、リポジトリ内のファイルへのリンクは Issue の URL を基準にした相対パスで書きます。

```markdown
[docs/BRANCH.md](../blob/main/docs/BRANCH.md)
[Issue テンプレート](../tree/main/.github/ISSUE_TEMPLATE)
```

`../../docs/BRANCH.md`（ファイルからの相対パス）や `/docs/BRANCH.md`（リポジトリのルートからのパス）は、Issue 上では別の URL に解決されてリンク切れになります。
