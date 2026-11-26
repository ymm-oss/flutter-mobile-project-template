import 'package:internal_mock_server/internal_mock_server.dart';
import 'package:test/test.dart';

void main() {
  late MockSettings settings;

  setUp(() => settings = MockSettings());

  test('設定がなければ既定の設定を返す', () {
    expect(settings.of('GET /items').isDefault, isTrue);
    expect(settings.changed, isEmpty);
  });

  test('update で設定を変える', () {
    settings.update(
      'GET /items',
      const OperationSettings(delay: Duration(seconds: 1)),
    );

    expect(settings.of('GET /items').delay, const Duration(seconds: 1));
    expect(settings.changed.keys, ['GET /items']);
  });

  test('既定と同じ設定で update すると、変更中から外す', () {
    settings
      ..update(
        'GET /items',
        const OperationSettings(response: SpecErrorResponse(500)),
      )
      ..update('GET /items', OperationSettings.defaults);

    expect(settings.changed, isEmpty);
  });

  test('reset で 1 つの operation を既定に戻す', () {
    settings
      ..update(
        'GET /items',
        const OperationSettings(response: SpecErrorResponse(500)),
      )
      ..update(
        'POST /items',
        const OperationSettings(response: SpecErrorResponse(500)),
      )
      ..reset('GET /items');

    expect(settings.of('GET /items').isDefault, isTrue);
    expect(settings.changed.keys, ['POST /items']);
  });

  test('resetAll ですべての operation を既定に戻す', () {
    settings
      ..update(
        'GET /items',
        const OperationSettings(response: SpecErrorResponse(500)),
      )
      ..update(
        'POST /items',
        const OperationSettings(response: SpecErrorResponse(500)),
      )
      ..resetAll();

    expect(settings.changed, isEmpty);
  });
}
