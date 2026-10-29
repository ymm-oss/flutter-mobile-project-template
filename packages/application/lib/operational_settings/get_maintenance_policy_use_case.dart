import 'package:internal_domain_logic/operational_settings/operational_settings_repository.dart';
import 'package:internal_domain_model/operational_settings/operational_settings.dart';

class GetMaintenancePolicyUseCase {
  const new({
    required this.operationalSettingsRepository,
  });

  final OperationalSettingsRepository operationalSettingsRepository;

  /// メンテナンスポリシーを取得する
  ///
  /// 現在の設定に基づいてメンテナンスポリシーを返す
  Future<MaintenancePolicy> call() async {
    final operationalSettings = await operationalSettingsRepository
        .getOperationalSettings();

    return operationalSettings.maintenancePolicy;
  }
}
