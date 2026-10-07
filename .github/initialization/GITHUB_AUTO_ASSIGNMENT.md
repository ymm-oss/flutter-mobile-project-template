---
title: "[初期セットアップ] Pull Requestのレビュワーを自動アサインする設定"
labels: initialization
---

## 概要

このプロジェクトでは、Pull Request 作成時に自動でレビュアーをアサインするGitHubワークフローが用意されています。

現状のワークフローでは、適切なGitHubアクセストークンを設定する必要があります。

> [!NOTE]
> 人数が少なく、GitHubチームでレビュアーに指定しない場合は [hkusu/review-assign-action] を利用してもよいです

## 設定方法

> [!NOTE]
> 権限がなかったり、顧客に設定を依頼するなどで**自分で設定できない場合**、FlutterギルドのOwnersに相談してください。

### 1. GitHubアクセストークンの設定

[.github/workflows/auto-assign.yaml] 内の
`jobs.request-reviewers`の`Generate a token`のstepに、トークンを生成するGitHubアプリの適切な`client-id`と`private-key`を設定してください。

トークンを生成するGitHubアプリがない場合は作成してください。

```yaml
  request-reviewers:
    ...

    steps:
      - name: Generate a token
        id: app-token
        uses: actions/create-github-app-token@vX.X.X
        with:
          client-id: #適切な値を設定する
          private-key: #適切な値を設定する
```

### 2. GitHubリポジトリ環境変数の設定

GitHubリポジトリ環境変数に`REVIEWERS`と`TEAM_REVIEWERS`を設定してください。（[GitHub Variables]を参照）

以下のようにカンマ区切りで複数指定することができます。

- `REVIEWERS`: `username1,username2,username3`
- `TEAM_REVIEWERS`: `team1,team2,team3`

<!-- Links -->

[hkusu/review-assign-action]: https://github.com/hkusu/review-assign-action
[.github/workflows/auto-assign.yaml]: /.github/workflows/auto-assign.yaml
[GitHub Variables]: https://docs.github.com/en/actions/learn-github-actions/variables
