# GitHub Copilot

> [!NOTE]
> このドキュメントはゆめみ社内専用ドキュメント「[ChatGPTをはじめとするAIサービスの利用方針・ルール・ガイドライン](https://www.notion.so/yumemi/ChatGPT-AI-f951c2e2542e4db5af72386329e23155)」をもとに作成されました。
> ゆめみ社内の方ははじめにそちらのガイドラインをご確認ください。

## 生成AI全般のリスク

生成AI全般には以下のようなリスクがあるので注意が必要になります。使用する際は関係者と十分な認識合わせを行う必要があります。

### 著作権法上のリスク

自動生成されたソースコードが、他者のソースコードの著作権を侵害する可能性があります。

### セキュリティ上のリスク

安全でないコーディングパターンやバグ、古いAPIやライブラリの使用など、セキュリティ上のリスクがあるコードが生成される可能性があります。

### プライバシー上のリスク

機密情報や個人情報が学習され、その情報が第三者に表示されることが懸念されています。
それらツールがプロジェクトからどのような情報を収集して学習に利用しているかに注意する必要があります。

## GitHub Copilotのリスク

GitHub Copilotは、サブスクリプションを設定することで使用できるようになります。
サブスクリプションは以下のように個人用と組織用(OrganizationまたはEnterprise)があります。それぞれプライバシーポリシーが異なるので注意が必要です。

- [GitHub Copilot Individual(個人用)](https://docs.github.com/ja/copilot/overview-of-github-copilot/about-github-copilot-individual)
- [GitHub Copilot Business(組織用)](https://docs.github.com/ja/copilot/overview-of-github-copilot/about-github-copilot-business)

### IDEの拡張機能としてのリスク

GitHub Copilot拡張機能を有効化する範囲は、IDEによって異なるので注意が必要です。
VSCodeとXcodeではプロジェクト単位で有効にすることが可能ですが、これ以外のIDEではプロジェクト単位で制御できないため、誤ってCopilotが動作しないように注意する必要があります。

## Copilotの使い方

### VSCode

1. VSCodeへ[GitHub Copilotの拡張機能](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)をインストールする
2. Copilot拡張機能を無効にして、VSCode全体ではCopilotが動かないようにする
3. 任意のワークスペースを開き、そのワークスペースのみでCopilot拡張機能を有効にする
4. ワークスペースの設定（`.vscode/settings.json`）に以下のGitHub Copilot設定を追加する

   ```jsonc
   {
     "github.copilot.enable": {
       // Copilotを有効にする言語を指定する
       "*": false,
       "dart": true
     },
     "github.copilot.editor.enableCodeActions": true,
     "github.copilot.editor.enableAutoCompletions": true
   }
   ```

5. (オプション) VSCode全体の設定(`settings.json`)で、Copilotを無効にする

```json
{
  "github.copilot.enable": {
    "*": false
  },
  "github.copilot.editor.enableCodeActions": false,
  "github.copilot.editor.enableAutoCompletions": false
}
```

VSCode - Programming Languages Overview
<https://code.visualstudio.com/docs/languages/overview>

VSCodeがサポートしている言語一覧
<https://code.visualstudio.com/docs/languages/identifiers>

> [!NOTE]
> すでにこの設定はプロジェクトに適応されてますが、
> GitHubのテンプレート機能使用してリポジトリを作った際に、
> 設定は無効化されるように上書きするワークフローが実行されます

### Xcode

1. [Copilot for Xcode](https://github.com/intitni/CopilotForXcode)をインストールする
2. READMEに従い、Copilot for Xcodeを有効化する
3. Copilot for Xcodeアプリを開き、`Featureタブ`内の`Disable Suggestion Feature Globally`を有効化する
4. 手順3の隣の`Exception List`をクリックして、Copilotを有効化したいプロジェクトパスを追加する

## プロジェクトのスキル

GitHub Copilot は、このリポジトリの `.agents/skills/` をプロジェクトのスキルとして読みます。配置先を追加する設定は不要です。スキルの追加方法と Claude Code 向けの symlink は [AI スキルの配置] を参照してください。

## 参考

<https://docs.github.com/ja/copilot>

[AI スキルの配置]: AI_SKILLS.md
