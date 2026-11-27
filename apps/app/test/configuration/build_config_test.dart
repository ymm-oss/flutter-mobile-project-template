import 'package:flutter_app/configuration/build_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  test('apiBaseUrl が渡されていないときは StateError を投げる', () {
    final packageInfo = PackageInfo(
      appName: 'appName',
      packageName: 'packageName',
      version: '1.0.0',
      buildNumber: '1',
    );

    expect(
      () => BuildConfig.fromPackageInfo(packageInfo),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('apiBaseUrl'),
        ),
      ),
    );
  });
}
