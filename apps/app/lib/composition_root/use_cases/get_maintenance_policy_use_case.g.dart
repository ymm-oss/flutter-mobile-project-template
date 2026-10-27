// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore, deprecated_member_use

part of 'get_maintenance_policy_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getMaintenancePolicyUseCase)
final getMaintenancePolicyUseCaseProvider =
    GetMaintenancePolicyUseCaseProvider._();

final class GetMaintenancePolicyUseCaseProvider
    extends
        $FunctionalProvider<
          GetMaintenancePolicyUseCase,
          GetMaintenancePolicyUseCase,
          GetMaintenancePolicyUseCase
        >
    with $Provider<GetMaintenancePolicyUseCase> {
  GetMaintenancePolicyUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getMaintenancePolicyUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getMaintenancePolicyUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetMaintenancePolicyUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetMaintenancePolicyUseCase create(Ref ref) {
    return getMaintenancePolicyUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetMaintenancePolicyUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetMaintenancePolicyUseCase>(value),
    );
  }
}

String _$getMaintenancePolicyUseCaseHash() =>
    r'3698dc3ec3d4c3674b3cb4c638c20156e6512a47';
