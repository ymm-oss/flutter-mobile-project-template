import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'package:internal_mock_server/src/asset_resolver.dart';
import 'package:internal_mock_server/src/mock_settings.dart';
import 'package:internal_mock_server/src/openapi_document.dart';
import 'package:shelf/shelf.dart';

/// 管理画面を置くパス。
const adminPath = '/_admin';

/// [adminPath] の下へのリクエストを [admin] に、ほかを [handler] に渡す
/// [Handler] を作る。
///
/// [admin] は [adminPath] を除いたパスを [Request.url] として受ける。
Handler mountAdmin(Handler admin, Handler handler) {
  final prefix = adminPath.substring(1);
  return (request) {
    final path = request.url.path;
    // Request.change は区間の境目を確かめないため、/_administrator などを先に除く。
    if (path != prefix && !path.startsWith('$prefix/')) {
      return handler(request);
    }
    return admin(request.change(path: prefix));
  };
}

/// 管理画面と、その画面が使う JSON API の [Handler] を作る。
///
/// - `GET /`: 管理画面（`assets/admin/index.html`）
/// - `GET /api/operations`: operation の一覧と、それぞれの設定
/// - `PUT /api/operations/<key>`: operation の設定を変える
/// - `DELETE /api/operations/<key>`: operation の設定を既定に戻す
/// - `DELETE /api/operations`: すべての operation の設定を既定に戻す
///
/// `<key>` は `Operation.key` をパーセントエンコードしたもの。
Handler createAdminHandler(
  OpenApiDocument document,
  MockSettings settings, {
  required AssetResolver assets,
}) {
  final operations = {
    for (final operation in document.operations) operation.key: operation,
  };
  Response operationResponse(Operation operation) =>
      _json(200, _operationToJson(operation, settings.of(operation.key)));

  return (request) async {
    final method = request.method;
    switch (request.url.pathSegments) {
      case [] when method == 'GET' || method == 'HEAD':
        // 末尾の / がないと、index.html から相対パスで読むファイルの場所がずれる。
        if (!request.requestedUri.path.endsWith('/')) {
          return Response.found('${request.requestedUri.path}/');
        }
        return await _asset(assets, 'index.html');
      case [final file]
          when (method == 'GET' || method == 'HEAD') &&
              _assetContentTypes.containsKey(file):
        return await _asset(assets, file);
      case ['api', 'operations']:
        switch (method) {
          case 'GET':
            return _json(200, {
              'operations': [
                for (final operation in document.operations)
                  _operationToJson(operation, settings.of(operation.key)),
              ],
            });
          case 'DELETE':
            settings.resetAll();
            return Response(204);
        }
        return _error(405, '$method には応答しません。', allow: 'GET, DELETE');
      case ['api', 'operations', final key]:
        final operation = operations[key];
        if (operation == null) {
          return _error(404, '仕様書に $key の operation がありません。');
        }
        switch (method) {
          case 'GET':
            return operationResponse(operation);
          case 'PUT':
            final Object? json;
            try {
              json = jsonDecode(await request.readAsString());
            } on FormatException {
              return _error(400, '本文を JSON として読めません。');
            }
            final OperationSettings updated;
            try {
              updated = _settingsFromJson(json, operation);
            } on FormatException catch (e) {
              return _error(400, e.message);
            }
            settings.update(key, updated);
            return operationResponse(operation);
          case 'DELETE':
            settings.reset(key);
            return operationResponse(operation);
        }
        return _error(405, '$method には応答しません。', allow: 'GET, PUT, DELETE');
    }
    return _error(404, '管理画面に ${request.requestedUri.path} はありません。');
  };
}

/// 管理画面のファイルと、その Content-Type。ここにあるファイルだけを配信する。
const _assetContentTypes = {
  'index.html': 'text/html; charset=utf-8',
  'admin.css': 'text/css; charset=utf-8',
  'admin.js': 'text/javascript; charset=utf-8',
};

Future<Response> _asset(AssetResolver assets, String file) async {
  final path = 'admin/$file';
  try {
    return Response.ok(
      await assets(path),
      headers: {
        'content-type': _assetContentTypes[file]!,
        // モックサーバーを更新したあとも、古い画面を使わないようにする。
        'cache-control': 'no-store',
      },
    );
  } on Exception catch (e) {
    return _error(500, '管理画面のファイル $path を読めません: $e');
  }
}

