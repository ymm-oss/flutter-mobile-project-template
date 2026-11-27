---
title: "[初期セットアップ] アプリ配布方針"
labels:
  - initialization
  - required
---

# アプリ配布方針の策定

このIssueは、本プロジェクトにおけるアプリケーションの配布戦略と配布フローを決定し、その内容を `docs/APP_DISTRIBUTION.md` に文書化することを目的としています。

## 背景

モバイルアプリケーションの配布は、開発プロセスの重要な要素であり、適切な配布戦略を初期段階で定めることで、効率的なリリース管理とユーザーへの継続的な価値提供が可能になります。

プロジェクトには既に環境設定（dev/stg/prd）が存在し、CI/CD パイプラインとの連携を考慮した配布フローが必要です。

## Todo

プロジェクトの要件に基づき、以下のアプリ配布方針を決定し、ドキュメント化してください。

### 配布戦略の決定

- [ ] **配布チャネルの選定:**
  - iOS: App Store Connect, TestFlight, Firebase App Distribution等
  - Android: Google Play Console, Firebase App Distribution等
  - 各環境（dev/stg/prd）でどの配布チャネルを使用するかを決定

- [ ] **環境別配布方針:**
  - Development: 開発者向け内部配布の方法
  - Staging: QA・ステークホルダー向け検証配布の方法
  - Production: エンドユーザー向け配布の方法

### 配布フローの設計

- [ ] **自動化レベルの決定:**
  - GitHub Actions を使用したCI/CD統合の範囲

### 配布の認証方法

- [ ] **Android の配布の認証方法の決定:**
  - GitHub Actions から Google Play へアップロードするときは、サービスアカウントの JSON キーを Secrets に保存する方法ではなく、Workload Identity Federation（WIF）で認証することを推奨します。
    - JSON キーは既定では期限がなく、漏洩すると、そのキーの権限でアプリの公開まで操作されるおそれがあります。WIF ではジョブごとに期限の短い認証情報が発行されるため、Secrets に鍵を保存せずに済みます。
  - Google Play へのアップロードではサービスアカウントを作り、WIF で認証したジョブがそのサービスアカウントとして動く構成（impersonation）を推奨します。Play Console ではそのサービスアカウントのメールアドレスをユーザーとして招待し、アプリの権限を付けます。
    - `google-github-actions/auth` の README はサービスアカウントを使わない構成（Direct WIF）を優先していますが、Play Console はメールアドレスに権限を付けるため、ここではサービスアカウントを使います。
  - Firebase App Distribution（Android、iOS とも）でも、まず WIF を試すことを推奨します。選んだツールが WIF の認証情報で動くことを確かめられなかったときは、JSON キーを使う方法もあります。
  - Workload Identity プロバイダには必ず属性条件を付けます。付けないと、ほかのリポジトリのジョブでも認証が通ります。
    - 条件には `repository_owner_id` と `repository_id` を使うことを推奨します。リポジトリや Organization を消すと、ほかの人が同じ名前を取れるためです。リンク先の例は名前（`repository_owner` など）を使っているので、ID に置き換えます。
    - 配布するジョブは GitHub の Environment を使い、属性条件に `environment` も加えて、配布に使う Environment のジョブだけを通すことを推奨します。
    - dev、stg、prd で権限を変えるときは、Environment ごとにサービスアカウントを分けます。どの Environment がどのサービスアカウントを使えるかは、サービスアカウント側の IAM の設定で絞ります。
    - 条件で使う値は先に attribute mapping に追加します。
    - 古い記事にある `assertion.sub == 'repo:<owner>/<repo>:...'` の条件は、そのまま写すと一致しません。2026年7月15日より後に作ったリポジトリでは、`sub` に ID が入るためです。
  - アップロードに使うツールが、`google-github-actions/auth` が作る認証情報ファイル（パスは環境変数 `GOOGLE_APPLICATION_CREDENTIALS` に入ります）に対応しているかを確かめます。
  - 認証情報ファイルはワークスペースに作られます。`actions/checkout` を `auth` より先に実行し、`.gitignore` に `gha-creds-*.json` を足します。
  - 参考
    - [google-github-actions/auth](https://github.com/google-github-actions/auth)
    - [Security Considerations（google-github-actions/auth）](https://github.com/google-github-actions/auth/blob/main/docs/SECURITY_CONSIDERATIONS.md)
    - [Configure Workload Identity Federation with deployment pipelines（Google Cloud）](https://docs.cloud.google.com/iam/docs/workload-identity-federation-with-deployment-pipelines)
    - [fastlane supply](https://docs.fastlane.tools/actions/supply/)

- [ ] **iOS の配布の認証方法の決定:**
  - Apple の公式ドキュメントには WIF に当たる仕組みの説明が見つかりません。GitHub Actions から App Store Connect / TestFlight へアップロードするときは、App Store Connect API キー（`.p8`）で認証することを推奨します。
    - Apple ID とアプリ用パスワードでも認証できますが、個人のアカウントに結び付きます。
  - API キーは配布に使う GitHub の Environment の Secrets に保存し、配布するジョブだけが読めるようにします。必要な権限だけを持つロールを付け、漏洩したときはすぐに無効にします。
  - Firebase App Distribution で配布するときの認証は、Android の項と同じです。
  - 参考: [Creating API Keys for App Store Connect API（Apple）](https://developer.apple.com/documentation/appstoreconnectapi/creating-api-keys-for-app-store-connect-api)

- [ ] **ワークフローの安全対策:**
  - 本番に配布するジョブの Environment には、デプロイできるブランチやタグの制限を設定することを推奨します。この制限がないと、ワークフローを編集できる人は、どのブランチのジョブにもその Environment を指定できます。
  - 必須レビュアー（Required reviewers）と自己承認の禁止（Prevent self-review）も、使えるプランでは設定することを推奨します。
  - private リポジトリでは GitHub のプランによって使えない機能があります。Environment、Environment の Secrets、ブランチやタグの制限には GitHub Pro、Team、Enterprise のどれかが必要です。必須レビュアーには GitHub Enterprise が必要です。Environment を使えないときは、属性条件でブランチ（`ref`）に絞ります。
  - `id-token: write` は配布するジョブだけに付けます。
  - 外部からの PR のコードや成果物を扱うワークフロー（`pull_request_target` や `workflow_run` で動くもの）には、配布するジョブや `id-token: write` を入れないことを推奨します。
  - 参考: [Deployments and environments（GitHub Docs）](https://docs.github.com/en/actions/reference/workflows-and-actions/deployments-and-environments)

### ドキュメント化

- [ ] **配布方針ドキュメントの作成:**
  - `docs/APP_DISTRIBUTION.md` に決定した内容を文書化
  - 決定した配布の認証方法も含める

- [ ] **開発者向けガイドの作成:**
  - 配布前チェックリスト

**全てのタスクが完了したら、このIssueを閉じてください。**
