import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:internal_mock_server/internal_mock_server.dart';

/// アプリに組み込むモックサーバーのために、`openapi/<api_name>/openapi.yaml` を
/// Dart の文字列定数にしたファイルを書く。
///
/// Flutter の assets は tree shaking で外れないため、定数にして持たせる。
/// リポジトリのルートで `mise run gen` から実行する。
Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('output', abbr: 'o', mandatory: true, help: '書き出す Dart のファイル');

  final ArgResults results;
  try {
    results = parser.parse(arguments);
  } on FormatException catch (e) {
    _fail(e.message);
  }
  if (results.rest.length > 1) {
    _fail('API 名は 1 つだけ指定してください。');
  }

  final apiDirectory = ApiDirectory(Directory('openapi'));
  final apiName = results.rest.firstOrNull;
  final File specFile;
  try {
    specFile = apiDirectory.specFile(apiName: apiName);
  } on ApiSelectionException catch (e) {
    if (apiName == null && apiDirectory.apiNames().length > 1) {
      _fail(
        '${e.message}\n'
        '組み込む API 名を、ルートの pubspec.yaml の gen:embedded_mock_spec の '
        'run の末尾に書いてください。',
      );
    }
    _fail(e.message);
  }

  final spec = specFile.readAsStringSync();
  try {
    OpenApiDocument.parse(spec);
  } on FormatException catch (e) {
    _fail('${specFile.path} を読めません: ${e.message}');
  }

  // JSON の文字列のエスケープは Dart の文字列リテラルでも使える。`$` だけは
  // 補間と解釈されるため、エスケープを足す。
  final literal = jsonEncode(spec).replaceAll(r'$', r'\$');
  final output = File(results.option('output')!);
  await output.parent.create(recursive: true);
  await output.writeAsString('''
// GENERATED CODE - DO NOT MODIFY BY HAND
// ${specFile.path} から `mise run gen` で生成する。
// ignore_for_file: type=lint

/// アプリに組み込むモックサーバーが読む仕様書。
const embeddedMockSpec = $literal;
''');
  stdout.writeln('${specFile.path} から ${output.path} を書きました。');
}

Never _fail(String message) {
  stderr.writeln(message);
  exit(1);
}
