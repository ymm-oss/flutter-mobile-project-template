import 'dart:convert';

import 'package:internal_mock_server/src/openapi_document.dart';
import 'package:shelf/shelf.dart';

/// [document] の operation にリクエストを振り分け、仕様書の example を返す
/// [Handler] を作る。
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
      if (route.operations[request.method] case final operation?) {
        return _respond(operation.response);
      }
    }
    final allowed = {for (final route in matched) ...route.operations.keys};
    return _error(
      405,
      '仕様書の ${matched.first.path} に ${request.method} の operation がありません。',
      headers: {'allow': allowed.join(', ')},
    );
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
List<_Route> _routesOf(List<Operation> operations) {
  final byPath = <String, Map<String, Operation>>{};
  for (final operation in operations) {
    (byPath[operation.path] ??= {})[operation.method] = operation;
  }
  return [
    for (final MapEntry(key: path, value: operations) in byPath.entries)
      _Route(path, operations),
  ]..sort((a, b) => a.compareTo(b));
}

final class _Route {
  new(this.path, this.operations)
    : _segments = [for (final segment in _split(path)) _Segment(segment)];

  final String path;

  /// メソッドごとの operation。
  final Map<String, Operation> operations;

  final List<_Segment> _segments;

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
    final length = _segments.length < other._segments.length
        ? _segments.length
        : other._segments.length;
    for (var i = 0; i < length; i++) {
      final a = _segments[i].isTemplate;
      final b = other._segments[i].isTemplate;
      if (a != b) {
        return a ? 1 : -1;
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

  bool get isTemplate => _pattern != null;

  bool matches(String segment) =>
      _pattern?.hasMatch(segment) ?? segment == _source;

  static RegExp? _templatePattern(String source) {
    if (!source.contains('{')) {
      return null;
    }
    final pattern = source.splitMapJoin(
      RegExp(r'\{[^}]*\}'),
      onMatch: (_) => '[^/]+',
      onNonMatch: RegExp.escape,
    );
    return RegExp('^$pattern\$');
  }
}
