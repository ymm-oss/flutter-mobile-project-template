import 'dart:convert';
import 'dart:io';

import 'model/package_info.dart';

/// dart pub outdated を時加工し、パッケージの更新有無を取得する
Future<void> main() async {
  const executable = 'dart';
  const arguments = ['pub', 'outdated', '--json'];

  final json = await Process.run(executable, arguments).then(
    (e) => e.stdout as String,
  );

  if (json.isEmpty) {
    throw ProcessException(
      executable,
      arguments,
      'Failed to execute $executable $arguments',
    );
  }

  final packageInfo = PackageInfo.fromJson(
    jsonDecode(json) as Map<String, dynamic>,
  );

  // 依存関係で追加されたパッケージ以外 && パッケージが最新以外の内容を取得
  final shouldUpdatePkg = [
    for (final pkg in packageInfo.packages)
      if (pkg
          case Package(
            kind: != Kind.transitive,
            current: final current?,
            resolvable: final resolvable?,
          )
          when current.compareTo(resolvable) != 0)
        (package: pkg.package, current: current, resolvable: resolvable),
  ];

  if (shouldUpdatePkg.isEmpty) {
    return;
  }

  final rows = [
    '''
## Update package
| package | current | resolvable |
| :---    | :---    | :---       |
  ''',
  ];

  for (final pkg in shouldUpdatePkg) {
    final row =
        '''| ${pkg.package} | ${pkg.current.version} | ${pkg.resolvable.version} | \n''';

    rows.add(row);
  }

  stdout.writeln(rows.join().trim());
}
