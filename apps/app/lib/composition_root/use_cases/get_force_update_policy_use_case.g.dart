// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore, deprecated_member_use

part of 'get_force_update_policy_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getForceUpdatePolicyUseCase)
final getForceUpdatePolicyUseCaseProvider =
    GetForceUpdatePolicyUseCaseProvider._();

final class GetForceUpdatePolicyUseCaseProvider
    extends
        $FunctionalProvider<
          GetForceUpdatePolicyUseCase,
          GetForceUpdatePolicyUseCase,
          GetForceUpdatePolicyUseCase
        >
    with $Provider<GetForceUpdatePolicyUseCase> {
  GetForceUpdatePolicyUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getForceUpdatePolicyUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getForceUpdatePolicyUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetForceUpdatePolicyUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetForceUpdatePolicyUseCase create(Ref ref) {
    return getForceUpdatePolicyUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetForceUpdatePolicyUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetForceUpdatePolicyUseCase>(value),
    );
  }
}

String _$getForceUpdatePolicyUseCaseHash() =>
    r'86921928c8beb78012a256646dc230f07c0a1c6e';
