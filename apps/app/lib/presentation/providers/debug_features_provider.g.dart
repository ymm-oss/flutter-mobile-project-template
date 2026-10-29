// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore, deprecated_member_use

part of 'debug_features_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// デバッグ機能を提供する。
///
/// デバッグビルドでのみ override され、リリースビルドでは常に `null` を返す。

@ProviderFor(debugFeatures)
final debugFeaturesProvider = DebugFeaturesProvider._();

/// デバッグ機能を提供する。
///
/// デバッグビルドでのみ override され、リリースビルドでは常に `null` を返す。

final class DebugFeaturesProvider
    extends $FunctionalProvider<DebugFeatures?, DebugFeatures?, DebugFeatures?>
    with $Provider<DebugFeatures?> {
  /// デバッグ機能を提供する。
  ///
  /// デバッグビルドでのみ override され、リリースビルドでは常に `null` を返す。
  DebugFeaturesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debugFeaturesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debugFeaturesHash();

  @$internal
  @override
  $ProviderElement<DebugFeatures?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DebugFeatures? create(Ref ref) {
    return debugFeatures(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DebugFeatures? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DebugFeatures?>(value),
    );
  }
}

String _$debugFeaturesHash() => r'2c8ee6c4d4b492d89773f88717eb30ff5d57c254';
