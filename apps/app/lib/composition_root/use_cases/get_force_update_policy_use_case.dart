import 'package:flutter_app/composition_root/repositories/operational_settings_repository.dart';
import 'package:internal_application/operational_settings/get_force_update_policy_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_force_update_policy_use_case.g.dart';

@Riverpod(keepAlive: true)
GetForceUpdatePolicyUseCase getForceUpdatePolicyUseCase(Ref ref) {
  final repository = ref.watch(operationalSettingsRepositoryProvider);
  return GetForceUpdatePolicyUseCase(
    operationalSettingsRepository: repository,
  );
}
