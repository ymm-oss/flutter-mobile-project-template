// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore, deprecated_member_use

part of 'operational_settings_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(operationalSettingsRepository)
final operationalSettingsRepositoryProvider =
    OperationalSettingsRepositoryProvider._();

final class OperationalSettingsRepositoryProvider
    extends
        $FunctionalProvider<
          OperationalSettingsRepository,
          OperationalSettingsRepository,
          OperationalSettingsRepository
        >
    with $Provider<OperationalSettingsRepository> {
  OperationalSettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'operationalSettingsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$operationalSettingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<OperationalSettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OperationalSettingsRepository create(Ref ref) {
    return operationalSettingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OperationalSettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OperationalSettingsRepository>(
        value,
      ),
    );
  }
}

String _$operationalSettingsRepositoryHash() =>
    r'c99ff645986e07e252693758b216a964a9457ea6';
