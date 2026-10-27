import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app_initializer.dart';
import 'package:flutter_app/debug/debug_features_impl.dart';
import 'package:flutter_app/presentation/providers/debug_features_provider.dart';
import 'package:flutter_app/presentation/providers/force_update_policy_notifier_provider.dart';
import 'package:flutter_app/presentation/providers/theme_setting_provider.dart';
import 'package:flutter_app/router/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internal_design_theme/themes.dart';
import 'package:internal_design_ui/i18n.dart';
import 'package:internal_domain_model/operational_settings/operational_settings.dart';
import 'package:internal_domain_model/theme_setting/theme_setting.dart';
import 'package:internal_util_ui/snack_bar_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleSettings.useDeviceLocale();

  LicenseRegistry.addLicense(() async* {
    yield _yumemiMobileProjectTemplateLicense();
  });

  final (
    overrideProviders: overrideProviders,
  ) = await AppInitializer.initialize();

  // kDebugMode はコンパイル時定数のため、リリースビルドでは createDebugFeatures への
  // 参照ごと削除され、デバッグ機能は tree shaking によってバイナリから除外される。
  final debugFeatures = kDebugMode ? createDebugFeatures() : null;
  if (debugFeatures != null) {
    overrideProviders.addAll([
      debugFeaturesProvider.overrideWithValue(debugFeatures),
      ...debugFeatures.overrides,
    ]);
  }

  runApp(
    ProviderScope(
      overrides: overrideProviders,
      observers: [...?debugFeatures?.observers],
      child: TranslationProvider(child: const MainApp()),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSetting = ref.watch(themeSettingNotifierProvider);
    final debugFeatures = ref.watch(debugFeaturesProvider);

    ref.listen(forceUpdatePolicyNotifierProvider, (
      _,
      forceUpdatePolicy,
    ) {
      final message = switch (forceUpdatePolicy) {
        AsyncError(:final error) => 'Failed to check for updates: $error',
        AsyncData(:final value) => switch (value) {
          ForceUpdateEnabled() => 'Force Update is required.',
          ForceUpdateDisabled() => null,
        },
        _ => null,
      };

      if (message == null) {
        return;
      }

      SnackBarManager.showSnackBar(message);
      ref.read(forceUpdatePolicyNotifierProvider.notifier).disable();
    });

    return MaterialApp.router(
      locale: TranslationProvider.of(context).flutterLocale,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: AppLocaleUtils.supportedLocales,
      scaffoldMessengerKey: SnackBarManager.rootScaffoldMessengerKey,
      builder: debugFeatures?.appBuilder,
      routerConfig: ref.watch(routerProvider),
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: themeSetting.toThemeMode(),
    );
  }
}

LicenseEntryWithLineBreaks _yumemiMobileProjectTemplateLicense() {
  return const LicenseEntryWithLineBreaks(
    ['YUMEMI Mobile Project Template'],
    '''
MIT License

Copyright (c) 2023 YUMEMI Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
      ''',
  );
}

extension on ThemeSetting {
  ThemeMode toThemeMode() {
    return switch (this) {
      ThemeSetting.light => ThemeMode.light,
      ThemeSetting.dark => ThemeMode.dark,
      ThemeSetting.system => ThemeMode.system,
    };
  }
}