Map<String, Object?> _operationToJson(
  Operation operation,
  OperationSettings settings,
) => {
  'key': operation.key,
  'method': operation.method,
  'path': operation.path,
  'operationId': operation.operationId,
  'response': _mockResponseToJson(operation.response),
  'errorResponses': [
    for (final response in operation.errorResponses.values)
      _mockResponseToJson(response),
  ],
  'settings': {
    'response': switch (settings.response) {
      null => null,
      EditedResponse(:final statusCode, :final contentType, :final body) => {
        'type': 'edited',
        'statusCode': statusCode,
        'contentType': contentType,
        'body': body,
      },
      SpecErrorResponse(:final statusCode) => {
        'type': 'specError',
        'statusCode': statusCode,
      },
    },
    'delayMs': settings.delay.inMilliseconds,
  },
};

Map<String, Object?> _mockResponseToJson(MockResponse response) =>
    switch (response) {
      ExampleResponse(
        :final statusCode,
        :final description,
        :final contentType,
        :final body,
      ) =>
        {
          'statusCode': statusCode,
          'description': description,
          'contentType': contentType,
          'body': body,
        },
      MissingExample(:final statusCode, :final description, :final reason) => {
        'statusCode': statusCode,
        'description': description,
        'missing': reason,
      },
    };

/// 管理画面から受けた設定を読む。不正な値なら [FormatException] を投げる。
OperationSettings _settingsFromJson(Object? json, Operation operation) {
  if (json is! Map<String, Object?>) {
    throw const FormatException('設定はオブジェクトで送ってください。');
  }
  final response = switch (json['response']) {
    null => null,
    {
      'type': 'edited',
      'statusCode': final int statusCode,
      'contentType': final String contentType,
      'body': final String body,
    } =>
      EditedResponse(
        statusCode: _statusCode(statusCode),
        contentType: _contentType(contentType),
        body: body,
      ),
    {'type': 'edited'} => throw const FormatException(
      '編集した応答には statusCode、contentType、body を指定してください。',
    ),
    {'type': 'specError', 'statusCode': final int statusCode}
        when operation.errorResponses.containsKey(statusCode) =>
      SpecErrorResponse(statusCode),
    {'type': 'specError', 'statusCode': final int statusCode} =>
      throw FormatException('仕様書の ${operation.key} に $statusCode の応答がありません。'),
    {'type': 'specError'} => throw const FormatException(
      '仕様書の応答には statusCode を整数で指定してください。',
    ),
    _ => throw const FormatException(
      'response の type には edited か specError を指定してください。',
    ),
  };
  final delay = switch (json['delayMs'] ?? 0) {
    final int ms when ms >= 0 => Duration(milliseconds: ms),
    _ => throw const FormatException('delayMs には 0 以上の整数を指定してください。'),
  };
  return OperationSettings(response: response, delay: delay);
}

int _statusCode(int statusCode) {
  if (statusCode < 200 || statusCode > 599) {
    throw const FormatException('ステータスコードには 200 から 599 を指定してください。');
  }
  return statusCode;
}

/// shelf は ASCII でない本文を返すときに Content-Type を読み、読めないと例外を
/// 投げる。応答を返すときに 500 にならないよう、受けた時点で確かめる。
///
/// dart:io は、表示できる ASCII の文字でないヘッダーの値を書き出せず、応答を
/// 返さないまま止まる。全角の空白などが入らないよう、これも受けた時点で確かめる。
String _contentType(String contentType) {
  if (contentType.codeUnits.any((unit) => unit < 0x20 || unit > 0x7e)) {
    throw FormatException(
      'Content-Type「$contentType」には、表示できる ASCII の文字だけを指定してください。',
    );
  }
  try {
    MediaType.parse(contentType);
  } on FormatException {
    throw FormatException(
      'Content-Type「$contentType」を読めません。application/json のように指定してください。',
    );
  }
  return contentType;
}

Response _json(int statusCode, Object? body) => Response(
  statusCode,
  body: jsonEncode(body),
  headers: {'content-type': 'application/json; charset=utf-8'},
);

Response _error(int statusCode, String message, {String? allow}) => Response(
  statusCode,
  body: jsonEncode({'message': message}),
  headers: {
    'content-type': 'application/json; charset=utf-8',
    'allow': ?allow,
  },
);
