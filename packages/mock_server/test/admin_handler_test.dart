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
  late RequestLog log;
  late _MemoryProfileStore profiles;
  late Handler handler;

  setUp(() {
    settings = MockSettings();
    log = RequestLog();
    profiles = _MemoryProfileStore();
    Future<Uint8List> assets(String path) async => utf8.encode('asset:$path');
    handler = mountAdmin(
      createAdminHandler(
        document,
        settings,
        assets: assets,
        log: log,
        profiles: profiles,
      ),
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

  group('serveFavicon', () {
    Future<Uint8List> assets(String path) async => utf8.encode('asset:$path');
    Future<Response> get(Handler handler, String path) async =>
        await handler(Request('GET', Uri.parse('http://localhost$path')));
    Response mock(Request request) => Response.ok('mock');

    test('/favicon.ico には管理画面のアイコンを返し、ほかは内側に渡す', () async {
      final favicon = serveFavicon(document, mock, assets: assets);

      final icon = await get(favicon, '/favicon.ico');
      expect(icon.headers['content-type'], 'image/svg+xml');
      expect(await icon.readAsString(), 'asset:admin/favicon.svg');
      expect(await (await get(favicon, '/items/1')).readAsString(), 'mock');
    });

    test('仕様書に /favicon.ico があれば、内側に渡す', () async {
      final favicon = serveFavicon(
        OpenApiDocument.parse('''
paths:
  /favicon.ico:
    get:
      responses:
        "200":
          description: ok
          content:
            text/plain:
              example: icon
'''),
        mock,
        assets: assets,
      );

      expect(await (await get(favicon, '/favicon.ico')).readAsString(), 'mock');
    });

    test('servers にパスがあれば、仕様書に /favicon.ico があっても返す', () async {
      final favicon = serveFavicon(
        OpenApiDocument.parse('''
servers:
  - url: https://api.example.com/v1
paths:
  /favicon.ico:
    get:
      responses:
        "200":
          description: ok
'''),
        mock,
        assets: assets,
      );

      expect(
        await (await get(favicon, '/favicon.ico')).readAsString(),
        'asset:admin/favicon.svg',
      );
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
      final traffic = await send('GET', '/_admin/traffic.js');
      expect(await traffic.readAsString(), 'asset:admin/traffic.js');
      final profile = await send('GET', '/_admin/profile.js');
      expect(await profile.readAsString(), 'asset:admin/profile.js');
    });

    test('決まったファイルのほかには、リクエストのパスを示して 404 を返す', () async {
      final response = await send('GET', '/_admin/secret.txt');

      expect(response.statusCode, 404);
      expect(await jsonOf(response), {
        'message': '管理画面に /_admin/secret.txt はありません。',
      });
    });

    test('ファイルを読めなければ 500 を返す', () async {
      final failing = createAdminHandler(
        document,
        settings,
        assets: (path) async => throw Exception('missing'),
        log: log,
        profiles: profiles,
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

  group('通信の履歴の API', () {
    void addEntry(String path) => log.add(
      time: DateTime.utc(2026),
      method: 'GET',
      path: path,
      operationKey: itemKey,
      source: ResponseSource.spec,
      statusCode: 200,
      duration: const Duration(milliseconds: 5),
      requestHeaders: {'accept': 'application/json'},
      requestBody: '',
      responseContentType: 'application/json',
      responseBody: '{"id":"1"}',
    );

    test('after より新しい履歴の一覧を、中身を除いて返す', () async {
      addEntry('/items/1');
      addEntry('/items/2');

      final json = await jsonOf(
        await send('GET', '/_admin/api/traffic?after=1'),
      );

      expect(json, {
        'lastId': 2,
        'entries': [
          {
            'id': 2,
            'time': '2026-01-01T00:00:00.000Z',
            'method': 'GET',
            'path': '/items/2',
            'operationKey': itemKey,
            'source': 'spec',
            'statusCode': 200,
            'durationMs': 5,
          },
        ],
      });
    });

    test('1 件の中身を返す', () async {
      addEntry('/items/1');

      final json = await jsonOf(await send('GET', '/_admin/api/traffic/1'));

      expect(
        json,
        allOf(
          containsPair('requestHeaders', {'accept': 'application/json'}),
          containsPair('responseBody', '{"id":"1"}'),
          containsPair('responseBodyTruncated', false),
        ),
      );
    });

    test('ない履歴には 404 を返す', () async {
      expect((await send('GET', '/_admin/api/traffic/1')).statusCode, 404);
    });

    test('整数でない after には 400 を返す', () async {
      expect(
        (await send('GET', '/_admin/api/traffic?after=x')).statusCode,
        400,
      );
    });

    test('DELETE で履歴を消す', () async {
      addEntry('/items/1');

      final response = await send('DELETE', '/_admin/api/traffic');

      expect(response.statusCode, 204);
      expect(log.entries, isEmpty);
    });
  });

  group('プロファイルの API', () {
    test('共有と自分用のプロファイルの一覧を返す', () async {
      profiles
        ..shared['empty'] = '{}'
        ..local['mine'] = '{}';

      expect(await jsonOf(await send('GET', '/_admin/api/profiles')), {
        'profiles': [
          {'name': 'empty', 'shared': true},
          {'name': 'mine', 'shared': false},
        ],
      });
    });

    test('今の設定を自分用に保存する', () async {
      settings.update(
        itemKey,
        const OperationSettings(response: SpecErrorResponse(404)),
      );

      final response = await send('PUT', '/_admin/api/profiles/local/errors');

      expect(response.statusCode, 200);
      expect(jsonDecode(profiles.local['errors']!), {
        'version': 1,
        'operations': {
          itemKey: {
            'response': {'type': 'specError', 'statusCode': 404},
            'delayMs': 0,
          },
        },
      });
    });

    test('使えない名前には 400 を返す', () async {
      final response = await send(
        'PUT',
        '/_admin/api/profiles/local/${Uri.encodeComponent('../x')}',
      );

      expect(response.statusCode, 400);
      expect(profiles.local, isEmpty);
    });

    test('プロファイルを適用し、読み飛ばしたものを返す', () async {
      profiles.shared['errors'] = jsonEncode({
        'version': 1,
        'operations': {
          itemKey: {
            'response': {'type': 'specError', 'statusCode': 404},
          },
          'GET /removed': {'delayMs': 10},
        },
      });

      final response = await send(
        'POST',
        '/_admin/api/profiles/apply',
        body: {'name': 'errors', 'shared': true},
      );

      expect(response.statusCode, 200);
      expect(await jsonOf(response), {
        'skipped': ['仕様書に GET /removed の operation がありません。'],
      });
      expect(settings.of(itemKey).response, isA<SpecErrorResponse>());
    });

    test('ないプロファイルの適用には 404 を返す', () async {
      final response = await send(
        'POST',
        '/_admin/api/profiles/apply',
        body: {'name': 'none', 'shared': false},
      );

      expect(response.statusCode, 404);
    });

    test('読めないプロファイルの適用には 422 を返し、設定を変えない', () async {
      settings.update(
        itemKey,
        const OperationSettings(delay: Duration(seconds: 1)),
      );
      profiles.local['broken'] = '{';

      final response = await send(
        'POST',
        '/_admin/api/profiles/apply',
        body: {'name': 'broken', 'shared': false},
      );

      expect(response.statusCode, 422);
      expect(settings.of(itemKey).delay, const Duration(seconds: 1));
    });

    test('自分用のプロファイルを消す', () async {
      profiles.local['mine'] = '{}';

      final response = await send('DELETE', '/_admin/api/profiles/local/mine');

      expect(response.statusCode, 204);
      expect(profiles.local, isEmpty);
    });
  });
}

final class _MemoryProfileStore implements ProfileStore {
  final shared = <String, String>{};

  final local = <String, String>{};

  @override
  Future<List<ProfileRef>> list() async => [
    for (final name in shared.keys) (name: name, shared: true),
    for (final name in local.keys) (name: name, shared: false),
  ];

  @override
  Future<String> read(ProfileRef ref) async =>
      (ref.shared ? shared : local)[ref.name] ??
      (throw ProfileStoreException('${ref.name} がありません。'));

  @override
  Future<void> save(String name, String content) async {
    validateProfileName(name);
    local[name] = content;
  }

  @override
  Future<void> delete(String name) async {
    if (local.remove(name) == null) {
      throw ProfileStoreException('$name がありません。');
    }
  }
}
