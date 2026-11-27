import 'dart:convert';

import 'package:internal_mock_server/internal_mock_server.dart';
import 'package:test/test.dart';

void main() {
  test('packageAssetResolver はパッケージの assets を読む', () async {
    final assets = await packageAssetResolver();

    for (final file in ['index.html', 'admin.css', 'admin.js']) {
      expect(await assets('admin/$file'), isNotEmpty, reason: file);
    }
    expect(utf8.decode(await assets('admin/index.html')), contains('admin.js'));
  });
}
