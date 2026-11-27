/// operation ごとの設定をまとめて保存し、切り替えるプロファイル。
///
/// 画面に依存しないよう、shelf と dart:io を使わない。ファイルの読み書きは
/// [ProfileStore] の実装に任せる。
library;

import 'dart:convert';

import 'package:internal_mock_server/src/mock_settings.dart';
import 'package:internal_mock_server/src/openapi_document.dart';
import 'package:internal_mock_server/src/settings_json.dart';

/// プロファイルの形式の版。形式を変えたら上げ、[applyProfile] で古い版も読む。
const profileVersion = 1;

/// [settings] のうち、既定から変えた operation の設定をプロファイルにする。
///
/// 差分を読みやすくするため、operation のキーの順に並べる。
Map<String, Object?> exportProfile(MockSettings settings) {
  final changed = settings.changed;
  return {
    'version': profileVersion,
    'operations': {
      for (final key in changed.keys.toList()..sort())
        key: operationSettingsToJson(changed[key]!),
    },
  };
}

/// [exportProfile] の結果を、ファイルに書く文字列にする。
String encodeProfile(Map<String, Object?> profile) =>
    '${const JsonEncoder.withIndent('  ').convert(profile)}\n';

/// [text] のプロファイルを [settings] に入れる。
///
/// すべての operation を既定に戻してから入れるため、プロファイルにない
/// operation は既定の設定になる。仕様書にない operation と、読めない設定は
/// 読み飛ばし、その理由を返す。
///
/// プロファイル全体を読めなければ、[settings] を変えずに [FormatException] を
/// 投げる。
List<String> applyProfile(
  MockSettings settings,
  String text,
  OpenApiDocument document,
) {
  final Object? json;
  try {
    json = jsonDecode(text);
  } on FormatException {
    throw const FormatException('プロファイルを JSON として読めません。');
  }
  final operations = switch (json) {
    {'version': profileVersion, 'operations': final Map<String, Object?> o} =>
      o,
    {'version': profileVersion} => throw const FormatException(
      'プロファイルの operations はオブジェクトで書いてください。',
    ),
    {'version': final version} => throw FormatException(
      'プロファイルの版 $version は読めません。$profileVersion の版で書いてください。',
    ),
    _ => throw const FormatException(
      'プロファイルは version と operations を持つオブジェクトで書いてください。',
    ),
  };

  final byKey = {
    for (final operation in document.operations) operation.key: operation,
  };
  final loaded = <String, OperationSettings>{};
  final skipped = <String>[];
  for (final MapEntry(:key, :value) in operations.entries) {
    final operation = byKey[key];
    if (operation == null) {
      skipped.add('仕様書に $key の operation がありません。');
      continue;
    }
    try {
      loaded[key] = operationSettingsFromJson(value, operation);
    } on FormatException catch (e) {
      skipped.add('$key: ${e.message}');
    }
  }

  settings.resetAll();
  for (final MapEntry(:key, :value) in loaded.entries) {
    settings.update(key, value);
  }
  return skipped;
}

/// 保存したプロファイルの 1 件。
///
/// `shared` が true なら、チームで共有する（コミットする）プロファイル。
/// false なら、自分だけが使うプロファイル。
typedef ProfileRef = ({String name, bool shared});

/// プロファイルを読み書きする場所。
///
/// 共有のプロファイルは読むだけで、書き換えるのは自分用のプロファイルだけ。
/// 読み書きの方法を差し替えられるよう、抽象にしておく。
abstract interface class ProfileStore {
  /// 保存したプロファイル。共有のものを名前の順に並べ、そのあとに自分用の
  /// ものを名前の順に並べる。
  Future<List<ProfileRef>> list();

  /// [ref] のプロファイルの中身。なければ [ProfileStoreException] を投げる。
  Future<String> read(ProfileRef ref);

  /// [content] を、自分用のプロファイル [name] として保存する。同じ名前が
  /// あれば上書きする。
  Future<void> save(String name, String content);

  /// 自分用のプロファイル [name] を消す。なければ [ProfileStoreException] を
  /// 投げる。
  Future<void> delete(String name);
}

/// [ProfileStore] で、プロファイルがないときや名前が使えないときに投げる例外。
final class ProfileStoreException implements Exception {
  const new(this.message);

  final String message;

  @override
  String toString() => message;
}

/// プロファイルの名前の長さの上限。
const maxProfileNameLength = 64;

/// [name] をファイルの名前に使えるか確かめ、使えなければ
/// [ProfileStoreException] を投げる。
///
/// ほかのディレクトリに書かないよう、区切りの文字と `.` で始まる名前を拒む。
/// Windows でも作れるよう、Windows がファイル名に使えない文字も拒む。
void validateProfileName(String name) {
  if (name.trim().isEmpty) {
    throw const ProfileStoreException('プロファイルの名前を入力してください。');
  }
  if (name.length > maxProfileNameLength) {
    throw const ProfileStoreException(
      'プロファイルの名前は $maxProfileNameLength 文字までにしてください。',
    );
  }
  if (name != name.trim() ||
      name.startsWith('.') ||
      name.codeUnits.any((unit) => unit < 0x20) ||
      name.contains(RegExp(r'[<>:"/\\|?*]'))) {
    throw ProfileStoreException(
      'プロファイルの名前「$name」は使えません。'
      r'前後の空白、先頭の .、< > : " / \ | ? * を使わないでください。',
    );
  }
}
