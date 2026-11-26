import 'dart:convert';

import 'package:internal_mock_server/src/asset_resolver.dart';
import 'package:internal_mock_server/src/mock_settings.dart';
import 'package:internal_mock_server/src/openapi_document.dart';
import 'package:internal_mock_server/src/profile.dart';
import 'package:internal_mock_server/src/request_log.dart';
import 'package:internal_mock_server/src/settings_json.dart';
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
/// - `GET /api/traffic?after=<id>`: [log] の、`<id>` より新しい履歴の一覧
/// - `GET /api/traffic/<id>`: [log] の 1 件の、リクエストと応答の中身
/// - `DELETE /api/traffic`: [log] の履歴を消す
/// - `GET /api/profiles`: [profiles] に保存したプロファイルの一覧
/// - `POST /api/profiles/apply`: プロファイルを [settings] に入れる
/// - `PUT /api/profiles/local/<name>`: 今の設定を自分用のプロファイルに保存する
/// - `DELETE /api/profiles/local/<name>`: 自分用のプロファイルを消す
///
/// `<key>` は `Operation.key` をパーセントエンコードしたもの。
Handler createAdminHandler(
  OpenApiDocument document,
  MockSettings settings, {
  required AssetResolver assets,
  required RequestLog log,
  required ProfileStore profiles,
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
              updated = operationSettingsFromJson(json, operation);
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
      case ['api', 'traffic']:
        switch (method) {
          case 'GET':
            final after = switch (request.url.queryParameters['after']) {
              null => 0,
              final value => int.tryParse(value),
            };
            if (after == null) {
              return _error(400, 'after には整数を指定してください。');
            }
            return _json(200, {
              'lastId': log.lastId,
              'entries': [
                for (final entry in log.after(after))
                  _trafficSummaryToJson(entry),
              ],
            });
          case 'DELETE':
            log.clear();
            return Response(204);
        }
        return _error(405, '$method には応答しません。', allow: 'GET, DELETE');
      case ['api', 'traffic', final id]:
        if (method != 'GET') {
          return _error(405, '$method には応答しません。', allow: 'GET');
        }
        final entry = switch (int.tryParse(id)) {
          null => null,
          final id => log.entry(id),
        };
        if (entry == null) {
          return _error(404, '履歴に $id はありません。古い履歴は消えます。');
        }
        return _json(200, {
          ..._trafficSummaryToJson(entry),
          'requestHeaders': entry.requestHeaders,
          'requestBody': entry.requestBody,
          'requestBodyTruncated': entry.requestBodyTruncated,
          'responseContentType': entry.responseContentType,
          'responseBody': entry.responseBody,
          'responseBodyTruncated': entry.responseBodyTruncated,
        });
      case ['api', 'profiles']:
        if (method != 'GET') {
          return _error(405, '$method には応答しません。', allow: 'GET');
        }
        return _json(200, {
          'profiles': [
            for (final ref in await profiles.list())
              {'name': ref.name, 'shared': ref.shared},
          ],
        });
      case ['api', 'profiles', 'apply']:
        if (method != 'POST') {
          return _error(405, '$method には応答しません。', allow: 'POST');
        }
        final Object? json;
        try {
          json = jsonDecode(await request.readAsString());
        } on FormatException {
          return _error(400, '本文を JSON として読めません。');
        }
        if (json case {
          'name': final String name,
          'shared': final bool shared,
        }) {
          try {
            final text = await profiles.read((name: name, shared: shared));
            return _json(200, {
              'skipped': applyProfile(settings, text, document),
            });
          } on ProfileStoreException catch (e) {
            return _error(404, e.message);
          } on FormatException catch (e) {
            return _error(422, 'プロファイル「$name」を読めません。${e.message}');
          }
        }
        return _error(400, 'name を文字列で、shared を真偽値で指定してください。');
      case ['api', 'profiles', 'local', final name]:
        try {
          switch (method) {
            case 'PUT':
              await profiles.save(name, encodeProfile(exportProfile(settings)));
              return _json(200, {'name': name, 'shared': false});
            case 'DELETE':
              await profiles.delete(name);
              return Response(204);
          }
        } on ProfileStoreException catch (e) {
          return _error(method == 'PUT' ? 400 : 404, e.message);
        }
        return _error(405, '$method には応答しません。', allow: 'PUT, DELETE');
    }
    return _error(404, '管理画面に ${request.requestedUri.path} はありません。');
  };
}

/// 管理画面のファイルと、その Content-Type。ここにあるファイルだけを配信する。
const _assetContentTypes = {
  'index.html': 'text/html; charset=utf-8',
  'admin.css': 'text/css; charset=utf-8',
  'admin.js': 'text/javascript; charset=utf-8',
  'traffic.js': 'text/javascript; charset=utf-8',
  'profile.js': 'text/javascript; charset=utf-8',
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
  'settings': operationSettingsToJson(settings),
};

Map<String, Object?> _trafficSummaryToJson(TrafficEntry entry) => {
  'id': entry.id,
  'time': entry.time.toUtc().toIso8601String(),
  'method': entry.method,
  'path': entry.path,
  'operationKey': entry.operationKey,
  'source': entry.source.name,
  'statusCode': entry.statusCode,
  'durationMs': entry.duration.inMilliseconds,
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
