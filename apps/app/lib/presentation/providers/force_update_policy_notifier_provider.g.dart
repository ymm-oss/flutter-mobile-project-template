// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore, deprecated_member_use

part of 'force_update_policy_notifier_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ForceUpdatePolicyNotifier)
final forceUpdatePolicyProvider = ForceUpdatePolicyNotifierProvider._();

final class ForceUpdatePolicyNotifierProvider
    extends
        $AsyncNotifierProvider<ForceUpdatePolicyNotifier, ForceUpdatePolicy> {
  ForceUpdatePolicyNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forceUpdatePolicyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forceUpdatePolicyNotifierHash();

  @$internal
  @override
  ForceUpdatePolicyNotifier create() => ForceUpdatePolicyNotifier();
}

String _$forceUpdatePolicyNotifierHash() =>
    r'9d4b260c2b343863a1337ab5c5d49f75405dfa8b';

abstract class _$ForceUpdatePolicyNotifier
    extends $AsyncNotifier<ForceUpdatePolicy> {
  FutureOr<ForceUpdatePolicy> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ForceUpdatePolicy>, ForceUpdatePolicy>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ForceUpdatePolicy>, ForceUpdatePolicy>,
              AsyncValue<ForceUpdatePolicy>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
