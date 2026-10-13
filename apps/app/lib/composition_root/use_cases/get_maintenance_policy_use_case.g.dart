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
        isAutoDispose: true,
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
    r'7a1fbe03ed4df19641e9ceffd25c92ca6dd77fdc';
