import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/gen/assets/assets.gen.dart';
import 'package:flutter_app/presentation/providers/build_config_provider.dart';
import 'package:flutter_app/presentation/providers/theme_setting_provider.dart';
import 'package:flutter_app/presentation/ui/setting/components/setting_section_spacer.dart';
import 'package:flutter_app/presentation/ui/setting/components/setting_section_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internal_design_ui/i18n.dart';
import 'package:internal_domain_model/theme_setting/theme_setting.dart';

typedef SettingPageNavigator = ({
  void Function(BuildContext context) goLicensePage,
});

class SettingPage extends ConsumerWidget {
  const SettingPage({
    required this._navigator,
    super.key,
  });

  final SettingPageNavigator _navigator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeSetting = ref.watch(themeSettingProvider);
    final buildConfig = ref.watch(buildConfigProvider);
    final t = Translations.of(context).setting;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.appBarTitle),
      ),
      body: CustomScrollView(
        slivers: [
          SettingSectionTitle(text: t.themeSettingLabel),
          SliverToBoxAdapter(
            child: RadioGroup<ThemeSetting>(
              groupValue: currentThemeSetting,
              onChanged: (newThemeSetting) {
                if (newThemeSetting == null) {
                  return;
                }

                unawaited(
                  ref
                      .read(themeSettingProvider.notifier)
                      .changeThemeSetting(newThemeSetting),
                );
              },
              child: Column(
                children: [
                  for (final themeSetting in ThemeSetting.values)
                    RadioListTile<ThemeSetting>(
                      value: themeSetting,
                      title: Text(themeSetting.name),
                    ),
                ],
              ),
            ),
          ),
          const SettingSectionSpacer(),
          SettingSectionTitle(text: t.aboutLabel),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // 同一パッケージのassetsはこのように使います
                // 汎用的なassetsはinternal_design_uiのCommonAssetsを使います
                Assets.yumemiLogo.image(
                  width: 100,
                  height: 100,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  leading: const Icon(Icons.description),
                  title: Text(t.openSourceLicensesLabel),
                  subtitle: Text(t.librariesWeUseLabel),
                  onTap: () => _navigator.goLicensePage(context),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  leading: const Icon(Icons.info_outline),
                  title: Text(t.versionLabel),
                  subtitle: Text(buildConfig.version),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
