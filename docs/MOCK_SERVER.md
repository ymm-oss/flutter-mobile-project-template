# モックサーバー

[packages/mock_server] のモックサーバーは、OpenAPI の仕様書（`openapi/<api_name>/openapi.yaml`）の `example` を返します。

## 起動

次のコマンドで起動します。

```shell
mise run mock
```

`openapi` に API が複数あるときは、`mise run mock <api_name>` で API 名を指定してください。

- ポートは `mise run mock --port 4011` のように変えられます。Firebase Local Emulator Suite の UI も既定で 4000 を使うため、同時に動かすときは別のポートにしてください。
- 使い方は `mise run mock -- --help` で表示します。`--` を付けないと、mise が `--help` を受け取ります。
- 仕様書を変えたときは、モックサーバーを起動し直してください。

## アプリからの接続

モックサーバーの URL は `http://127.0.0.1:4000` に仕様書の `servers` の 1 つ目の URL のパスを付けたものです。たとえば `servers` の URL が `https://api.example.com/v1` なら `http://127.0.0.1:4000/v1` になります。起動時にもこの URL を表示します。

実行構成 `mock-debug` でアプリを起動すると、`apiBaseUrl` は `http://127.0.0.1:4000` になります。アプリ ID などのほかの値は `dev-debug` と同じため、端末では同じアプリとして入れ替わり、保存したデータも引き継がれます。生成したクライアントの接続先に `BuildConfig.apiBaseUrl` を渡していれば、モックサーバーにつながります。モックサーバーのポートを変えたときは、[.vscode/launch.json] と [.idea/runConfigurations/mock_debug.xml] の `mock-debug` の `apiBaseUrl` のポートも書き換えてください。仕様書の `servers` の URL にパス（`/v1` など）があるときは、同じ `apiBaseUrl` にそのパスも付けてください。

iOS シミュレーターからは `mock-debug` で起動すればそのままつながります。

Android エミュレーターからつなぐときは、次のコマンドでエミュレーターの 4000 番のポートをホストの 4000 番に転送してから、`mock-debug` で起動してください。ポートを変えたときは、`4000` をそのポートに替えてください。エミュレーターを起動し直したときは、もう一度実行してください。

```shell
adb reverse tcp:4000 tcp:4000
```

Android の実機も、USB で接続していれば、同じ `adb reverse` でつながります。

モックサーバーは `127.0.0.1` でだけ待ち受けるため、同じ LAN にある実機からはつながりません。

## 応答

- 各 operation の 2xx（なければ `2XX`、`default` の順）の応答から、media type の `example`、`examples` の最初の `value`、`schema` の `example`、`schema` の `examples` の最初の値の順に探して返します。`example` がない operation には 501 を返し、起動時にもその一覧を表示します。
- JSON でない media type（`text/plain` など）の `example` は文字列で書いてください。オブジェクトや配列の `example` には 501 を返します。
- ほかのファイルへの `$ref` は読めません。起動時に、読めなかったパスと、`$ref` を読めずに 501 を返す operation の一覧を表示します。

## 管理画面

モックサーバーを起動したまま、ブラウザーで `http://127.0.0.1:4000/_admin/` を開きます。ポートを変えたときは、`4000` をそのポートに替えてください。

### operation タブ

operation ごとに次を設定できます。

