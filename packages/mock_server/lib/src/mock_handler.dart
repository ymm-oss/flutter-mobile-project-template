import 'dart:convert';

import 'package:internal_mock_server/src/openapi_document.dart';
import 'package:shelf/shelf.dart';

/// [document] の operation にリクエストを振り分け、仕様書の example を返す
/// [Handler] を作る。
///
/// [Request.url] を仕様書のパスと照合する。`servers` のパスの下に置くときは
/// [mountAtBasePath] と組み合わせる。
Handler createMockHandler(OpenApiDocument document) {
  final routes = _routesOf(document.operations);
  return (request) {
    final segments = request.url.pathSegments;
    final matched = [
      for (final route in routes)
        if (route.matches(segments)) route,
    ];
    if (matched.isEmpty) {
      return _error(404, '仕様書に /${request.url.path} のパスがありません。');
    }
    for (final route in matched) {
      if (route.operationFor(request.method) case final operation?) {
        // HEAD の本文は、dart:io の HttpServer が送らずに捨てる。
        return _respond(operation.response);
      }
    }
    final allowed = {for (final route in matched) ...route.allowedMethods};
    return _error(
      405,
      '仕様書の ${matched.first.path} に ${request.method} の operation がありません。',
      headers: {'allow': allowed.join(', ')},
    );
  };
}

/// [basePath]（`/v1` など）の下に [handler] を置いた [Handler] を作る。
///
/// [handler] は [basePath] を除いたパスを [Request.url] として受ける。
/// [basePath] の外へのリクエストには、[basePath] を案内する 404 を返す。
Handler mountAtBasePath(String basePath, Handler handler) {
  if (basePath.isEmpty) {
    return handler;
  }
  final prefix = basePath.substring(1);
  return (request) {
    final path = request.url.path;
    // Request.change は区間の境目を確かめないため、/v10 などを先に除く。
    if (path != prefix && !path.startsWith('$prefix/')) {
      return _error(
        404,
        '${request.requestedUri.path} は、仕様書の servers のパス $basePath の外にあります。'
        '$basePath から始まるパスに送ってください。',
      );
    }
    return handler(request.change(path: prefix));
  };
}

Response _respond(MockResponse response) => switch (response) {
  ExampleResponse(:final statusCode, :final contentType, :final body) =>
    Response(
      statusCode,
      // 204 と 304 は本文を持てない。
      body: statusCode == 204 || statusCode == 304 ? null : body,
      headers: {'content-type': ?contentType},
    ),
  MissingExample(:final reason) => _error(501, reason),
};

Response _error(
  int statusCode,
  String message, {
  Map<String, String>? headers,
}) => Response(
  statusCode,
  body: jsonEncode({'message': message}),
  headers: {'content-type': 'application/json; charset=utf-8', ...?headers},
);

/// OpenAPI の決まりに合わせ、テンプレートより固定のパスを先に照合する順に並べる。
///
/// 照合するのは区間の数が同じパスどうしなので、区間の数で分けてから、先頭の
/// 区間から [_Segment.rank] を比べる。順位が同じなら仕様書の順に並べる。
List<_Route> _routesOf(List<Operation> operations) {
  final byPath = <String, Map<String, Operation>>{};
  for (final operation in operations) {
    (byPath[operation.path] ??= {})[operation.method] = operation;
  }
  final routes = [
    for (final MapEntry(key: path, value: operations) in byPath.entries)
      _Route(path, operations),
  ];
  final order = {for (final (index, route) in routes.indexed) route: index};
  return routes..sort((a, b) {
    final result = a.compareTo(b);
    return result != 0 ? result : order[a]!.compareTo(order[b]!);
  });
}

final class _Route {
  new(this.path, this.operations)
    : _segments = [for (final segment in _split(path)) _Segment(segment)];

  final String path;

  /// メソッドごとの operation。
  final Map<String, Operation> operations;

  final List<_Segment> _segments;

  /// [method] に応える operation。HEAD は GET の operation で応える。
  Operation? operationFor(String method) =>
      operations[method] ?? (method == 'HEAD' ? operations['GET'] : null);

  /// Allow ヘッダーに載せるメソッド。
  Iterable<String> get allowedMethods => [
    for (final method in operations.keys) ...[
      method,
      if (method == 'GET' && !operations.containsKey('HEAD')) 'HEAD',
    ],
  ];

  bool matches(List<String> segments) {
    if (segments.length != _segments.length) {
      return false;
    }
    for (var i = 0; i < segments.length; i++) {
      if (!_segments[i].matches(segments[i])) {
        return false;
      }
    }
    return true;
  }

  int compareTo(_Route other) {
    if (_segments.length != other._segments.length) {
      return _segments.length.compareTo(other._segments.length);
    }
    for (var i = 0; i < _segments.length; i++) {
      final result = _segments[i].rank.compareTo(other._segments[i].rank);
      if (result != 0) {
        return result;
      }
    }
    return 0;
  }

  /// shelf の [Request.url] と同じく、先頭の `/` を除いて区切る。
  static List<String> _split(String path) {
    final relative = path.startsWith('/') ? path.substring(1) : path;
    return relative.isEmpty ? const [] : relative.split('/');
  }
}

/// パスの 1 区間。`{itemId}` や `{name}.json` のようなテンプレートは正規表現で照合する。
final class _Segment {
  new(this._source) : _pattern = _templatePattern(_source);

  final String _source;

  final RegExp? _pattern;

  /// 照合する順位。固定の区間が 0、`{name}.json` のように固定の部分を持つ
  /// テンプレートが 1、`{itemId}` のように全体がテンプレートの区間が 2。
  int get rank => switch (_pattern) {
    null => 0,
    _ when _source.replaceAll(_templateVariable, '').isNotEmpty => 1,
    _ => 2,
  };

  bool matches(String segment) =>
      _pattern?.hasMatch(segment) ?? segment == _source;

  static final _templateVariable = RegExp(r'\{[^}]*\}');

  static RegExp? _templatePattern(String source) {
    if (!source.contains('{')) {
      return null;
    }
    final pattern = source.splitMapJoin(
      _templateVariable,
      onMatch: (_) => '[^/]+',
      onNonMatch: RegExp.escape,
    );
    return RegExp('^$pattern\$');
  }
}
