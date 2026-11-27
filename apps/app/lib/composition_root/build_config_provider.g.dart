// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore, deprecated_member_use

part of 'build_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(buildConfig)
final buildConfigProvider = BuildConfigProvider._();

final class BuildConfigProvider
    extends $FunctionalProvider<BuildConfig, BuildConfig, BuildConfig>
    with $Provider<BuildConfig> {
  BuildConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'buildConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$buildConfigHash();

  @$internal
  @override
  $ProviderElement<BuildConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BuildConfig create(Ref ref) {
    return buildConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BuildConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BuildConfig>(value),
    );
  }
}

String _$buildConfigHash() => r'2d81398cb4435e6baf6efb522105d54ca71179f7';
