import 'package:http_parser/http_parser.dart';
import 'package:internal_mock_server/src/mock_settings.dart';
import 'package:internal_mock_server/src/openapi_document.dart';

/// [settings] を、管理用の JSON API とプロファイルで使う JSON にする。
Map<String, Object?> operationSettingsToJson(OperationSettings settings) => {
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
};

/// [operation] の設定を JSON から読む。不正な値なら [FormatException] を投げる。
OperationSettings operationSettingsFromJson(Object? json, Operation operation) {
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
