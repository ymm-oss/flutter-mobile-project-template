import 'dart:io';

import 'package:internal_mock_server/internal_mock_server.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('mock_server_test');
  });

  tearDown(() {
    root.deleteSync(recursive: true);
  });

  void addApi(String name) {
    File(p.join(root.path, name, 'openapi.yaml')).createSync(recursive: true);
  }

  Matcher throwsSelection(Object message) => throwsA(
    isA<ApiSelectionException>().having((e) => e.message, 'message', message),
  );

  test('openapi.yaml がある API 名を名前の順に返す', () {
    addApi('b');
    addApi('a');
    Directory(p.join(root.path, 'empty')).createSync();

    expect(ApiDirectory(root).apiNames(), ['a', 'b']);
  });

  test('API が 1 つなら、名前を省略してもその仕様書を返す', () {
    addApi('sample');

    expect(
      ApiDirectory(root).specFile().path,
      p.join(root.path, 'sample', 'openapi.yaml'),
    );
  });

  test('名前を指定すると、その API の仕様書を返す', () {
    addApi('a');
    addApi('b');

    expect(
      ApiDirectory(root).specFile(apiName: 'b').path,
      p.join(root.path, 'b', 'openapi.yaml'),
    );
  });

  test('API が複数あるのに名前を省略すると、一覧を添えて投げる', () {
    addApi('a');
    addApi('b');

    expect(
      () => ApiDirectory(root).specFile(),
      throwsSelection('API が複数あるため、API 名を指定してください。指定できる API: a, b'),
    );
  });

  test('ない API 名を指定すると、一覧を添えて投げる', () {
    addApi('a');

    expect(
      () => ApiDirectory(root).specFile(apiName: 'c'),
      throwsSelection('API「c」がありません。指定できる API: a'),
    );
  });

  test('API が 1 つもなければ投げる', () {
    expect(
      () => ApiDirectory(Directory(p.join(root.path, 'none'))).specFile(),
      throwsSelection(contains('<api_name>/openapi.yaml がありません。')),
    );
  });
}
