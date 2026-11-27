import 'dart:convert';

import 'package:yaml/yaml.dart';

/// OpenAPI の仕様書のうち、モックサーバーが応答を作るのに使う部分。
final class OpenApiDocument {
  new _(this.operations, this.basePath, this.skippedPaths);

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
    final skippedPaths = <String>[];
    for (final MapEntry(key: path, value: pathItem) in paths.entries) {
      if (path.startsWith('x-')) {
        continue;
      }
      final item = resolver.resolve(pathItem);
      if (item is! Map<String, Object?>) {
        skippedPaths.add(path);
        continue;
      }
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
    return OpenApiDocument._(
      List.unmodifiable(operations),
      _basePath(root['servers']),
      List.unmodifiable(skippedPaths),
    );
  }

  /// 仕様書にある operation。
  final List<Operation> operations;

  /// `servers` の 1 つ目の URL のパス（`/v1` など）。パスがなければ空文字。
  final String basePath;

  /// 中身を読めず、読み飛ばしたパス（ほかのファイルへの `$ref` など）。
  final List<String> skippedPaths;

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

/// 生成したクライアントの既定の URL と同じく、`servers` の 1 つ目の URL から
/// パスを取り出す。URL の変数は `default` の値で埋める。
String _basePath(Object? servers) {
  if (servers is! List<Object?> || servers.isEmpty) {
    return '';
  }
  final (template, variables) = switch (servers.first) {
    {'url': final String url, 'variables': final Map<String, Object?> vars} => (
      url,
      vars,
    ),
    {'url': final String url} => (url, const <String, Object?>{}),
    _ => throw const FormatException('servers の 1 つ目に url がありません。'),
  };
  final url = template.replaceAllMapped(RegExp(r'\{([^}]*)\}'), (match) {
    if (variables[match[1]] case {'default': final Object value}) {
      return '$value';
    }
    throw FormatException('servers の url の変数 {${match[1]}} に default がありません。');
  });
  final Uri uri;
  try {
    uri = Uri.parse(url);
  } on FormatException {
    throw FormatException('servers の url「$url」を URL として読めません。');
  }
  // Request.url と比べられるよう、パーセントエンコードしたままのパスを使う。
  final path = uri.path.replaceFirst(RegExp(r'/+$'), '');
  return path.isEmpty || path.startsWith('/') ? path : '/$path';
}

/// 仕様書の operation と、モックサーバーがそれに返す応答。
final class Operation {
  new _({
    required this.method,
    required this.path,
    required this.response,
    required this.errorResponses,
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
    final responses = switch (resolver.resolve(operation['responses'])) {
      final Map<String, Object?> responses => responses,
      _ => const <String, Object?>{},
    };
    return Operation._(
      method: method,
      path: path,
      operationId: operationId,
      response: _mockResponse(label, responses, resolver),
      errorResponses: Map.unmodifiable({
        for (final MapEntry(:key, :value) in responses.entries)
          if (_errorStatusCode.hasMatch(key))
            int.parse(key): _responseOf(
              label,
              statusCode: int.parse(key),
              key: key,
              response: value,
              resolver: resolver,
            ),
      }),
    );
  }

  /// HTTP のメソッド（大文字）。
  final String method;

  /// 仕様書のパス（`/items/{itemId}` など）。
  final String path;

  final String? operationId;

  /// 既定で返す応答。
  final MockResponse response;

  /// 仕様書にある 3xx、4xx、5xx の応答。キーはステータスコード。
  ///
  /// 管理画面でエラーを注入するときに選ぶ。`4XX` や `default` は含めない。
  final Map<int, MockResponse> errorResponses;

  /// operation を示すキー（`GET /items/{itemId}` など）。
  ///
  /// operationId は省略できるため、メソッドとパスから作る。
  String get key => '$method $path';

  /// ログやエラーで operation を示す名前。
  String get label => _label(method, path, operationId);

  static String _label(String method, String path, String? operationId) =>
      operationId == null ? '$method $path' : '$method $path ($operationId)';
}

/// モックサーバーが operation に返す応答。
sealed class MockResponse;

/// 仕様書の example から作った応答。
final class ExampleResponse extends MockResponse {
  new({
    required this.statusCode,
    this.contentType,
    this.body,
    this.description,
  });

  final int statusCode;

  /// 仕様書の応答の description。
  final String? description;

  /// content のない応答では null。
  final String? contentType;

  /// content のない応答では null。
  final String? body;
}

/// example がないなどの理由で、仕様書から作れなかった応答。
final class MissingExample extends MockResponse {
  new(this.reason, {this.statusCode, this.description});

  final String reason;

  /// 仕様書の応答の description。
  final String? description;

