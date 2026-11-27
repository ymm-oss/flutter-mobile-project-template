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

#### Dependabotのシークレットの設定

Dependabotが作成したPull Requestから動くワークフローには、Actionsのシークレットが渡されず、Dependabotのシークレットだけが渡されます。（[Dependabotのシークレット]を参照）

そのため、`client-id`と`private-key`に渡す値は、Actionsのシークレットに加えて、Dependabotのシークレットにも登録してください。

- シークレットの名前は、ワークフローが`secrets.<名前>`で参照している名前と同じにしてください。
  - テンプレートの初期状態では`CLIENT_ID_OF_YMM_OSS_TEAM_REVIEW_REQUESTER`と`APP_PRIVATE_KEY_OF_YMM_OSS_TEAM_REVIEW_REQUESTER`です。
- 登録先は、Organizationとリポジトリのどちらでも構いません。（[Dependabotのシークレットの登録方法]を参照）
  - Organization: Organizationの`Settings` > `Secrets and variables` > `Dependabot`で登録します。`Repository access`で、このリポジトリを対象に含めてください。
  - リポジトリ: リポジトリの`Settings` > `Secrets and variables` > `Dependabot`で登録します。
- 登録済みのシークレットの値は、あとから読み出せません。秘密鍵が手元にない場合は、GitHubアプリで秘密鍵を発行し直してください。

> [!WARNING]
> Dependabotのシークレットに登録しないと、Dependabotが作成したPull Requestで`request-reviewers`ジョブが失敗します。
> `Generate a token`のstepで、次のエラーが出ます。
>
> ```text
> The 'client-id' (or deprecated 'app-id') input must be set to a non-empty string. If using a secret or variable, ensure it is available in this workflow context.
> ```

登録したあと、Dependabotが作成したPull Requestで`request-reviewers`ジョブが成功し、レビュアーがアサインされることを確認してください。
登録する前に失敗したジョブがある場合は、そのジョブを再実行して確認できます。再実行しても、Dependabotのシークレットが使われます。

### 2. GitHubリポジトリ環境変数の設定

GitHubリポジトリ環境変数に`REVIEWERS`と`TEAM_REVIEWERS`を設定してください。（[GitHub Variables]を参照）

以下のようにカンマ区切りで複数指定することができます。

- `REVIEWERS`: `username1,username2,username3`
- `TEAM_REVIEWERS`: `team1,team2,team3`

<!-- Links -->

[hkusu/review-assign-action]: https://github.com/hkusu/review-assign-action
[.github/workflows/auto-assign.yaml]: ../blob/main/.github/workflows/auto-assign.yaml
[GitHub Variables]: https://docs.github.com/en/actions/learn-github-actions/variables
[Dependabotのシークレット]: https://docs.github.com/en/code-security/dependabot/troubleshooting-dependabot/troubleshooting-dependabot-on-github-actions#accessing-secrets
[Dependabotのシークレットの登録方法]: https://docs.github.com/en/code-security/dependabot/working-with-dependabot/configuring-access-to-private-registries-for-dependabot#storing-credentials-for-dependabot-to-use
