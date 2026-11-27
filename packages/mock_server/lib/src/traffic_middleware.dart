import 'dart:convert';
import 'dart:typed_data';

import 'package:internal_mock_server/src/request_log.dart';
import 'package:shelf/shelf.dart';

const _contextKey = 'internal_mock_server.traffic';

/// [response] に、一致した operation と応答の出どころを載せる。
///
/// [logTraffic] が読んで、履歴に残す。
Response withTrafficInfo(
  Response response, {
  required String operationKey,
  required ResponseSource source,
}) => response.change(
  context: {_contextKey: (operationKey: operationKey, source: source)},
);

/// リクエストと応答を [log] に残す [Middleware] を作る。
///
/// 応答に [withTrafficInfo] で情報が載っていなければ、仕様書にないパスか
/// メソッドへのリクエストとして残す。
Middleware logTraffic(RequestLog log) =>
    (inner) => (request) async {
      final time = DateTime.now();
      final stopwatch = Stopwatch()..start();
      final requestBytes = await _readAll(request.read());
      final response = await inner(request.change(body: requestBytes));
      final responseBytes = await _readAll(response.read());
      stopwatch.stop();

      final info =
          response.context[_contextKey]
              as ({String operationKey, ResponseSource source})?;
      log.add(
        time: time,
        method: request.method,
        path: request.requestedUri.hasQuery
            ? '${request.requestedUri.path}?${request.requestedUri.query}'
            : request.requestedUri.path,
        operationKey: info?.operationKey,
        source: info?.source ?? ResponseSource.unmatched,
        statusCode: response.statusCode,
        duration: stopwatch.elapsed,
        requestHeaders: request.headers,
        requestBody: utf8.decode(requestBytes, allowMalformed: true),
        responseContentType: response.headers['content-type'],
        responseBody: utf8.decode(responseBytes, allowMalformed: true),
      );
      return response.change(body: responseBytes);
    };

Future<Uint8List> _readAll(Stream<List<int>> stream) async {
  final builder = BytesBuilder(copy: false);
  await stream.forEach(builder.add);
  return builder.takeBytes();
}
