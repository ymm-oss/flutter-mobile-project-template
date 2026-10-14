import 'package:flutter_app/composition_root/repositories/operational_settings_repository.dart';
import 'package:internal_application/operational_settings/get_maintenance_policy_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_maintenance_policy_use_case.g.dart';

@Riverpod(keepAlive: true)
GetMaintenancePolicyUseCase getMaintenancePolicyUseCase(Ref ref) {
  final repository = ref.watch(operationalSettingsRepositoryProvider);
  return GetMaintenancePolicyUseCase(
    operationalSettingsRepository: repository,
  );
}
