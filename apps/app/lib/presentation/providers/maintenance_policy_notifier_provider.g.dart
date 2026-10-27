// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore, deprecated_member_use

part of 'maintenance_policy_notifier_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MaintenancePolicyNotifier)
final maintenancePolicyProvider = MaintenancePolicyNotifierProvider._();

final class MaintenancePolicyNotifierProvider
    extends
        $AsyncNotifierProvider<MaintenancePolicyNotifier, MaintenancePolicy> {
  MaintenancePolicyNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maintenancePolicyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maintenancePolicyNotifierHash();

  @$internal
  @override
  MaintenancePolicyNotifier create() => MaintenancePolicyNotifier();
}

String _$maintenancePolicyNotifierHash() =>
    r'355423c1e8fe7ae6a3c4fa2dc0afa7f51a9a70cc';

abstract class _$MaintenancePolicyNotifier
    extends $AsyncNotifier<MaintenancePolicy> {
  FutureOr<MaintenancePolicy> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<MaintenancePolicy>, MaintenancePolicy>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MaintenancePolicy>, MaintenancePolicy>,
              AsyncValue<MaintenancePolicy>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
