import 'dart:convert';

import '../model/melos_package.dart';
import 'command_runner.dart';

/// melos list --json の結果をパースして [MelosPackage] のリストを返す
List<MelosPackage> fetchMelosPackageList({
  void Function()? onFailure,
}) {
  final melosPackageListString = run(
    'dart',
    arguments: ['run', 'melos', 'list', '--json'],
    quiet: true,
  );

  return (jsonDecode(melosPackageListString) as List<dynamic>)
      .map((e) => MelosPackage.fromJson(e as Map<String, dynamic>))
      .toList();
}
