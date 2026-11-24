import 'dart:convert';

import 'package:internal_mock_server/internal_mock_server.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  final handler = createMockHandler(
    OpenApiDocument.parse('''
openapi: 3.0.3
info:
  title: Test
  version: 1.0.0
paths:
  /:
    get:
      responses:
        "200":
          description: ok
          content:
            application/json:
              example: root
  /items/{itemId}:
    get:
      responses:
        "200":
          description: ok
          content:
            application/json:
              example: item
    delete:
      responses:
        "204":
          description: deleted
  /items/mine:
    get:
      responses:
        "200":
          description: ok
          content:
            application/json:
              example: mine
  /files/{name}.json:
    get:
      responses:
        "200":
          description: ok
          content:
            application/json:
              example: file
  /drafts:
    get:
      operationId: listDrafts
      responses:
        "200":
          description: ok
          content:
            application/json:
              schema:
                type: array
'''),
  );

  Future<Response> send(String method, String path) async =>
      await handler(Request(method, Uri.parse('http://localhost$path')));

  Future<Object?> jsonOf(Response response) async =>
      jsonDecode(await response.readAsString());

  test('仕様書の example を返す', () async {
    final response = await send('GET', '/items/1');

    expect(response.statusCode, 200);
    expect(response.headers['content-type'], 'application/json; charset=utf-8');
    expect(await jsonOf(response), 'item');
  });

  test('ルートのパスにも振り分ける', () async {
    expect(await jsonOf(await send('GET', '/')), 'root');
  });

  test('テンプレートより固定のパスを先に照合する', () async {
    expect(await jsonOf(await send('GET', '/items/mine')), 'mine');
  });

  test('区間の一部がテンプレートのパスにも振り分ける', () async {
    expect(await jsonOf(await send('GET', '/files/a.json')), 'file');
  });

  test('固定のパスにないメソッドは、テンプレートのパスから探す', () async {
    final response = await send('DELETE', '/items/mine');

    expect(response.statusCode, 204);
    expect(await response.readAsString(), isEmpty);
  });

  test('仕様書にないパスには 404 を返す', () async {
    final response = await send('GET', '/unknown');

    expect(response.statusCode, 404);
    expect(await jsonOf(response), {'message': '仕様書に /unknown のパスがありません。'});
  });

  test('区間の数が違うパスには 404 を返す', () async {
    expect((await send('GET', '/items/1/children')).statusCode, 404);
  });

  test('パスにないメソッドには 405 と Allow を返す', () async {
    final response = await send('POST', '/items/1');

    expect(response.statusCode, 405);
    expect(response.headers['allow'], 'GET, DELETE');
  });

  test('example がない operation には 501 と理由を返す', () async {
    final response = await send('GET', '/drafts');

    expect(response.statusCode, 501);
    expect(await jsonOf(response), {
      'message': contains('GET /drafts (listDrafts) の 200 の応答'),
    });
  });
}
