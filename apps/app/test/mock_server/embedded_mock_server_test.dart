import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/mock_server/embedded_mock_server.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // testWidgets は HttpClient を差し替えるため、本物の通信を送れる test を使う。
  test('起動したモックサーバーが、仕様書の example を返す', () async {
    final baseUrl = await startEmbeddedMockServer();

    final client = HttpClient();
    addTearDown(client.close);
    final request = await client.getUrl(Uri.parse('$baseUrl/items/1'));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();

    expect(Uri.parse(baseUrl).host, '127.0.0.1');
    expect(response.statusCode, HttpStatus.ok);
    expect(jsonDecode(body), containsPair('id', '1'));
  });
}
