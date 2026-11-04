# Model Context Protocol (MCP) Server

## 概要

Model Context Protocol (MCP) は、AIアシスタントがローカル環境やクラウドサービスと安全に対話するためのプロトコルです。以下のような特徴があります：

- AIアシスタントが外部ツールやサービスを利用可能
- 標準化されたインターフェースによる安全な操作
- 拡張可能なツールセットの提供

MCPサーバーは、特定のドメインやサービス（Git、GitHub等）に対して、AIアシスタントが実行可能な操作を提供します。各サーバーは独自の機能セットを持ち、それらを安全に実行するための仕組みを提供します。

本ドキュメントでは、

- [GitHub MCP Server](#github-model-context-protocol-mcp-server)
- [git MCP Server](#git-model-context-protocol-mcp-server)

の設定方法を記載する。

## 前提条件

> [!Note]
> Cursor で使用されることを想定しています。

1. プロジェクトの要件に応じ、有効化する`MCP Server`を選定し、以後の作業を実施する
2. [mcp.sample.json] を `mcp.json` にファイル名を変更する
3. 後述する各種`MCP Server`の設定値を変更する
4. `Cursor`の設定から必要な`MCP Server`のみを有効化する

## 利用上の注意点

### プライバシーとセキュリティ

- AIアシスタントとのやり取りでも機密情報の共有は避けてください

### 権限の制限

- MCP Server はユーザーに付与されたGitHub権限の範囲内でのみ操作が可能です
- 組織のリポジトリへのアクセスには適切な権限が必要です

### コミュニケーションのベストプラクティス

- 明確で具体的な指示を出すことで、意図した操作が行われやすくなります
- 複雑な操作は、段階的に指示することをおすすめします

## GitHub Model Context Protocol (MCP) Server

### GitHub MCP Server 概要

GitHub MCP Server はAIアシスタントからGitHubリポジトリを操作するための機能です。以下のような操作が可能です

- プルリクエストの作成・更新・マージ
- イシューの作成・更新・コメント
- コードのレビュー

その他の機能については、[GitHub's official MCP Server] をご覧ください。

### GitHub MCP Server 有効化

1. Personal Access Token （PAT）を取得する （[個人用アクセス トークンを管理する]）
   - プライベートリポジトリを操作する場合: `repo` スコープ（「プライベートリポジトリの完全な制御」）を選択
   - パブリックリポジトリのみを操作する場合: `public_repo` スコープのみを選択
2. `"<YOUR_TOKEN>"` を取得した PAT に書き換える
3. 現在 v0.3.0 の Github MCP Server を使用していますが、必要であれば別のバージョンハッシュ値に書き得てください（不要であればスキップ）

### PR の作成

Cursor の Chat でプルリクエストの作成を依頼してください。手順は [pr-creation] スキルにあります。

## git Model Context Protocol (MCP) Server

### git MCP Server 概要

Git MCP Server はAIアシスタントからGitコマンドを操作するためのツールです。以下のような操作が可能です

- Git リポジトリの状態確認（status、diff、log の表示）
- ファイルの変更管理（add、commit、reset の操作）
- ブランチ操作（作成、切り替え、初期化）

### git MCP Server 有効化

1. `servers`リポジトリをcloneする

   ```bash
   git clone -b 2025.4.24 https://github.com/modelcontextprotocol/servers.git
   ```

   ※ 本ドキュメントでは、[2025.4.24] tagを指定し`clone`するが、状況に応じて臨機応変にtagを更新してください
2. `<GIT_DOCKER_PATH>`を1でcloneしたリポジトリの`servers/src/git/Dockerfile`までの相対パスもしくは絶対パスを指定する

## 参考

- [GitHub's official MCP Server]
- [git README]

<!-- URLs -->

[mcp.sample.json]: ../.cursor/mcp.sample.json
[GitHub's official MCP Server]: https://github.com/github/github-mcp-server
[個人用アクセス トークンを管理する]: https://docs.github.com/ja/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens
[pr-creation]: ../.agents/skills/pr-creation/SKILL.md
[2025.4.24]: https://github.com/modelcontextprotocol/servers/releases/tag/2025.4.24
[git README]: https://github.com/modelcontextprotocol/servers/tree/2025.4.24/src/git
