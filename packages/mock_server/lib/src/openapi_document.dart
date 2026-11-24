import 'dart:convert';

import 'package:yaml/yaml.dart';

/// OpenAPI の仕様書のうち、モックサーバーが応答を作るのに使う部分。
final class OpenApiDocument {
  new _(this.operations);

  /// YAML または JSON の仕様書を読む。
  ///
  /// 仕様書として読めないときは [FormatException] を投げる。
  factory parse(String source) {
    final Object? root;
    try {
      root = _toPlain(loadYaml(source));
    } on YamlException catch (e) {
      throw FormatException('仕様書を YAML として読めません: ${e.message}');
    }
    if (root is! Map<String, Object?>) {
      throw const FormatException('仕様書の最上位がオブジェクトではありません。');
    }
    final paths = root['paths'];
    if (paths is! Map<String, Object?>) {
      throw const FormatException('仕様書に paths がありません。');
    }

    final resolver = _RefResolver(root);
    final operations = <Operation>[];
    for (final MapEntry(key: path, value: pathItem) in paths.entries) {
      if (resolver.resolve(pathItem) case final Map<String, Object?> item) {
        for (final method in _methods) {
          if (resolver.resolve(item[method])
              case final Map<String, Object?> operation) {
            operations.add(
              Operation._fromSpec(
                method: method.toUpperCase(),
                path: path,
                operation: operation,
                resolver: resolver,
              ),
            );
          }
        }
      }
    }
    return OpenApiDocument._(List.unmodifiable(operations));
  }

  /// 仕様書にある operation。
  final List<Operation> operations;

  static const _methods = [
    'get',
    'put',
    'post',
    'delete',
    'options',
    'head',
    'patch',
    'trace',
  ];
}

/// 仕様書の operation と、モックサーバーがそれに返す応答。
final class Operation {
  new _({
    required this.method,
    required this.path,
    required this.response,
    this.operationId,
  });

  factory _fromSpec({
    required String method,
    required String path,
    required Map<String, Object?> operation,
    required _RefResolver resolver,
  }) {
    final operationId = switch (operation['operationId']) {
      final String id => id,
      _ => null,
    };
    final label = _label(method, path, operationId);
    return Operation._(
      method: method,
      path: path,
      operationId: operationId,
      response: _mockResponse(label, operation['responses'], resolver),
    );
  }

  /// HTTP のメソッド（大文字）。
  final String method;

  /// 仕様書のパス（`/items/{itemId}` など）。
  final String path;

  final String? operationId;

  final MockResponse response;

  /// ログやエラーで operation を示す名前。
  String get label => _label(method, path, operationId);

  static String _label(String method, String path, String? operationId) =>
      operationId == null ? '$method $path' : '$method $path ($operationId)';
}

/// モックサーバーが operation に返す応答。
sealed class MockResponse;

/// 仕様書の example から作った応答。
final class ExampleResponse extends MockResponse {
  new({required this.statusCode, this.contentType, this.body});

  final int statusCode;

  /// content のない応答では null。
  final String? contentType;

  /// content のない応答では null。
  final String? body;
}

/// example がないなどの理由で、仕様書から作れなかった応答。
final class MissingExample extends MockResponse {
  new(this.reason);

  final String reason;
}

MockResponse _mockResponse(
  String label,
  Object? responses,
  _RefResolver resolver,
) {
  final selected = switch (resolver.resolve(responses)) {
    final Map<String, Object?> responses => _selectResponse(responses),
    _ => null,
  };
  if (selected == null) {
    return MissingExample('$label に 2xx と default の応答がありません。');
  }
  final (:statusCode, :key, :response) = selected;
  final resolved = resolver.resolve(response);
  if (resolved is! Map<String, Object?>) {
    return MissingExample('$label の $key の応答を読めません。\$ref の参照先を確かめてください。');
  }
  final content = switch (resolved['content']) {
    final Map<String, Object?> content when content.isNotEmpty => content,
    _ => null,
  };
  if (content == null) {
    return ExampleResponse(statusCode: statusCode);
  }

  final mediaType = _selectMediaType(content.keys);
  final example = _findExample(resolver.resolve(content[mediaType]), resolver);
  if (example == null) {
    return MissingExample(
      '$label の $key の応答（$mediaType）に example がありません。仕様書に example を書いてください。',
    );
  }
  final json = _isJson(mediaType);
  return ExampleResponse(
    statusCode: statusCode,
    contentType: json && !mediaType.contains(';')
        ? '$mediaType; charset=utf-8'
        : mediaType,
    body: switch (example.value) {
      final String value when !json => value,
      final value => jsonEncode(value),
    },
  );
}

