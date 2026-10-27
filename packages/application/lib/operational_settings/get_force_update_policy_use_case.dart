import 'package:internal_domain_logic/operational_settings/operational_settings_repository.dart';
import 'package:internal_domain_model/operational_settings/operational_settings.dart';

class GetForceUpdatePolicyUseCase {
  const new({
    required this.operationalSettingsRepository,
  });

  final OperationalSettingsRepository operationalSettingsRepository;

  /// 強制更新ポリシーを取得する
  ///
  /// 現在の設定に基づいて強制更新ポリシーを返す
  Future<ForceUpdatePolicy> call() async {
    final operationalSettings = await operationalSettingsRepository
        .getOperationalSettings();

    return operationalSettings.forceUpdatePolicy;
  }
}
