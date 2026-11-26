/// モックサーバーが受けたリクエストと、返した応答の履歴。
///
/// 画面に依存しないよう、shelf と dart:io を使わない。管理画面は JSON API を
/// 通して、この履歴を読む。
library;

/// 応答をどこから作ったか。
enum ResponseSource {
  /// 仕様書の応答（example がなく 501 を返したときも含む）。
  spec,

  /// 管理画面で編集した応答。
  edited,

  /// 仕様書にある 3xx、4xx、5xx の応答。
  specError,

  /// 仕様書にないパスかメソッドへのリクエストに返したエラー。
  unmatched,
}

/// 履歴の 1 件。
final class TrafficEntry {
  const new({
    required this.id,
    required this.time,
    required this.method,
    required this.path,
    required this.operationKey,
    required this.source,
    required this.statusCode,
    required this.duration,
    required this.requestHeaders,
    required this.requestBody,
    required this.requestBodyTruncated,
    required this.responseContentType,
    required this.responseBody,
    required this.responseBodyTruncated,
  });

  /// 1 から始まる連番。
  final int id;

  final DateTime time;

  final String method;

  /// クエリを含むパス。
  final String path;

  /// 一致した operation のキー（`Operation.key`）。一致しなければ null。
  final String? operationKey;

  final ResponseSource source;

  final int statusCode;

  /// リクエストを受けてから応答を作るまでの時間（遅延を含む）。
  final Duration duration;

  /// リクエストのヘッダー。秘密の値は伏せてある。
  final Map<String, String> requestHeaders;

  final String requestBody;

  /// [requestBody] を [RequestLog.maxBodyLength] で切ったかどうか。
  final bool requestBodyTruncated;

  final String? responseContentType;

  final String responseBody;

  /// [responseBody] を [RequestLog.maxBodyLength] で切ったかどうか。
  final bool responseBodyTruncated;
}

/// 履歴を新しいものから [maxEntries] 件までメモリーに持つ。
///
/// モックサーバーを起動し直すと消える。
final class RequestLog {
  /// 持つ件数の上限。超えたら古いものから消す。
  static const maxEntries = 200;

  /// 残す本文の長さ（文字数）の上限。超えた分は切り捨てる。
  static const int maxBodyLength = 256 * 1024;

  /// 値を伏せるヘッダー。
  static const maskedHeaders = {
    'authorization',
    'cookie',
    'proxy-authorization',
  };

  static const maskedValue = '***';

  final _entries = <TrafficEntry>[];

  var _lastId = 0;

  /// これまでに付けた最後の id。履歴がなければ 0。
  ///
  /// [clear] しても戻さない。
  int get lastId => _lastId;

  /// 古いものから並べた履歴。
  List<TrafficEntry> get entries => List.unmodifiable(_entries);

  /// 履歴に足し、足した 1 件を返す。
  TrafficEntry add({
    required DateTime time,
    required String method,
    required String path,
    required String? operationKey,
    required ResponseSource source,
    required int statusCode,
    required Duration duration,
    required Map<String, String> requestHeaders,
    required String requestBody,
    required String? responseContentType,
    required String responseBody,
  }) {
    final (request, requestTruncated) = _truncate(requestBody);
    final (response, responseTruncated) = _truncate(responseBody);
    final entry = TrafficEntry(
      id: ++_lastId,
      time: time,
      method: method,
      path: path,
      operationKey: operationKey,
      source: source,
      statusCode: statusCode,
      duration: duration,
      requestHeaders: {
        for (final MapEntry(:key, :value) in requestHeaders.entries)
          key: maskedHeaders.contains(key.toLowerCase()) ? maskedValue : value,
      },
      requestBody: request,
      requestBodyTruncated: requestTruncated,
      responseContentType: responseContentType,
      responseBody: response,
      responseBodyTruncated: responseTruncated,
    );
    _entries.add(entry);
    if (_entries.length > maxEntries) {
      _entries.removeRange(0, _entries.length - maxEntries);
    }
    return entry;
  }

  /// [id] より新しい履歴を、古いものから返す。
  List<TrafficEntry> after(int id) => [
    for (final entry in _entries)
      if (entry.id > id) entry,
  ];

  /// [id] の履歴。消えていれば null。
  TrafficEntry? entry(int id) {
    for (final entry in _entries) {
      if (entry.id == id) {
        return entry;
      }
    }
    return null;
  }

  /// 履歴をすべて消す。
  void clear() => _entries.clear();

  static (String, bool) _truncate(String body) => body.length > maxBodyLength
      ? (body.substring(0, maxBodyLength), true)
      : (body, false);
}
