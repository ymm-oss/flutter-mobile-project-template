import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/mock_server/embedded_mock_server.dart';
import 'package:flutter_test/flutter_test.dart';

// 利用者が仕様書を差し替えても落ちないよう、openapi の仕様書に頼らない。
const _spec = '''
openapi: 3.0.3
info:
  title: Test
  version: 1.0.0
servers:
  - url: https://api.example.com/v1
paths:
  /items/{itemId}:
    get:
      responses:
        "200":
          description: ok
          content:
            application/json:
              example:
                id: "1"
''';

void main() {
  // testWidgets は HttpClient を差し替えるため、本物の通信を送れる test を使う。
  test('起動したモックサーバーが、仕様書の example を返す', () async {
    final baseUrl = await startEmbeddedMockServer(spec: _spec);

    final client = HttpClient();
    addTearDown(client.close);
    final request = await client.getUrl(Uri.parse('$baseUrl/items/1'));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();

    expect(Uri.parse(baseUrl).host, '127.0.0.1');
    expect(Uri.parse(baseUrl).path, '/v1');
    expect(response.statusCode, HttpStatus.ok);
    expect(jsonDecode(body), containsPair('id', '1'));
  });

  test('生成した仕様書を読んで起動できる', () async {
    final baseUrl = await startEmbeddedMockServer();

    expect(Uri.parse(baseUrl).host, '127.0.0.1');
  });
}
