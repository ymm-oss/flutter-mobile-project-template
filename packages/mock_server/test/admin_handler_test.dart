import 'dart:convert';
import 'dart:typed_data';

import 'package:internal_mock_server/internal_mock_server.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  final document = OpenApiDocument.parse('''
paths:
  /items/{itemId}:
    get:
      operationId: getItem
      responses:
        "200":
          description: ok
          content:
            application/json:
              example:
                id: "1"
        "404":
          description: not found
          content:
            application/json:
              example:
                message: not found
  /drafts:
    post:
      responses:
        "200":
          description: ok
          content:
            application/json:
              schema:
                type: object
''');
  const itemKey = 'GET /items/{itemId}';
  final itemPath = '/_admin/api/operations/${Uri.encodeComponent(itemKey)}';

  late MockSettings settings;
  late Handler handler;

  setUp(() {
    settings = MockSettings();
    Future<Uint8List> assets(String path) async => utf8.encode('asset:$path');
    handler = mountAdmin(
      createAdminHandler(document, settings, assets: assets),
      (request) => Response.ok('mock'),
    );
  });

  Future<Response> send(String method, String path, {Object? body}) async =>
      await handler(
        Request(
          method,
          Uri.parse('http://localhost$path'),
          body: body is String ? body : jsonEncode(body),
        ),
      );

  Future<Object?> jsonOf(Response response) async =>
      jsonDecode(await response.readAsString());

  group('mountAdmin', () {
    test('/_admin の外は、内側のハンドラーに渡す', () async {
      for (final path in ['/items/1', '/_administrator']) {
        expect(
          await (await send('GET', path)).readAsString(),
          'mock',
          reason: path,
        );
      }
    });
  });

  group('画面のファイル', () {
    test('/_admin/ には index.html を返す', () async {
      final response = await send('GET', '/_admin/');

      expect(response.statusCode, 200);
      expect(response.headers['content-type'], 'text/html; charset=utf-8');
      expect(await response.readAsString(), 'asset:admin/index.html');
    });

    test('/_admin は /_admin/ に転送する', () async {
      final response = await send('GET', '/_admin');

      expect(response.statusCode, 302);
      expect(response.headers['location'], '/_admin/');
    });

    test('JS と CSS を返す', () async {
      final js = await send('GET', '/_admin/admin.js');
      final css = await send('GET', '/_admin/admin.css');

      expect(js.headers['content-type'], 'text/javascript; charset=utf-8');
      expect(await js.readAsString(), 'asset:admin/admin.js');
      expect(css.headers['content-type'], 'text/css; charset=utf-8');
    });

    test('決まったファイルのほかには 404 を返す', () async {
      expect((await send('GET', '/_admin/secret.txt')).statusCode, 404);
    });

    test('ファイルを読めなければ 500 を返す', () async {
      final failing = createAdminHandler(
        document,
        settings,
        assets: (path) async => throw Exception('missing'),
      );

      final response = await failing(
        Request('GET', Uri.parse('http://localhost/')),
      );

      expect(response.statusCode, 500);
    });
  });

  group('JSON API', () {
    test('operation の一覧と設定を返す', () async {
      final json = await jsonOf(await send('GET', '/_admin/api/operations'));

      expect(json, {
        'operations': [
          {
            'key': itemKey,
            'method': 'GET',
            'path': '/items/{itemId}',
            'operationId': 'getItem',
            'response': {
              'statusCode': 200,
              'description': 'ok',
              'contentType': 'application/json; charset=utf-8',
              'body': '{"id":"1"}',
            },
            'errorResponses': [
              {
                'statusCode': 404,
                'description': 'not found',
                'contentType': 'application/json; charset=utf-8',
                'body': '{"message":"not found"}',
              },
            ],
            'settings': {'response': null, 'delayMs': 0},
          },
          {
            'key': 'POST /drafts',
            'method': 'POST',
            'path': '/drafts',
            'operationId': null,
            'response': {
              'statusCode': 200,
              'description': 'ok',
              'missing': 'POST /drafts の 200 の応答（application/json）に example がありません。仕様書に example を書いてください。',
            },
            'errorResponses': <Object?>[],
            'settings': {'response': null, 'delayMs': 0},
          },
        ],
      });
    });

    test('PUT で正常系の応答と遅延を設定し、変えた operation を返す', () async {
      const edited = {
        'type': 'edited',
        'statusCode': 201,
        'contentType': 'application/json',
        'body': '{}',
      };
      final response = await send(
        'PUT',
        itemPath,
        body: {'response': edited, 'delayMs': 300},
      );

      expect(response.statusCode, 200);
      expect(
        (await jsonOf(response))! as Map,
        containsPair('settings', {'response': edited, 'delayMs': 300}),
      );
      final saved = settings.of(itemKey);
      expect(
        saved.response,
        isA<EditedResponse>().having((r) => r.statusCode, 'statusCode', 201),
      );
      expect(saved.delay, const Duration(milliseconds: 300));
    });

    test('仕様書のエラーの応答を設定する', () async {
      const specError = {'type': 'specError', 'statusCode': 404};
      final response = await send(
        'PUT',
        itemPath,
        body: {'response': specError},
      );

      expect(
        (await jsonOf(response))! as Map,
        containsPair('settings', {'response': specError, 'delayMs': 0}),
      );
      expect(
        settings.of(itemKey).response,
        isA<SpecErrorResponse>().having((e) => e.statusCode, 'statusCode', 404),
      );
    });

    test('異常系の応答も編集して設定する', () async {
      await send(
        'PUT',
        itemPath,
        body: {
          'response': {
            'type': 'edited',
            'statusCode': 422,
            'contentType': 'application/json',
            'body': '{"message":"invalid"}',
          },
        },
      );

      expect(
        settings.of(itemKey).response,
        isA<EditedResponse>().having((e) => e.statusCode, 'statusCode', 422),
      );
    });

    test('DELETE で 1 つの operation を既定に戻す', () async {
      settings.update(
        itemKey,
        const OperationSettings(response: SpecErrorResponse(404)),
      );

      final response = await send('DELETE', itemPath);

      expect(response.statusCode, 200);
      expect(settings.changed, isEmpty);
    });

    test('一覧に DELETE すると、すべての operation を既定に戻す', () async {
      settings
        ..update(
          itemKey,
          const OperationSettings(response: SpecErrorResponse(404)),
        )
        ..update(
          'POST /drafts',
          const OperationSettings(response: SpecErrorResponse(404)),
        );

      final response = await send('DELETE', '/_admin/api/operations');

      expect(response.statusCode, 204);
      expect(settings.changed, isEmpty);
    });

    test('仕様書にない operation には 404 を返す', () async {
      final response = await send(
        'PUT',
        '/_admin/api/operations/${Uri.encodeComponent('GET /unknown')}',
        body: <String, Object?>{},
      );

      expect(response.statusCode, 404);
    });

    test('応答しないメソッドには 405 と Allow を返す', () async {
      final response = await send('POST', itemPath, body: '');

      expect(response.statusCode, 405);
      expect(response.headers['allow'], 'GET, PUT, DELETE');
    });

    group('不正な設定には 400 と理由を返す', () {
      final cases = <String, (Object?, String)>{
        'JSON でない本文': ('{', '本文を JSON として読めません。'),
        'オブジェクトでない本文': (<Object?>[], '設定はオブジェクトで送ってください。'),
        '項目が足りない編集した応答': (
          {
            'response': {'type': 'edited', 'statusCode': 200},
          },
          '編集した応答には statusCode、contentType、body を指定してください。',
        ),
        '範囲外のステータスコード': (
          {
            'response': {
              'type': 'edited',
              'statusCode': 100,
              'contentType': 'application/json',
              'body': '',
            },
          },
          'ステータスコードには 200 から 599 を指定してください。',
        ),
        '読めない Content-Type': (
          {
            'response': {
              'type': 'edited',
              'statusCode': 200,
              'contentType': 'json',
              'body': '',
            },
          },
          'Content-Type「json」を読めません。application/json のように指定してください。',
        ),
        'ASCII でない文字を含む Content-Type': (
          {
            'response': {
              'type': 'edited',
              'statusCode': 200,
              'contentType': 'application/json　',
              'body': '',
            },
          },
          'Content-Type「application/json　」には、表示できる ASCII の文字だけを指定してください。',
        ),
        '仕様書にないエラーの応答': (
          {
            'response': {'type': 'specError', 'statusCode': 500},
          },
          '仕様書の GET /items/{itemId} に 500 の応答がありません。',
        ),
        'ステータスコードのない仕様書の応答': (
          {
            'response': {'type': 'specError'},
          },
          '仕様書の応答には statusCode を整数で指定してください。',
        ),
        '種類のない応答': (
          {
            'response': {'statusCode': 500},
          },
          'response の type には edited か specError を指定してください。',
        ),
        '負の遅延': ({'delayMs': -1}, 'delayMs には 0 以上の整数を指定してください。'),
      };
      for (final MapEntry(key: name, value: (body, message)) in cases.entries) {
        test(name, () async {
          final response = await send('PUT', itemPath, body: body);

          expect(response.statusCode, 400);
          expect(await jsonOf(response), {'message': message});
          expect(settings.changed, isEmpty);
        });
      }
    });
  });
}
