---
title: "[初期セットアップ] 開発ツールのバージョン指定"
labels: initialization
---

# 開発ツールのバージョン指定

このIssueは、プロジェクトで使用する主要な開発ツールのバージョンを明確にし、チームメンバー間での環境差異を最小限に抑えるためのものです。開発環境の一貫性は、予期せぬビルドエラーや動作の違いを防ぐために重要です。

## 背景

プロジェクトで使用する各ツールのバージョンを固定または推奨することで、開発の安定性と再現性を高めます。`mise` のようなツールバージョンマネージャーを使用することで、プロジェクトごとのツールバージョン管理が容易になります。

### `mise` のバージョンに関して

プロジェクトのツールバージョン管理には `mise` を使用します。`mise` 自体のバージョンも開発環境の一貫性に影響を与えるため、確認方法と管理方針を以下に示します。

- **mise (Tool Version Manager)**:
  - 確認: `mise --version`
  - インストール: 各開発者の環境にインストールします（例: Homebrew, 公式インストーラー経由）。
  - 管理: `mise.toml` の `min_version` で、このプロジェクトに必要な `mise` の下限を宣言します。これより古い `mise` では、更新を促すエラーで止まります。`mise.lock` の形式を読めるバージョン以上にしてください。

### ツールバージョン管理の方針

本プロジェクトでは、バージョン管理を以下のカテゴリに分けて行います。

1. **`mise` で管理するグローバルなCLIツール**: プロジェクトルートの `mise.toml` でバージョンを指定します。
2. **`package.json` で管理する Node.js パッケージ**: プロジェクトルートの `package.json` の `devDependencies` でバージョンを指定します。
3. **プラットフォーム固有のツールとSDK**: 各プラットフォームの標準的な方法やプロジェクト固有のネイティブ設定ファイルで管理します。

## `mise` で管理するツール

以下のツールは `mise.toml` ファイルでバージョンが指定されます。
取得物の URL とチェックサムは `mise.lock` に記録され、CI はこのファイルと一致するものだけをインストールします。
`mise install` コマンドを実行することで、これらのツールが自動的に適切なバージョンでインストールされます。(一部抜粋)

- **Flutter SDK** (Dart SDK を含む):
  - 確認: `flutter --version`, `dart --version`
  - 管理: `flutter = "x.y.z"` を記述
- **Bun (JavaScript Runtime & Toolkit)**:
  - 確認: `bun --version`
  - 管理: `bun = "x.y.z"` を記述
- **dprint (Code Formatter)**:
  - 確認: `dprint --version`
  - 管理: `dprint = "x.y.z"` を記述
  - 設定: `dprint.jsonc`

## `package.json` で管理する Node.js パッケージ

以下のツールは `package.json` の `devDependencies` でバージョンが指定され、`bun install --ignore-scripts` コマンドでインストールされます。(一部抜粋)

- **cspell (Spell Checker)**:
  - 確認: `bun run cspell --version`
  - 管理: `package.json`
  - 設定: `cspell.jsonc`
- **commitlint (Commit Message Linter)**:
  - 確認: `bun run commitlint --version`
  - 管理: `package.json`
  - 設定: `.commitlintrc.yaml`
- **Husky (Git Hooks Manager)**:
  - 管理: `package.json`
  - 設定: `.husky/`

## プラットフォーム固有のツールとSDK

### iOS

- **Xcode (iOS開発用IDE)**:
  - 確認: Xcodeアプリ "About Xcode", CLI `xcodebuild -version`
  - 管理:
    - App Store または Apple Developer サイトからインストール。
    - [xcodes] による指定。
- **CocoaPods (iOS依存関係管理)**:
  - 確認: `pod --version`
  - 各個人のインストール状況に依存します。

### Android

- **Android Studio (Android開発用IDE)**:
  - 確認: Android Studio "About Android Studio".
  - 管理: Android Studio公式サイトからインストール。

## Todo

プロジェクトの安定運用のために、以下のツールのバージョンを決定・確認し、チームメンバーが参照できるようにドキュメント化してください。

- 確認リスト
  - [ ] `mise` 自体のバージョン確認・推奨
    - [ ] `mise.toml` の `min_version` の確認・更新
    - [ ] `mise.toml` の `[tools]` の確認・更新と、`mise.lock` の更新
  - [ ] `package.json` の `devDependencies` 確認・更新:
  - [ ] Xcode バージョンの指定:
    - [ ] CocoaPods バージョンの指定
  - [ ] Android Studio バージョンの指定

- [ ] プロジェクトの `README.md` や開発環境構築ガイドなどに、上記のツールバージョン情報および設定方法を集約して記載。

## 注意点

- **CI/CD 環境との整合性**: GitHub Actions などのCI/CD環境で使用するツールのバージョンも、ローカル開発環境と可能な限り一致させることが重要です。
- **アップデート方針**: ツールのメジャーバージョンアップやセキュリティアップデートに追従するための方針をチームで話し合っておくと良いでしょう。

**全てのタスクが完了したら、このIssueを閉じてください。**

<!-- Links -->

[xcodes]: https://github.com/XcodesOrg/xcodes
