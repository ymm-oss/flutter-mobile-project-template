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

モックサーバーの URL は `http://127.0.0.1:4000` に仕様書の `servers` の 1 つ目の URL のパスを付けたものです。たとえば `servers` の URL が `https://api.example.com/v1` なら `http://127.0.0.1:4000/v1` になります。起動時にもこの URL を表示します。生成したクライアントの接続先には、この URL を渡してください。

iOS シミュレーターからは、この URL のままつながります。

Android エミュレーターからつなぐときは、次のコマンドでエミュレーターの 4000 番のポートをホストの 4000 番に転送してから、同じ URL を渡してください。ポートを変えたときは、`4000` をそのポートに替えてください。エミュレーターを起動し直したときは、もう一度実行してください。

```shell
adb reverse tcp:4000 tcp:4000
```

モックサーバーは `127.0.0.1` でだけ待ち受けるため、同じ LAN にある実機からはつながりません。

## 応答

- 各 operation の 2xx（なければ `2XX`、`default` の順）の応答から、media type の `example`、`examples` の最初の `value`、`schema` の `example`、`schema` の `examples` の最初の値の順に探して返します。`example` がない operation には 501 を返し、起動時にもその一覧を表示します。
- JSON でない media type（`text/plain` など）の `example` は文字列で書いてください。オブジェクトや配列の `example` には 501 を返します。
- ほかのファイルへの `$ref` は読めません。起動時に、読めなかったパスと、`$ref` を読めずに 501 を返す operation の一覧を表示します。

<!-- Links -->

[packages/mock_server]: ../packages/mock_server
