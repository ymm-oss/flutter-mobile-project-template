// モックサーバーは、組み込みを有効にしないビルドに含めない。
// このファイルは `embedMockServer` で守った箇所からのみ参照されるため、
// 無効のビルドでは tree shaking によって除外される。

import 'dart:io';

import 'package:flutter_app/mock_server/embedded_mock_spec.g.dart';
import 'package:internal_mock_server/internal_mock_server.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

/// 仕様書の example を返すモックサーバーをアプリの中で起動し、その URL を返す。
///
/// [spec] を省くと、`mise run gen` で生成した仕様書を使う。
///
/// 端末の外からつながらないよう、`127.0.0.1` で待ち受ける。ポートは、手元の
/// モックサーバーやほかのシミュレーターとぶつからないよう、OS に選ばせる。
///
/// 組み込みを有効にしないビルドに含めないため、必ず `embedMockServer` で守って
/// 呼び出すこと。
Future<String> startEmbeddedMockServer({String spec = embeddedMockSpec}) async {
  final document = OpenApiDocument.parse(spec);
  final server = await shelf_io.serve(
    mountAtBasePath(
      document.basePath,
      createMockHandler(document, settings: MockSettings()),
    ),
    InternetAddress.loopbackIPv4,
    0,
  );
  return 'http://${server.address.host}:${server.port}${document.basePath}';
}
