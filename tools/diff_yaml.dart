import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import 'utils/path.dart';

extension YamlMapToJson on YamlMap {
  Map<String, dynamic> toJson() {
    final jsonString = jsonEncode(this);
    final toJson = jsonDecode(jsonString) as Map<String, dynamic>;
    return toJson;
  }
}

/// pubspec.yaml と pubspec.lock ファイルの差分を分析し、Markdown フォーマットで出力するツール
///
/// このツールは以下の２つの比較を行います：
/// 1. 現在の pubspec.lock と、引数で渡した base の pubspec.lock の差分
/// 2. 現在の pubspec.yaml と pubspec.lock のパッケージバージョン表記の違い
///
/// 使用例:
/// ```dart
/// dart diff_yaml.dart /tmp/base-pubspec.lock pubspec.yaml pubspec.lock
/// ```
///
/// 出力形式:
/// 1. pubspec.lock の変更がある場合:
/// ```markdown
/// ## pubspec.lock has been changed
/// | Change | Diff |
/// | :---   | :--- |
/// | package.version | {"previous": "1.0.0", "current": "2.0.0"} |
/// ```
///
/// 2. バージョン表記の違いがある場合:
/// ```markdown
/// Compare pubspec.yaml and pubspec.lock. Packages with
/// different version notations
/// | package | pubspec.yaml | pubspec.lock |
/// | :---    | :---         | :---         |
/// | package_name | ^1.0.0 | 1.0.1 |
/// ```
///
/// パラメータ:
/// * [args] - コマンドライン引数
///   - args[0]: 比較対象の pubspec.lock ファイル
///   - args[1]: pubspec.yaml のパス
///   - args[2]: 現在の pubspec.lock のパス
///
/// 例外:
/// * [FileSystemException] - ファイルの読み込みに失敗した場合
void main(List<String> args) {
  final baseLockPath = args[0];
  final yamlPath = args[1];
  final lockPath = args[2];

  final rootDir = fetchGitRootDirPath();

  final baseLock = loadYaml(File(baseLockPath).readAsStringSync()) as YamlMap;
  final yamlFile = File(join(rootDir, yamlPath));
  final currentYaml = loadYaml(yamlFile.readAsStringSync()) as YamlMap;
  final lockFile = File(join(rootDir, lockPath));
  final currentLock = loadYaml(lockFile.readAsStringSync()) as YamlMap;

  final compareValue = compareMap(baseLock.toJson(), currentLock.toJson());

  final rows = <String>[];

  if (compareValue.isNotEmpty) {
    rows.add('''
<details><summary>pubspec.lock has been changed</summary><p>\n\n
''');
    rows.add('''
| Change | Diff |
| :---   | :--- |
''');

    for (final entry in compareValue.entries) {
      final row = '|${entry.key}|${entry.value}|\n';
      rows.add(row);
    }

    rows.add('</p></details>\n\n');
    rows.add('---\n');
  }

  final diffVersions = diffPkgVersion(currentYaml, currentLock);

  if (diffVersions.isNotEmpty) {
    rows.add('''
<details><summary>Compare pubspec.yaml and pubspec.lock. Packages with different version notations</summary><p>\n\n
''');
    rows.add('''
| package | pubspec.yaml | pubspec.lock |
| :---    | :---         | :---         |
''');

    for (final diff in diffVersions) {
      final row =
          '''| ${diff['package']} | ${diff['pubspec.yaml']} | ${diff['pubspec.lock']} | \n''';
      rows.add(row);
    }

    rows.add('</p></details>');
  }

  stdout.writeln(rows.join().trim());
}

/// pubspec.yamlとpubspec.lockの内容を参照し、versionの表記が異なるものを返す
Iterable<Map<String, String>> diffPkgVersion(YamlMap yaml, YamlMap lock) {
  final yamlJson = yaml.toJson();

  final pkgYaml = <String, dynamic>{}
    ..addAll(yamlJson['dev_dependencies'] as Map<String, dynamic>)
    ..addAll(yamlJson['dependency_overrides'] as Map<String, dynamic>)
    ..addAll(
      // NOTE: 厳密な型変換は可読性が低下する為
      // ignore: avoid_dynamic_calls
      yamlJson['melos']['command']['bootstrap']['dependencies']
          as Map<String, dynamic>,
    )
    ..addAll(
      // NOTE: 厳密な型は可読性が低下する為
      // ignore: avoid_dynamic_calls
      yamlJson['melos']['command']['bootstrap']['dev_dependencies']
          as Map<String, dynamic>,
    );

  final lockPackages = Map<String, dynamic>.from(lock['packages'] as Map);

  return lockPackages.entries
      .where((lockPkg) {
        final name = lockPkg.key;

        if (pkgYaml.containsKey(name)) {
          // NOTE: dev_dependenciesにflutter_testを追加した場合,
          // 例外的に型がMap<String,dynamic>になる
          //
          // String型へのキャスト不可
          // flutter_testを比較から除外する
          if (pkgYaml[name] is! String) {
            return false;
          }

          final yamlVersion = (pkgYaml[name] as String).replaceFirst('^', '');
          final lockVersion = (lockPkg.value as Map)['version'].toString();

          return yamlVersion != lockVersion;
        }

        return false;
      })
      .map(
        (e) => {
          'package': e.key,
          'pubspec.yaml': pkgYaml[e.key] as String,
          'pubspec.lock': (e.value as Map)['version'] as String,
        },
      );
}

/// Compares Maps and returns a [Map<String, dynamic>] of the elements
/// that differ between [previous] and [current].

Map<String, dynamic> compareMap(
  Map<String, dynamic> previous,
  Map<String, dynamic> current, [
  String prefix = '',
]) {
  final result = <String, dynamic>{};

  final allKeys = {...previous.keys, ...current.keys};

  for (final key in allKeys) {
    final fullKey = prefix.isEmpty ? key : '$prefix.$key';
    final previousValue = previous[key];
    final currentValue = current[key];

    if (previousValue is Map || currentValue is Map) {
      final childDiff = compareMap(
        previousValue as Map<String, dynamic>? ?? {},
        currentValue as Map<String, dynamic>? ?? {},
        fullKey,
      );
      if (childDiff.isNotEmpty) {
        result.addAll(childDiff);
      }
    } else if (previousValue != currentValue) {
      result[fullKey] = {'previous': previousValue, 'current': currentValue};
    }
  }
  return result;
}
