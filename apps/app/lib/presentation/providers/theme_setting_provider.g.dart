// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore, deprecated_member_use

part of 'theme_setting_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ThemeSettingNotifier)
final themeSettingProvider = ThemeSettingNotifierProvider._();

final class ThemeSettingNotifierProvider
    extends $NotifierProvider<ThemeSettingNotifier, ThemeSetting> {
  ThemeSettingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeSettingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeSettingNotifierHash();

  @$internal
  @override
  ThemeSettingNotifier create() => ThemeSettingNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeSetting value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeSetting>(value),
    );
  }
}

String _$themeSettingNotifierHash() =>
    r'9979566766946823d8794c13a2727e89123db879';

abstract class _$ThemeSettingNotifier extends $Notifier<ThemeSetting> {
  ThemeSetting build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ThemeSetting, ThemeSetting>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeSetting, ThemeSetting>,
              ThemeSetting,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