- 応答: 正常系か異常系のどちらかを返します。
  - 正常系: [応答](#応答)で選ぶ 1 つの応答を返します。
  - 異常系: 仕様書にある 3xx、4xx、5xx の応答を返します。
  - どちらも、ステータスコード、Content-Type、本文を編集できます。ステータスコードは、仕様書にあるコードを応答の `description` とともに選択肢から選ぶと、その応答が編集欄に入ります。仕様書にないコードは「そのほか」を選んで入力します。編集せずに保存すると、仕様書の応答を返します。`example` がなく 501 を返す operation にも、編集した応答を設定できます。
  - 選択肢に出ない応答（正常系のほかの 2xx、`4XX`、`5XX`、`default`）を返すときは、「そのほか」でコードを入力し、本文を編集欄に書きます。
- 遅延: 応答を返すまでに待つ時間をミリ秒で指定します。

設定はすぐに反映され、モックサーバーを起動し直すと消えます。残すときは[プロファイル](#プロファイル)に保存します。

### プロファイル

operation タブの設定をまとめて名前を付けて保存し、切り替えます。「一覧が空」「すべてエラー」のような状態を、operation ごとに設定し直さずに再現するときに使います。

プロファイルは、仕様書と同じディレクトリの `mock_profiles` に置きます。

- 共有: `openapi/<api_name>/mock_profiles/<名前>.json`。チームで使う状態を置き、コミットします。管理画面からは書き換えません。
- 自分用: `openapi/<api_name>/mock_profiles/local/<名前>.json`。管理画面の「今の設定を保存」で保存します。Git の対象から外してあります。

管理画面で使うときは、次のように操作します。

- プロファイルを選んで「適用」を押すと、すべての operation を既定に戻してから、プロファイルの設定を入れます。
- 「今の設定を保存」を押すと、既定から変えた operation の設定を、自分用のプロファイルに保存します。同じ名前があれば上書きします。
- 「削除」で消せるのは、自分用のプロファイルだけです。

自分用のプロファイルをチームで使うときは、ファイルを `local` から `mock_profiles` にコピーしてコミットします。サンプルの仕様書には、`GET /items` が空の一覧を返す `empty-list` を置いています。

仕様書を変えて、プロファイルの operation やステータスコードが仕様書からなくなると、適用するときにその設定を読み飛ばし、読み飛ばした設定を管理画面に表示します。プロファイルのファイルを直すか、管理画面で設定し直して保存してください。

### 通信タブ

モックサーバーが受けたリクエストと、返した応答を新しいものから一覧にします。アプリが実際に何を送ったかを確かめるときに使います。

- 1 件を選ぶと、リクエストのヘッダーと本文、応答の Content-Type と本文を表示します。仕様書の operation に一致したリクエストでは、その operation の設定を開けます。
- 履歴はメモリーに新しいものから 200 件まで持ち、モックサーバーを起動し直すと消えます。本文は 256 KiB を超えた分を切り捨てます。
- `Authorization`、`Cookie`、`Proxy-Authorization` のヘッダーの値は伏せて表示します。
- 管理画面へのリクエストは履歴に残しません。ブラウザーが読みに来る `/favicon.ico` も、仕様書の `paths` になければ本文のない 204 を返し、履歴に残しません。

### 管理画面とパスが重なったとき

仕様書の `servers` の URL にパスがなく、`paths` に `/_admin` から始まるパスがあると、そのパスへのリクエストは管理画面が受けます。その operation は管理画面の一覧に出て設定もできますが、アプリのリクエストはモックに届きません。避けるには、`servers` の URL にパス（`https://api.example.com/v1` など）を付けます。

## アプリへの組み込み

iOS の実機や配布するビルドからは、手元のモックサーバーにつながりません。そのときは、モックサーバーをアプリの中で起動し、API の向き先をそこにします。

`--dart-define=embedMockServer=true` を付けてビルドすると、アプリは起動時に `127.0.0.1` でモックサーバーを起動し、`BuildConfig.apiBaseUrl` をその URL にします。flavor ファイルの `apiBaseUrl` は使いません。実行構成では `mock-embedded-debug` で起動できます。配布するビルドでは、選んだ flavor の `--dart-define-from-file` に `--dart-define=embedMockServer=true` を足してビルドしてください。

- 返す応答は、手元のモックサーバーの既定と同じく、仕様書の[応答](#応答)です。管理画面はなく、応答の切り替えとプロファイルは使えません。
- ポートは OS が空いているものを選びます。URL は起動時のログ（`BuildConfig`）に出ます。iOS シミュレーターは Mac とループバックを共有するため、Mac からその URL に `curl` でつながります。
- 仕様書は `apps/app/lib/mock_server/embedded_mock_spec.g.dart` に Dart の定数として持たせます。仕様書を変えたら、`mise run gen` で作り直してください。組み込めるのは 1 つの API だけです。`openapi` に API が複数あるときは、ルートの `pubspec.yaml` の `gen:embedded_mock_spec` の `run` の末尾に、組み込む API 名を書いてください。書かないと `mise run gen` が失敗します。
- `embedMockServer` を付けないビルドからは、モックサーバーと仕様書が tree shaking で除外されます。`mise run check:debug_tree_shaking` で確かめられます。assets は tree shaking で除外されないため、仕様書を assets に載せないでください。

<!-- Links -->

[packages/mock_server]: ../packages/mock_server
[.vscode/launch.json]: ../.vscode/launch.json
[.idea/runConfigurations/mock_debug.xml]: ../.idea/runConfigurations/mock_debug.xml
