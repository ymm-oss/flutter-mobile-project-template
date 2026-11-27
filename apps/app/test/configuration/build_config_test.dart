import 'package:flutter_app/configuration/build_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  final packageInfo = PackageInfo(
    appName: 'Template',
    packageName: 'jp.co.yumemi.template',
    version: '1.0.0',
    buildNumber: '1',
  );

  test('apiBaseUrlOverride を、flavor ファイルの apiBaseUrl より優先する', () {
    final buildConfig = BuildConfig.fromPackageInfo(
      packageInfo,
      apiBaseUrlOverride: 'http://127.0.0.1:4000',
      flavor: 'dev',
      apiBaseUrlFromEnvironment: 'https://dev.api.example.com',
    );

    expect(buildConfig.apiBaseUrl, 'http://127.0.0.1:4000');
  });

  test('apiBaseUrlOverride がなければ、flavor ファイルの apiBaseUrl を使う', () {
    final buildConfig = BuildConfig.fromPackageInfo(
      packageInfo,
      flavor: 'dev',
      apiBaseUrlFromEnvironment: 'https://dev.api.example.com',
    );

    expect(buildConfig.apiBaseUrl, 'https://dev.api.example.com');
  });

  test('apiBaseUrl がどこにもなければ、StateError を投げる', () {
    expect(
      () => BuildConfig.fromPackageInfo(
        packageInfo,
        flavor: 'dev',
        // dart-define を渡してテストを実行しても、空として確かめるため。
        // ignore: avoid_redundant_argument_values
        apiBaseUrlFromEnvironment: '',
      ),
      throwsStateError,
    );
  });
}