/// 2xx のうち最も小さいコード、`2XX`、`default` の順に応答を選ぶ。
({int statusCode, String key, Object? response})? _selectResponse(
  Map<String, Object?> responses,
) {
  final codes =
      responses.keys.where((key) => RegExp(r'^2\d\d$').hasMatch(key)).toList()
        ..sort();
  if (codes.isNotEmpty) {
    final key = codes.first;
    return (statusCode: int.parse(key), key: key, response: responses[key]);
  }
  for (final key in responses.keys) {
    if (key.toUpperCase() == '2XX' || key == 'default') {
      return (statusCode: 200, key: key, response: responses[key]);
    }
  }
  return null;
}

/// `application/json`、ほかの JSON 系、最初のものの順に media type を選ぶ。
String _selectMediaType(Iterable<String> mediaTypes) => mediaTypes.firstWhere(
  (type) => _baseType(type) == 'application/json',
  orElse: () => mediaTypes.firstWhere(
    _isJson,
    orElse: () => mediaTypes.first,
  ),
);

bool _isJson(String mediaType) {
  final base = _baseType(mediaType);
  return base == 'application/json' || base.endsWith('+json');
}

String _baseType(String mediaType) =>
    mediaType.split(';').first.trim().toLowerCase();

/// media type の `example`、`examples` の最初の `value`、`schema` の `example`
/// の順に探す。example の値が null のこともあるため、見つからなければ
/// レコードごと null を返す。
({Object? value})? _findExample(Object? mediaType, _RefResolver resolver) {
  if (mediaType is! Map<String, Object?>) {
    return null;
  }
  if (mediaType case {'example': final value}) {
    return (value: value);
  }
  if (mediaType case {'examples': final Map<String, Object?> examples}
      when examples.isNotEmpty) {
    if (resolver.resolve(examples.values.first) case {'value': final value}) {
      return (value: value);
    }
  }
  if (resolver.resolve(mediaType['schema']) case {'example': final value}) {
    return (value: value);
  }
  return null;
}

/// 仕様書の中の `$ref`（`#/...`）を解決する。
final class _RefResolver {
  new(this._root);

  final Map<String, Object?> _root;

  /// [value] が `$ref` のオブジェクトなら、参照先を返す。
  ///
  /// ほかのファイルへの参照、存在しない参照、循環した参照は null を返す。
  Object? resolve(Object? value) {
    final visited = <String>{};
    var current = value;
    while (true) {
      if (current case {r'$ref': final String ref}) {
        if (!ref.startsWith('#/') || !visited.add(ref)) {
          return null;
        }
        current = _pointer(ref.substring(2));
      } else {
        return current;
      }
    }
  }

  Object? _pointer(String pointer) {
    Object? current = _root;
    for (final token in pointer.split('/')) {
      final key = Uri.decodeComponent(
        token,
      ).replaceAll('~1', '/').replaceAll('~0', '~');
      current = switch (current) {
        final Map<String, Object?> map => map[key],
        final List<Object?> list => switch (int.tryParse(key)) {
          final index? when index >= 0 && index < list.length => list[index],
          _ => null,
        },
        _ => null,
      };
    }
    return current;
  }
}

/// YAML の値を、Dart の Map と List に変える。
Object? _toPlain(Object? node) => switch (node) {
  final Map<Object?, Object?> map => {
    for (final MapEntry(:key, :value) in map.entries) '$key': _toPlain(value),
  },
  final List<Object?> list => [for (final value in list) _toPlain(value)],
  _ => node,
};
