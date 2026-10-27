import 'package:internal_application/operational_settings/get_force_update_policy_use_case.dart';
import 'package:internal_domain_logic/operational_settings/operational_settings_repository.dart';
import 'package:internal_domain_model/operational_settings/operational_settings.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';

class MockOperationalSettingsRepository extends Mock
    implements OperationalSettingsRepository;

void main() {
  late GetForceUpdatePolicyUseCase useCase;
  late MockOperationalSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockOperationalSettingsRepository();
    useCase = GetForceUpdatePolicyUseCase(
      operationalSettingsRepository: mockRepository,
    );
  });

  group('call', () {
    test('強制更新が有効な場合', () async {
      // Arrange
      final minimumVersion = Version(2, 0, 0);
      when(() => mockRepository.getOperationalSettings()).thenAnswer(
        (_) async => OperationalSettings(
          maintenancePolicy: const MaintenancePolicy.disabled(),
          forceUpdatePolicy: ForceUpdatePolicy.enabled(
            minimumVersions: RequiredVersions(
              ios: minimumVersion,
              android: Version.none,
            ),
          ),
        ),
      );

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isA<ForceUpdateEnabled>());
      expect(
        (result as ForceUpdateEnabled).minimumVersions.ios,
        minimumVersion,
      );
    });

    test('強制更新が無効な場合', () async {
      // Arrange
      when(() => mockRepository.getOperationalSettings()).thenAnswer(
        (_) async => const OperationalSettings(
          maintenancePolicy: MaintenancePolicy.disabled(),
          forceUpdatePolicy: ForceUpdatePolicy.disabled(),
        ),
      );

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isA<ForceUpdateDisabled>());
    });
  });
}
