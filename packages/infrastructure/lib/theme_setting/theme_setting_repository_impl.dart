import 'package:internal_domain_logic/theme_setting/theme_setting_repository.dart';
import 'package:internal_domain_model/theme_setting/theme_setting.dart';
import 'package:internal_infrastructure/shared_preferences/shared_preference_data_source.dart';

class ThemeSettingRepositoryImpl implements ThemeSettingRepository {
  const new(this._sharedPreference);

  final SharedPreferenceDataSource _sharedPreference;

  @override
  ThemeSetting getThemeSetting() {
    return _sharedPreference.getThemeSetting();
  }

  @override
  Future<void> saveThemeSetting(ThemeSetting themeSetting) async {
    await _sharedPreference.saveThemeSetting(themeSetting.index);
  }
}
