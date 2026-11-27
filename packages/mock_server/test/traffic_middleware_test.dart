import 'dart:convert';

import 'package:internal_mock_server/internal_mock_server.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  final document = OpenApiDocument.parse('''
paths:
  /items:
    post:
      responses:
        "200":
          description: ok
          content:
            application/json:
              example:
                id: "1"
        "400":
          description: bad request
          content:
            application/json:
              example:
                message: bad
''');
  const key = 'POST /items';

  late MockSettings settings;
  late RequestLog log;
  late Handler handler;

  setUp(() {
    settings = MockSettings();
    log = RequestLog();
    handler = const Pipeline()
        .addMiddleware(logTraffic(log))
        .addHandler(createMockHandler(document, settings: settings));
  });

  Future<Response> post(String path, String body) async => await handler(
    Request(
      'POST',
      Uri.parse('http://localhost$path'),
      body: body,
      headers: {'content-type': 'application/json'},
    ),
  );

  test('リクエストと応答の本文を変えずに渡し、履歴に残す', () async {
    final response = await post('/items?draft=true', '{"name":"a"}');

    expect(await response.readAsString(), '{"id":"1"}');
    final entry = log.entries.single;
    expect(entry.method, 'POST');
    expect(entry.path, '/items?draft=true');
    expect(entry.operationKey, key);
    expect(entry.source, ResponseSource.spec);
    expect(entry.statusCode, 200);
    expect(entry.requestHeaders['content-type'], 'application/json');
    expect(entry.requestBody, '{"name":"a"}');
    expect(entry.responseContentType, 'application/json; charset=utf-8');
    expect(entry.responseBody, '{"id":"1"}');
  });

  test('設定した応答の出どころを残す', () async {
    settings.update(
      key,
      const OperationSettings(response: SpecErrorResponse(400)),
    );
    await post('/items', '');
    settings.update(
      key,
      const OperationSettings(
        response: EditedResponse(
          statusCode: 201,
          contentType: 'text/plain',
          body: 'created',
        ),
      ),
    );
    await post('/items', '');

    expect(log.entries.map((e) => (e.source, e.statusCode)), [
      (ResponseSource.specError, 400),
      (ResponseSource.edited, 201),
    ]);
  });

  test('仕様書にないパスは、operation なしで残す', () async {
    final response = await post('/unknown', '');

    expect(response.statusCode, 404);
    expect(jsonDecode(await response.readAsString()), contains('message'));
    expect(log.entries.single.operationKey, isNull);
    expect(log.entries.single.source, ResponseSource.unmatched);
  });
}
