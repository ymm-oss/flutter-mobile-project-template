// NOTE: このファイルで `~.fromEnvironment()` を集約するため限定的に許可
// ignore_for_file: do_not_use_environment

import 'package:flutter_app/configuration/flavor.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'build_config.freezed.dart';

@Freezed(map: FreezedMapOptions.none, when: FreezedWhenOptions.none)
abstract class BuildConfig with _$BuildConfig {
  const factory _init({
    required String appName,
    required String packageName,
    required String version,
    required String buildNumber,
    required String buildSignature,
    required Flavor flavor,
    required String? installerStore,
  }) = _BuildConfig;

  factory fromPackageInfo(PackageInfo packageInfo) {
    // ここに `~.fromEnvironment()` を集約する
    const flavor = String.fromEnvironment('flavor');

    return BuildConfig._init(
      flavor: Flavor.values.byName(flavor),
      appName: packageInfo.appName,
      packageName: packageInfo.packageName,
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
      buildSignature: packageInfo.buildSignature,
      installerStore: packageInfo.installerStore,
    );
  }
}
