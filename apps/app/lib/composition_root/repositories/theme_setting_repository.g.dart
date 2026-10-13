// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore, deprecated_member_use

part of 'theme_setting_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(themeSettingRepository)
final themeSettingRepositoryProvider = ThemeSettingRepositoryProvider._();

final class ThemeSettingRepositoryProvider
    extends
        $FunctionalProvider<
          ThemeSettingRepository,
          ThemeSettingRepository,
          ThemeSettingRepository
        >
    with $Provider<ThemeSettingRepository> {
  ThemeSettingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeSettingRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeSettingRepositoryHash();

  @$internal
  @override
  $ProviderElement<ThemeSettingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ThemeSettingRepository create(Ref ref) {
    return themeSettingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeSettingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeSettingRepository>(value),
    );
  }
}

String _$themeSettingRepositoryHash() =>
    r'01ace6a08b4095b97da703e90bf56637bf091ec0';
