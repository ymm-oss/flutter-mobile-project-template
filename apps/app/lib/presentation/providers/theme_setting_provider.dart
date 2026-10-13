import 'package:flutter_app/composition_root/repositories/theme_setting_repository.dart';
import 'package:internal_domain_model/theme_setting/theme_setting.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_setting_provider.g.dart';

@riverpod
class ThemeSettingNotifier extends _$ThemeSettingNotifier {
  @override
  ThemeSetting build() {
    final repository = ref.watch(themeSettingRepositoryProvider);
    return repository.getThemeSetting();
  }

  Future<void> changeThemeSetting(ThemeSetting theme) async {
    final repository = ref.read(themeSettingRepositoryProvider);
    await repository.saveThemeSetting(theme);
    if (!ref.mounted) {
      return;
    }
    state = theme;
  }
}
