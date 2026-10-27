import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:internal_domain_model/operational_settings/operating_system.dart';
import 'package:pub_semver/pub_semver.dart';

part 'operational_settings.freezed.dart';

@freezed
abstract class OperationalSettings with _$OperationalSettings {
  const factory({
    required MaintenancePolicy maintenancePolicy,
    required ForceUpdatePolicy forceUpdatePolicy,
  }) = _OperationalSettings;

  const new _();

  /// 強制アップデートが必要かどうかを判定する
  bool isForceUpdateRequired(Version currentVersion, OperatingSystem os) {
    return switch (forceUpdatePolicy) {
      ForceUpdateEnabled(:final minimumVersions) => switch (os) {
        OperatingSystem.ios => currentVersion < minimumVersions.ios,
        OperatingSystem.android => currentVersion < minimumVersions.android,
      },
      ForceUpdateDisabled() => false,
    };
  }
}

@freezed
sealed class MaintenancePolicy with _$MaintenancePolicy {
  const factory enabled({
    required String message,
  }) = MaintenanceEnabled;

  const factory disabled() = MaintenanceDisabled;
}

@freezed
sealed class ForceUpdatePolicy with _$ForceUpdatePolicy {
  const factory enabled({
    required RequiredVersions minimumVersions,
  }) = ForceUpdateEnabled;

  const factory disabled() = ForceUpdateDisabled;
}

@freezed
sealed class RequiredVersions with _$RequiredVersions {
  const factory({
    required Version ios,
    required Version android,
  }) = _RequiredVersions;

  const new _();

  Version getMinimumFor(OperatingSystem os) {
    return switch (os) {
      OperatingSystem.ios => ios,
      OperatingSystem.android => android,
    };
  }
}
