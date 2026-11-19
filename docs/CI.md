# CI

このドキュメントでは、GitHub Actions のワークフローの全体像と、PR と merge queue で実行する検査の違いを説明します。

## ワークフロー

| ワークフロー                    | 内容                                          |
| ------------------------------- | --------------------------------------------- |
| [check-pr.yaml]                 | PR の検査                                     |
| [merge-queue.yaml]              | merge queue での検査                          |
| [create-cache.yaml]             | 既定ブランチの mise と pub のキャッシュの作成 |
| [auto-assign.yaml]              | レビュアーと担当者の設定                      |
| [labeler.yml]                   | 変更したパッケージのラベルの付与              |
| [labels.yml]                    | リポジトリのラベルの同期（PR では dry-run）   |
| [pr-rebase-detector.yaml]       | rebase や force push の検知                   |
| [github-pages-pull-request.yml] | catalog の GitHub Pages へのデプロイ          |
| [issue-dependabot.yml]          | 更新できるパッケージの Issue へのコメント     |
| [issue-vulnerabilities.yaml]    | 脆弱性の Issue 化                             |
| [initialization.yaml]           | テンプレートから作ったリポジトリの初期化      |

ファイル名が `wc-` で始まるワークフローは、上のワークフローから `workflow_call` で呼ぶ部品です。

## 実行するジョブを決める条件

check-pr と merge-queue は、最初に [wc-changes.yml] で変更したファイルを調べ、関係するジョブだけを実行します。changes の後にほかのジョブを並列に実行し、最後に status-check を実行します。check-pr の check-secrets は changes を待たずに始まります。

| フィルタ          | 使うジョブ                            |
| ----------------- | ------------------------------------- |
| `actions`         | check-actions、check-actions-security |
| `src`             | analyze、check、test                  |
| `gen`             | diff-gen、check-dependencies          |
| `dprint`          | check-style-dprint                    |
| `spell`           | check-code-spell                      |
| `ai_skills`       | check-ai-skills                       |
| `vulnerabilities` | check-vulnerabilities                 |

各フィルタの対象のファイルは [wc-changes.yml] を参照してください。ジョブの結果に関わるファイルは、そのジョブのフィルタに含めてください。含めないと、そのファイルだけを変えた PR ではジョブがスキップされ、検査されないまま通ります。

changes、check-secrets、status-check はフィルタを使わず、常に実行します。skip-comment は、どのフィルタにも当てはまらないときに実行します。

ブランチの保護ルールで必須にしているのは `status-check` だけです（[ブランチ運用ルールのステータスチェック](./BRANCH.md#ステータスチェック)）。`status-check` は、ほかのすべてのジョブが成功かスキップであることを確かめます。ジョブを追加したら、`status-check` の `needs` にも加えてください。加えないと、そのジョブが失敗してもマージできます。

check-pr.yaml と merge-queue.yaml は、同じジョブをそれぞれに定義しています。両方で実行するジョブを変えるときは、両方を変えてください。

## check-pr と merge queue の違い

merge queue は、最新の `main` に PR をマージした状態で検査します。PR の時点から変わりうる結果を確かめることが目的です。

### merge queue で実行しないジョブ

- skip-comment、check-dependencies: PR にコメントするジョブで、merge queue には PR がないため実行しません。
- check-secrets: PR のベースから先端までのコミットを検査するジョブで、PR で検査済みのコミットだけが merge queue に入るため実行しません。
- check-style-dprint、check-code-spell: check-pr でだけ検査します。

### diff-gen の対象

check-pr の diff-gen は、既定ブランチとの差分があるパッケージだけを生成します（`melos run gen:diff:default`）。merge queue の diff-gen は、全パッケージを生成します（`melos run gen`）。

melos の `diff` フィルタは、ファイルが変わったパッケージだけを選びます。たとえば、ルートの `pubspec.lock` だけが変わる生成器の更新では、どのパッケージも選ばれず、古い生成コードのまま check-pr を通ります。merge queue で全パッケージを生成して、こうした漏れを止めます。

## melos bootstrap を省くジョブ

analyze、check、test は、[Setup Application Runtime] の `bootstrap-workspace: false` で `melos bootstrap` を省きます。bootstrap が生成し直すファイル（`pubspec.yaml` の共通の依存、`analysis_options.yaml` の `include:`）が最新であることは、bootstrap を実行する diff-gen が確かめます。

この分担を保つため、次の点を守ってください。

- bootstrap の入力（`pubspec.yaml`、`pubspec.lock`、`analysis_options.yaml`、`tools/` の Dart ファイル）は、diff-gen の `gen` フィルタに含めてください。含めないと、古いファイルが diff-gen をすり抜け、analyze が古い設定のまま通ります。
- コミットしない生成物で、analyze、check、test が使うものを bootstrap の post フックに足すときは、それらのジョブでも bootstrap を実行してください。

create-cache も `bootstrap-workspace: false` で `melos bootstrap` を省きます。キャッシュに入れる Flutter tool と pub のパッケージは、bootstrap の前の `flutter pub get` までにそろうためです。

## キャッシュ

mise と pub のキャッシュは [Setup Application Runtime]、build_runner のキャッシュは [wc-check-diff.yaml] で扱います。

GitHub Actions のキャッシュは、PR で保存したものはその PR からしか読めません。PR と merge queue の実行が共通して読めるのは、既定ブランチで保存したキャッシュです（[Restrictions for accessing a cache]）。そのため、mise と pub のキャッシュは [create-cache.yaml] から既定ブランチでだけ保存し、PR と merge queue はそれを復元します。保存するのは、Setup Application Runtime の `save-cache` が `true` で、既定ブランチで動いたときだけです。mise はジョブの終わりに保存し、最初の `flutter` で作られる Flutter tool もキャッシュに入れます。

mise のキャッシュのキーは 30 日ごとに変わるため、create-cache.yaml は毎日の schedule でも動きます。mise と pub のキャッシュのキーに使うファイルは、create-cache.yaml の `paths` に含めてください。含めないと、そのファイルが変わっても次の schedule まで既定ブランチのキャッシュが作り直されず、PR と merge queue がキャッシュに当たらなくなります。

[auto-assign.yaml]: ../.github/workflows/auto-assign.yaml
[check-pr.yaml]: ../.github/workflows/check-pr.yaml
[create-cache.yaml]: ../.github/workflows/create-cache.yaml
[github-pages-pull-request.yml]: ../.github/workflows/github-pages-pull-request.yml
[initialization.yaml]: https://github.com/ymm-oss/flutter-mobile-project-template/blob/main/.github/workflows/initialization.yaml
[issue-dependabot.yml]: ../.github/workflows/issue-dependabot.yml
[issue-vulnerabilities.yaml]: ../.github/workflows/issue-vulnerabilities.yaml
[labeler.yml]: ../.github/workflows/labeler.yml
[labels.yml]: ../.github/workflows/labels.yml
[merge-queue.yaml]: ../.github/workflows/merge-queue.yaml
[pr-rebase-detector.yaml]: ../.github/workflows/pr-rebase-detector.yaml
[Restrictions for accessing a cache]: https://docs.github.com/en/actions/reference/workflows-and-actions/dependency-caching#restrictions-for-accessing-a-cache
[Setup Application Runtime]: ../.github/actions/setup-application-runtime/action.yaml
[wc-changes.yml]: ../.github/workflows/wc-changes.yml
[wc-check-diff.yaml]: ../.github/workflows/wc-check-diff.yaml
