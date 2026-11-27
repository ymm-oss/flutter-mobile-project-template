// NOTE: このファイルで `~.fromEnvironment()` を集約するため限定的に許可
// ignore_for_file: do_not_use_environment

import 'package:flutter_app/configuration/flavor.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'build_config.freezed.dart';

/// アプリの中でモックサーバーを起動し、API の向き先をそこにするか。
///
/// `--dart-define=embedMockServer=true` で有効にする。`const` のため、無効のビルドでは
/// これで守った参照ごと、モックサーバーが tree shaking で除外される。
const embedMockServer = bool.fromEnvironment('embedMockServer');

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
    required String apiBaseUrl,
  }) = _BuildConfig;

  /// [apiBaseUrlOverride] を渡すと、flavor ファイルなどの `apiBaseUrl` の代わりに使う。
  ///
  /// [flavor] と [apiBaseUrlFromEnvironment] は、テストで値を渡すためにある。
  factory fromPackageInfo(
    PackageInfo packageInfo, {
    String? apiBaseUrlOverride,
    // ここに `~.fromEnvironment()` を集約する
    @visibleForTesting String flavor = const String.fromEnvironment('flavor'),
    @visibleForTesting
    String apiBaseUrlFromEnvironment = const String.fromEnvironment(
      'apiBaseUrl',
    ),
  }) {
    final apiBaseUrl = apiBaseUrlOverride ?? apiBaseUrlFromEnvironment;
    if (apiBaseUrl.isEmpty) {
      throw StateError(
        'apiBaseUrl が空です。flavor ファイルか --dart-define で渡してください。',
      );
    }

    return BuildConfig._init(
      flavor: Flavor.values.byName(flavor),
      appName: packageInfo.appName,
      packageName: packageInfo.packageName,
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
      buildSignature: packageInfo.buildSignature,
      installerStore: packageInfo.installerStore,
      apiBaseUrl: apiBaseUrl,
    );
  }
}
