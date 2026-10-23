// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore, deprecated_member_use

part of 'debug_features_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$debugFeaturesHash() => r'2c8ee6c4d4b492d89773f88717eb30ff5d57c254';

/// デバッグ機能を提供する。
///
/// デバッグビルドでのみ override され、リリースビルドでは常に `null` を返す。
///
/// Copied from [debugFeatures].
@ProviderFor(debugFeatures)
final debugFeaturesProvider = Provider<DebugFeatures?>.internal(
  debugFeatures,
  name: r'debugFeaturesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$debugFeaturesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DebugFeaturesRef = ProviderRef<DebugFeatures?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
