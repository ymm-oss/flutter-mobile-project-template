# モックサーバー

[packages/mock_server] のモックサーバーは、OpenAPI の仕様書（`openapi/<api_name>/openapi.yaml`）の `example` を返します。

## 起動

次のコマンドで起動します。

```shell
mise run mock
```

`openapi` に API が複数あるときは、`mise run mock <api_name>` で API 名を指定してください。

- ポートは `mise run mock --port 4011` のように変えられます。
- 使い方は `mise run mock -- --help` で表示します。`--` を付けないと、mise が `--help` を受け取ります。
- 仕様書を変えたときは、モックサーバーを起動し直してください。

## アプリからの接続

モックサーバーの URL は `http://127.0.0.1:4010` に仕様書の `servers` の 1 つ目の URL のパスを付けたものです。たとえば `servers` の URL が `https://api.example.com/v1` なら `http://127.0.0.1:4010/v1` になります。起動時にもこの URL を表示します。

実行構成 `mock-debug` でアプリを起動すると、`apiBaseUrl` は `http://127.0.0.1:4010` になります。アプリ ID などのほかの値は `dev-debug` と同じため、端末では同じアプリとして入れ替わり、保存したデータも引き継がれます。生成したクライアントの接続先に `BuildConfig.apiBaseUrl` を渡していれば、モックサーバーにつながります。モックサーバーのポートを変えたときは、[.vscode/launch.json] と [.idea/runConfigurations/mock_debug.xml] の `mock-debug` の `apiBaseUrl` のポートも書き換えてください。仕様書の `servers` の URL にパス（`/v1` など）があるときは、同じ `apiBaseUrl` にそのパスも付けてください。

iOS シミュレーターからは `mock-debug` で起動すればそのままつながります。

Android エミュレーターからつなぐときは、次のコマンドでエミュレーターの 4010 番のポートをホストの 4010 番に転送してから、`mock-debug` で起動してください。ポートを変えたときは、`4010` をそのポートに替えてください。エミュレーターを起動し直したときは、もう一度実行してください。

```shell
adb reverse tcp:4010 tcp:4010
```

Android の実機も、USB で接続していれば、同じ `adb reverse` でつながります。

モックサーバーは `127.0.0.1` でだけ待ち受けるため、同じ LAN にある実機からはつながりません。

## 応答

- 各 operation の 2xx（なければ `2XX`、`default` の順）の応答から、media type の `example`、`examples` の最初の `value`、`schema` の `example`、`schema` の `examples` の最初の値の順に探して返します。`example` がない operation には 501 を返し、起動時にもその一覧を表示します。
- JSON でない media type（`text/plain` など）の `example` は文字列で書いてください。オブジェクトや配列の `example` には 501 を返します。
- ほかのファイルへの `$ref` は読めません。起動時に、読めなかったパスと、`$ref` を読めずに 501 を返す operation の一覧を表示します。読めなかったパスには、どのメソッドのリクエストにも 501 を返します。

## 管理画面

モックサーバーを起動したまま、ブラウザーで `http://127.0.0.1:4010/_admin/` を開くと、operation ごとに次を設定できます。ポートを変えたときは、`4010` をそのポートに替えてください。

- 応答: 正常系か異常系のどちらかを返します。
  - 正常系: [応答](#応答)で選ぶ 1 つの応答を返します。
  - 異常系: 仕様書にある 3xx、4xx、5xx の応答を返します。
  - どちらも、ステータスコード、Content-Type、本文を編集できます。ステータスコードは、仕様書にあるコードを応答の `description` とともに選択肢から選ぶと、その応答が編集欄に入ります。仕様書にないコードは「そのほか」を選んで入力します。編集せずに保存すると、仕様書の応答を返します。`example` がなく 501 を返す operation にも、編集した応答を設定できます。
  - 選択肢に出ない応答（正常系のほかの 2xx、`4XX`、`5XX`、`default`）を返すときは、「そのほか」でコードを入力し、本文を編集欄に書きます。
- 遅延: 応答を返すまでに待つ時間をミリ秒で指定します。

設定はすぐに反映され、モックサーバーを起動し直すと消えます。

仕様書の `servers` の URL にパスがなく、`paths` に `/_admin` から始まるパスがあると、そのパスへのリクエストは管理画面が受けます。その operation は管理画面の一覧に出て設定もできますが、アプリのリクエストはモックに届きません。避けるには、`servers` の URL にパス（`https://api.example.com/v1` など）を付けます。

<!-- Links -->

[packages/mock_server]: ../packages/mock_server
[.vscode/launch.json]: ../.vscode/launch.json
[.idea/runConfigurations/mock_debug.xml]: ../.idea/runConfigurations/mock_debug.xml
