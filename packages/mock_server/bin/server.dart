import 'dart:io';

import 'package:args/args.dart';
import 'package:internal_mock_server/internal_mock_server.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

/// `openapi/<api_name>/openapi.yaml` の example を返すモックサーバーを起動する。
///
/// リポジトリのルートで `mise run mock [<api_name>] [--port <port>]` として実行する。
Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('port', abbr: 'p', help: '待ち受けるポート', defaultsTo: '4000')
    ..addFlag('help', abbr: 'h', negatable: false, help: '使い方を表示する');

  final ArgResults results;
  try {
    results = parser.parse(arguments);
  } on FormatException catch (e) {
    _usageError(e.message, parser);
  }
  if (results.flag('help')) {
    stdout.writeln(_usage(parser));
    return;
  }
  final port = int.tryParse(results.option('port')!);
  if (port == null || port < 0 || port > 65535) {
    _usageError('ポートには 0 から 65535 の数を指定してください。', parser);
  }
  if (results.rest.length > 1) {
    _usageError('API 名は 1 つだけ指定してください。', parser);
  }

  final File specFile;
  try {
    specFile = ApiDirectory(
      Directory('openapi'),
    ).specFile(apiName: results.rest.firstOrNull);
  } on ApiSelectionException catch (e) {
    _usageError(e.message, parser);
  }

  final OpenApiDocument document;
  try {
    document = OpenApiDocument.parse(specFile.readAsStringSync());
  } on FormatException catch (e) {
    stderr.writeln('${specFile.path} を読めません: ${e.message}');
    exit(1);
  } on FileSystemException catch (e) {
    stderr.writeln(
      '${specFile.path} を読めません: ${e.osError?.message ?? e.message}',
    );
    exit(1);
  }

  final HttpServer server;
  try {
    server = await shelf_io.serve(
      const Pipeline()
          .addMiddleware(logRequests())
          .addHandler(
            mountAtBasePath(document.basePath, createMockHandler(document)),
          ),
      InternetAddress.loopbackIPv4,
      port,
    );
  } on SocketException catch (e) {
    stderr
      ..writeln('ポート $port で待ち受けられません: ${e.osError?.message ?? e.message}')
      ..writeln('--port で別のポートを指定してください。');
    exit(1);
  }

  stdout.writeln(
    '${specFile.path} のモックサーバーを '
    'http://${server.address.host}:${server.port}${document.basePath} '
    'で起動しました。',
  );
  if (document.skippedPaths.isNotEmpty) {
    stdout.writeln(r'次のパスは中身を読めないため、読み飛ばしました。ほかのファイルへの $ref は読めません。');
    for (final path in document.skippedPaths) {
      stdout.writeln('  - $path');
    }
  }
  final missing = [
    for (final operation in document.operations)
      if (operation.response case MissingExample(:final reason)) reason,
  ];
  if (missing.isNotEmpty) {
    stdout.writeln('次の operation には 501 を返します。');
    for (final reason in missing) {
      stdout.writeln('  - $reason');
    }
  }
}

String _usage(ArgParser parser) => [
  '使い方: mise run mock [<api_name>] [--port <port>]',
  '',
  'openapi/<api_name>/openapi.yaml の example を返すモックサーバーを起動します。',
  'API が 1 つだけなら <api_name> は省略できます。',
  '',
  parser.usage,
].join('\n');

Never _usageError(String message, ArgParser parser) {
  stderr
    ..writeln(message)
    ..writeln()
    ..writeln(_usage(parser));
  exit(64);
}
