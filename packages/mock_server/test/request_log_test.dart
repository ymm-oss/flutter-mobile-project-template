import 'package:internal_mock_server/internal_mock_server.dart';
import 'package:test/test.dart';

void main() {
  late RequestLog log;

  setUp(() => log = RequestLog());

  TrafficEntry add({
    String path = '/items',
    Map<String, String> requestHeaders = const {},
    String requestBody = '',
    String responseBody = '',
  }) => log.add(
    time: DateTime.utc(2026),
    method: 'GET',
    path: path,
    operationKey: null,
    source: ResponseSource.unmatched,
    statusCode: 404,
    duration: Duration.zero,
    requestHeaders: requestHeaders,
    requestBody: requestBody,
    responseContentType: null,
    responseBody: responseBody,
  );

  test('1 から順に id を付ける', () {
    expect([add().id, add().id], [1, 2]);
    expect(log.lastId, 2);
  });

  test('上限を超えたら古いものから消す', () {
    for (var i = 0; i < RequestLog.maxEntries + 1; i++) {
      add();
    }

    expect(log.entries, hasLength(RequestLog.maxEntries));
    expect(log.entries.first.id, 2);
    expect(log.entry(1), isNull);
  });

  test('after は、その id より新しい履歴を返す', () {
    add(path: '/a');
    add(path: '/b');
    add(path: '/c');

    expect(log.after(1).map((e) => e.path), ['/b', '/c']);
  });

  test('長い本文は切り詰め、切ったことを残す', () {
    final entry = add(
      requestBody: 'a' * (RequestLog.maxBodyLength + 1),
      responseBody: 'b',
    );

    expect(entry.requestBody, hasLength(RequestLog.maxBodyLength));
    expect(entry.requestBodyTruncated, isTrue);
    expect(entry.responseBodyTruncated, isFalse);
  });

  test('秘密のヘッダーの値を伏せる', () {
    final entry = add(
      requestHeaders: {
        'Authorization': 'Bearer token',
        'cookie': 'session=1',
        'accept': 'application/json',
      },
    );

    expect(entry.requestHeaders, {
      'Authorization': '***',
      'cookie': '***',
      'accept': 'application/json',
    });
  });

  test('clear しても id は戻さない', () {
    add();
    log.clear();

    expect(log.entries, isEmpty);
    expect(add().id, 2);
  });
}
