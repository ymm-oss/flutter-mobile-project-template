import 'dart:io';

import 'package:path/path.dart' as p;

/// `openapi/<api_name>/openapi.yaml` の置き場所。
final class ApiDirectory {
  new(this.root);

  /// `openapi` ディレクトリ。
  final Directory root;

  /// `openapi.yaml` がある API 名を、名前の順に返す。
  List<String> apiNames() {
    if (!root.existsSync()) {
      return const [];
    }
    return [
      for (final entity in root.listSync())
        if (entity is Directory && _specFileOf(entity).existsSync())
          p.basename(entity.path),
    ]..sort();
  }

  /// [apiName] の仕様書を返す。
  ///
  /// [apiName] を省略したときは、API が 1 つだけならその仕様書を返す。
  /// 選べないときは [ApiSelectionException] を投げる。
  File specFile({String? apiName}) {
    final names = apiNames();
    if (names.isEmpty) {
      throw ApiSelectionException(
        '${root.path} に <api_name>/openapi.yaml がありません。',
      );
    }
    final available = '指定できる API: ${names.join(', ')}';
    if (apiName == null) {
      if (names.length > 1) {
        throw ApiSelectionException('API が複数あるため、API 名を指定してください。$available');
      }
      return _specFileOf(Directory(p.join(root.path, names.single)));
    }
    if (!names.contains(apiName)) {
      throw ApiSelectionException('API「$apiName」がありません。$available');
    }
    return _specFileOf(Directory(p.join(root.path, apiName)));
  }

  static File _specFileOf(Directory apiDirectory) =>
      File(p.join(apiDirectory.path, 'openapi.yaml'));
}

/// 読む仕様書を選べなかったことを示す。
final class ApiSelectionException implements Exception {
  new(this.message);

  final String message;

  @override
  String toString() => message;
}
