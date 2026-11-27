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
    post:
      responses:
        "205":
          description: reset
          content:
            application/json:
              example: reset
  /items/mine:
    get:
      responses:
        "200":
          description: ok
          content:
            application/json:
              example: mine
  /files/{name}:
    get:
      responses:
        "200":
          description: ok
          content:
            application/json:
              example: any
  /files/{name}.json:
    get:
      responses:
        "200":
          description: ok
          content:
            application/json:
              example: file
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
    // 仕様書では、/items/{itemId} と /items/mine の間に区間の数が違う /drafts がある。
    expect(await jsonOf(await send('GET', '/items/mine')), 'mine');
  });

  test('区間の一部がテンプレートのパスは、全体がテンプレートのパスより先に照合する', () async {
    expect(await jsonOf(await send('GET', '/files/a.json')), 'file');
    expect(await jsonOf(await send('GET', '/files/a')), 'any');
    // テンプレートの外の . は、任意の 1 文字に一致しない。
    expect(await jsonOf(await send('GET', '/files/a-json')), 'any');
  });

  test('HEAD には GET の operation で応える', () async {
    final response = await send('HEAD', '/items/1');

    expect(response.statusCode, 200);
    expect(response.headers['content-type'], 'application/json; charset=utf-8');
  });

  test('固定のパスにないメソッドは、テンプレートのパスから探す', () async {
    final response = await send('DELETE', '/items/mine');

    expect(response.statusCode, 204);
    expect(await response.readAsString(), isEmpty);
  });

  test('205 の応答には本文を付けない', () async {
    final response = await send('POST', '/drafts');

    expect(response.statusCode, 205);
    expect(await response.readAsString(), isEmpty);
  });

  test('パスパラメーターの値が %2F を含んでも照合する', () async {
    expect(await jsonOf(await send('GET', '/items/a%2Fb')), 'item');
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
    expect(response.headers['allow'], 'GET, HEAD, DELETE');
  });

  test('example がない operation には 501 と理由を返す', () async {
    final response = await send('GET', '/drafts');

    expect(response.statusCode, 501);
    expect(await jsonOf(response), {
      'message': contains('GET /drafts (listDrafts) の 200 の応答'),
    });
  });

  group('中身を読めないパス', () {
    final handler = createMockHandler(
      OpenApiDocument.parse(r'''
openapi: 3.0.3
info:
  title: Test
  version: 1.0.0
paths:
  /items/{itemId}:
    get:
      responses:
        "200":
          description: ok
          content:
            application/json:
              example: item
  /items/special:
    $ref: other.yaml#/paths/special
'''),
    );

    Future<Response> send(String method, String path) async =>
        await handler(Request(method, Uri.parse('http://localhost$path')));

    test('どのメソッドにも 501 と理由を返し、Allow を付けない', () async {
      for (final method in ['GET', 'POST']) {
        final response = await send(method, '/items/special');

        expect(response.statusCode, 501, reason: method);
        expect(response.headers, isNot(contains('allow')), reason: method);
        expect(await jsonOf(response), {
          'message': r'仕様書の /items/special の中身を読めません。$ref の参照先を確かめてください。',
        });
      }
    });

    test('テンプレートのパスより先に照合する', () async {
      expect((await send('GET', '/items/special')).statusCode, 501);
      expect(await jsonOf(await send('GET', '/items/1')), 'item');
    });
  });

  group('mountAtBasePath', () {
    final document = OpenApiDocument.parse('''
openapi: 3.0.3
info:
  title: Test
  version: 1.0.0
servers:
  - url: https://api.example.com/v1
paths:
  /:
    get:
      responses:
        "200":
          description: ok
          content:
            application/json:
              example: root
  /items:
    get:
      responses:
        "200":
          description: ok
          content:
            application/json:
              example: items
''');
    final handler = mountAtBasePath(
      document.basePath,
      createMockHandler(document),
    );

    Future<Response> send(String path) async =>
        await handler(Request('GET', Uri.parse('http://localhost$path')));

    test('基底パスを除いたパスで内側のハンドラーに振り分ける', () async {
      expect(await jsonOf(await send('/v1/items')), 'items');
      expect(await jsonOf(await send('/v1')), 'root');
      expect(await jsonOf(await send('/v1/unknown')), {
        'message': '仕様書に /unknown のパスがありません。',
      });
    });

    test('基底パスの外には、基底パスを案内する 404 を返す', () async {
      for (final path in ['/items', '/v10/items']) {
        final response = await send(path);

        expect(response.statusCode, 404, reason: path);
        expect(await jsonOf(response), {
          'message':
              '$path は、仕様書の servers のパス /v1 の外にあります。/v1 から始まるパスに送ってください。',
        });
      }
    });

    test('基底パスが空文字なら、内側のハンドラーをそのまま返す', () {
      final inner = createMockHandler(document);

      expect(mountAtBasePath('', inner), same(inner));
    });
  });

  group('設定', () {
    final document = OpenApiDocument.parse('''
paths:
  /items:
    get:
      responses:
        "200":
          description: ok
          content:
            application/json:
              example: items
        "404":
          description: not found
          content:
            application/json:
              example:
                message: not found
  /drafts:
    get:
      responses:
        "200":
          description: ok
          content:
            application/json:
              schema:
                type: object
''');
    late MockSettings settings;
    late Handler handler;

    setUp(() {
      settings = MockSettings();
      handler = createMockHandler(document, settings: settings);
    });

    Future<Response> send(String path) async =>
        await handler(Request('GET', Uri.parse('http://localhost$path')));

    test('設定がなければ仕様書の example を返す', () async {
      expect(await jsonOf(await send('/items')), 'items');
    });

    test('編集した応答を返す', () async {
      settings.update(
        'GET /drafts',
        const OperationSettings(
          response: EditedResponse(
            statusCode: 201,
            contentType: 'text/plain',
            body: 'edited',
          ),
        ),
      );

      final response = await send('/drafts');

      expect(response.statusCode, 201);
      expect(response.headers['content-type'], 'text/plain');
      expect(await response.readAsString(), 'edited');
    });

    test('仕様書のエラーの応答を返す', () async {
      settings.update(
        'GET /items',
        const OperationSettings(response: SpecErrorResponse(404)),
      );

      final response = await send('/items');

      expect(response.statusCode, 404);
      expect(await jsonOf(response), {'message': 'not found'});
    });

    test('仕様書にないエラーの応答には 501 を返す', () async {
      settings.update(
        'GET /items',
        const OperationSettings(response: SpecErrorResponse(500)),
      );

      final response = await send('/items');

      expect(response.statusCode, 501);
      expect(await jsonOf(response), {
        'message': 'GET /items に 500 の応答がありません。',
      });
    });

    test('編集した異常系の応答を返す', () async {
      settings.update(
        'GET /items',
        const OperationSettings(
          response: EditedResponse(
            statusCode: 422,
            contentType: 'application/json',
            body: '{"message":"invalid"}',
          ),
        ),
      );

      final response = await send('/items');

      expect(response.statusCode, 422);
      expect(await jsonOf(response), {'message': 'invalid'});
    });

    test('遅延を指定すると、その時間だけ待ってから返す', () async {
      settings.update(
        'GET /items',
        const OperationSettings(delay: Duration(milliseconds: 200)),
      );

      final stopwatch = Stopwatch()..start();
      final response = await send('/items');
      stopwatch.stop();

      expect(response.statusCode, 200);
      expect(
        stopwatch.elapsed,
        greaterThanOrEqualTo(const Duration(milliseconds: 200)),
      );
    });
  });
}
