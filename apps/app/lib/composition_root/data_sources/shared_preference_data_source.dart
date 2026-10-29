import 'package:internal_infrastructure/shared_preferences/shared_preference_data_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preference_data_source.g.dart';

@riverpod
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError();

@riverpod
SharedPreferenceDataSource sharedPreferenceDataSource(Ref ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return SharedPreferenceDataSource(sharedPreferences);
}
