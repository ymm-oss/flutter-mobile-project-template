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

実行構成 `mock-debug` でアプリを起動すると、`apiBaseUrl` は `http://127.0.0.1:4000` になります。ほかの値は `dev-debug` と同じです。生成したクライアントの接続先に `BuildConfig.apiBaseUrl` を渡していれば、モックサーバーにつながります。モックサーバーのポートを変えたときは、[.vscode/launch.json] と [.idea/runConfigurations/mock_debug.xml] の `mock-debug` の `apiBaseUrl` のポートも書き換えてください。仕様書の `servers` の URL にパス（`/v1` など）があるときは、同じ `apiBaseUrl` にそのパスも付けてください。

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

<!-- Links -->

[packages/mock_server]: ../packages/mock_server
[.vscode/launch.json]: ../.vscode/launch.json
[.idea/runConfigurations/mock_debug.xml]: ../.idea/runConfigurations/mock_debug.xml