  /// 仕様書の応答のステータスコード。応答を選べなかったときは null。
  final int? statusCode;
}

final _errorStatusCode = RegExp(r'^[3-5]\d\d$');

MockResponse _mockResponse(
  String label,
  Map<String, Object?> responses,
  _RefResolver resolver,
) {
  final selected = _selectResponse(responses);
  if (selected == null) {
    return MissingExample('$label に 2xx と default の応答がありません。');
  }
  final (:statusCode, :key, :response) = selected;
  return _responseOf(
    label,
    statusCode: statusCode,
    key: key,
    response: response,
    resolver: resolver,
  );
}

/// 仕様書の responses の [key] の応答 1 つから、モックサーバーの応答を作る。
MockResponse _responseOf(
  String label, {
  required int statusCode,
  required String key,
  required Object? response,
  required _RefResolver resolver,
}) {
  final resolved = resolver.resolve(response);
  if (resolved is! Map<String, Object?>) {
    return MissingExample(
      '$label の $key の応答を読めません。\$ref の参照先を確かめてください。',
      statusCode: statusCode,
    );
  }
  final description = switch (resolved['description']) {
    final String description => description,
    _ => null,
  };
  final content = switch (resolved['content']) {
    final Map<String, Object?> content when content.isNotEmpty => content,
    _ => null,
  };
  if (content == null) {
    return ExampleResponse(statusCode: statusCode, description: description);
  }

  final mediaType = _selectMediaType(content.keys);
  final where = '$label の $key の応答（$mediaType）';
  final example = _findExample(resolver.resolve(content[mediaType]), resolver);
  if (example == null) {
    return MissingExample(
      _hasUnresolvedRef(content[mediaType], resolver)
          ? '$whereの \$ref を読めません。\$ref の参照先を確かめてください。ほかのファイルへの \$ref は読めません。'
          : '$whereに example がありません。仕様書に example を書いてください。',
      statusCode: statusCode,
      description: description,
    );
  }
  final value = example.value;
  final wildcard = _baseType(mediaType).contains('*');
  final json = _isJson(mediaType) || (wildcard && value is! String);
  if (!json && (value is Map || value is List)) {
    return MissingExample(
      '$whereの example はオブジェクトか配列のため、本文にできません。example を文字列で書いてください。',
      statusCode: statusCode,
      description: description,
    );
  }
  if (json && _hasNonFiniteNumber(value)) {
    return MissingExample(
      '$whereの example に NaN か Infinity があり、JSON で表せません。',
      statusCode: statusCode,
      description: description,
    );
  }
  return ExampleResponse(
    statusCode: statusCode,
    description: description,
    contentType: _contentType(mediaType, json: json, wildcard: wildcard),
    body: json ? jsonEncode(value) : '$value',
  );
}

/// media type、その `schema`、`examples` の最初の値に、読めない `$ref` があるかを返す。
bool _hasUnresolvedRef(Object? mediaType, _RefResolver resolver) {
  bool unresolved(Object? value) =>
      value is Map<String, Object?> &&
      value.containsKey(r'$ref') &&
      resolver.resolve(value) == null;

  if (unresolved(mediaType)) {
    return true;
  }
  final resolved = resolver.resolve(mediaType);
  if (resolved is! Map<String, Object?>) {
    return false;
  }
  return unresolved(resolved['schema']) ||
      switch (resolved['examples']) {
        final Map<String, Object?> examples when examples.isNotEmpty =>
          unresolved(examples.values.first),
        _ => false,
      };
}

/// `*/*` のようなワイルドカードは Content-Type に使えないため、本文に合わせて
/// JSON か文字列の media type にする。
String _contentType(
  String mediaType, {
  required bool json,
  required bool wildcard,
}) {
  if (wildcard) {
    return json
        ? 'application/json; charset=utf-8'
        : 'text/plain; charset=utf-8';
  }
  return json && !mediaType.contains(';')
      ? '$mediaType; charset=utf-8'
      : mediaType;
}

bool _hasNonFiniteNumber(Object? value) => switch (value) {
  final double number => !number.isFinite,
  final Map<String, Object?> map => map.values.any(_hasNonFiniteNumber),
  final List<Object?> list => list.any(_hasNonFiniteNumber),
  _ => false,
};

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
  final key =
      responses.keys.where((key) => key.toUpperCase() == '2XX').firstOrNull ??
      (responses.containsKey('default') ? 'default' : null);
  if (key == null) {
    return null;
  }
  return (statusCode: 200, key: key, response: responses[key]);
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

/// media type の `example`、`examples` の最初の `value`、`schema` の `example`、
/// `schema` の `examples` の最初の値の順に探す。example の値が null のことも
/// あるため、見つからなければレコードごと null を返す。
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
  final schema = resolver.resolve(mediaType['schema']);
  if (schema case {'example': final value}) {
    return (value: value);
  }
  // OpenAPI 3.1 では、schema の example の代わりに JSON Schema の examples を使う。
  if (schema case {'examples': [final value, ...]}) {
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
      final key = _decodeToken(token);
      if (key == null) {
        return null;
      }
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

  /// JSON Pointer の 1 区間を、パーセントエンコードと `~1`、`~0` を戻して返す。
  /// 戻せない区間は null を返す。
  static String? _decodeToken(String token) {
    // `%` のあとに 16 進数が 2 桁続かないと、Uri.decodeComponent は
    // ArgumentError を投げる。
    if (RegExp('%(?![0-9A-Fa-f]{2})').hasMatch(token)) {
      return null;
    }
    try {
      return Uri.decodeComponent(
        token,
      ).replaceAll('~1', '/').replaceAll('~0', '~');
    } on FormatException {
      return null;
    }
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
