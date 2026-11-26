/// operation ごとの応答の設定。
///
/// 画面に依存しないよう、shelf と dart:io を使わない。管理画面は JSON API を
/// 通して、アプリに組み込んだ画面は直接、この設定を読み書きする。
library;

/// 1 つの operation の応答の設定。
final class OperationSettings {
  const new({this.response, this.delay = Duration.zero});

  /// 仕様書のとおりに応答する設定。
  static const defaults = OperationSettings();

  /// 仕様書の example の代わりに返す応答。null なら仕様書の example を返す。
  final ResponseOverride? response;

  /// 応答を返すまでに待つ時間。
  final Duration delay;

  /// 仕様書のとおりに応答する設定かどうか。
  bool get isDefault => response == null && delay == Duration.zero;
}

/// 仕様書の example の代わりに返す応答。
///
/// [EditedResponse] と [SpecErrorResponse] のどちらか 1 つを選ぶ。
sealed class ResponseOverride {
  const new();
}

/// 管理画面で編集した応答を返す。
///
/// 2xx なら正常系、それ以外なら異常系の応答として使う。
final class EditedResponse extends ResponseOverride {
  const new({
    required this.statusCode,
    required this.contentType,
    required this.body,
  });

  final int statusCode;

  final String contentType;

  final String body;
}

/// 仕様書にある 3xx、4xx、5xx の応答を、そのまま返す。
final class SpecErrorResponse extends ResponseOverride {
  const new(this.statusCode);

  /// 仕様書の responses のステータスコード。
  final int statusCode;
}

/// operation のキー（`Operation.key`）ごとの設定。
///
/// 設定はメモリーにだけ持ち、モックサーバーを起動し直すと消える。
final class MockSettings {
  final Map<String, OperationSettings> _settings = {};

  /// [key] の operation の設定。設定がなければ [OperationSettings.defaults]。
  OperationSettings of(String key) =>
      _settings[key] ?? OperationSettings.defaults;

  /// 仕様書のとおりでない設定を持つ operation のキーと、その設定。
  Map<String, OperationSettings> get changed => Map.unmodifiable(_settings);

  /// [key] の operation の設定を [settings] にする。
  void update(String key, OperationSettings settings) {
    if (settings.isDefault) {
      _settings.remove(key);
    } else {
      _settings[key] = settings;
    }
  }

  /// [key] の operation を、仕様書のとおりに応答する設定に戻す。
  void reset(String key) => _settings.remove(key);

  /// すべての operation を、仕様書のとおりに応答する設定に戻す。
  void resetAll() => _settings.clear();
}
