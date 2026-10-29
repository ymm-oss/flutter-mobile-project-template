// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore, deprecated_member_use

part of 'shared_preference_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'91d3d8d16af3d747cec711b8a095a63e20df9b7c';

@ProviderFor(sharedPreferenceDataSource)
final sharedPreferenceDataSourceProvider =
    SharedPreferenceDataSourceProvider._();

final class SharedPreferenceDataSourceProvider
    extends
        $FunctionalProvider<
          SharedPreferenceDataSource,
          SharedPreferenceDataSource,
          SharedPreferenceDataSource
        >
    with $Provider<SharedPreferenceDataSource> {
  SharedPreferenceDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferenceDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferenceDataSourceHash();

  @$internal
  @override
  $ProviderElement<SharedPreferenceDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferenceDataSource create(Ref ref) {
    return sharedPreferenceDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferenceDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferenceDataSource>(value),
    );
  }
}

String _$sharedPreferenceDataSourceHash() =>
    r'3de5942f9ab4b5bb10a2b14640f80de60ca672f6';
