import 'dart:convert';

import 'package:internal_mock_server/internal_mock_server.dart';
import 'package:test/test.dart';

void main() {
  final document = OpenApiDocument.parse('''
paths:
  /items:
    get:
      responses:
        "200":
          description: ok
          content:
            application/json:
              example: []
        "500":
          description: error
          content:
            application/json:
              example:
                message: error
  /items/{itemId}:
    get:
      responses:
        "200":
          description: ok
          content:
            application/json:
              example: {}
''');

  late MockSettings settings;

  setUp(() => settings = MockSettings());

  group('exportProfile', () {
    test('既定から変えた operation だけを、キーの順に書き出す', () {
      settings
        ..update(
          'GET /items/{itemId}',
          const OperationSettings(delay: Duration(milliseconds: 100)),
        )
        ..update(
          'GET /items',
          const OperationSettings(response: SpecErrorResponse(500)),
        );

      final profile = exportProfile(settings);

      expect(profile, {
        'version': 1,
        'operations': {
          'GET /items': {
            'response': {'type': 'specError', 'statusCode': 500},
            'delayMs': 0,
          },
          'GET /items/{itemId}': {'response': null, 'delayMs': 100},
        },
      });
      expect(
        (profile['operations']! as Map).keys,
        ['GET /items', 'GET /items/{itemId}'],
      );
    });

    test('ファイルには字下げした JSON を、改行で終えて書く', () {
      expect(
        encodeProfile(exportProfile(settings)),
        '{\n  "version": 1,\n  "operations": {}\n}\n',
      );
    });
  });

  group('applyProfile', () {
    test('書き出したプロファイルを入れると、同じ設定に戻る', () {
      settings.update(
        'GET /items',
        const OperationSettings(
          response: EditedResponse(
            statusCode: 200,
            contentType: 'application/json',
            body: '[]',
          ),
          delay: Duration(seconds: 1),
        ),
      );
      final text = encodeProfile(exportProfile(settings));
      final restored = MockSettings();

      expect(applyProfile(restored, text, document), isEmpty);
      expect(
        exportProfile(restored),
        exportProfile(settings),
      );
    });

    test('プロファイルにない operation は既定に戻す', () {
      settings.update(
        'GET /items/{itemId}',
        const OperationSettings(delay: Duration(seconds: 1)),
      );

      applyProfile(
        settings,
        jsonEncode({
          'version': 1,
          'operations': {
            'GET /items': {'delayMs': 10},
          },
        }),
        document,
      );

      expect(settings.changed.keys, ['GET /items']);
    });

    test('仕様書にない operation と、読めない設定は読み飛ばす', () {
      final skipped = applyProfile(
        settings,
        jsonEncode({
          'version': 1,
          'operations': {
            'GET /removed': {'delayMs': 10},
            'GET /items': {
              'response': {'type': 'specError', 'statusCode': 404},
            },
            'GET /items/{itemId}': {'delayMs': 20},
          },
        }),
        document,
      );

      expect(skipped, [
        '仕様書に GET /removed の operation がありません。',
        'GET /items: 仕様書の GET /items に 404 の応答がありません。',
      ]);
      expect(settings.changed.keys, ['GET /items/{itemId}']);
    });

    group('全体を読めなければ、設定を変えずに FormatException を投げる', () {
      final cases = {
        'JSON でない': '{',
        '版がない': '{"operations": {}}',
        '読めない版': '{"version": 2, "operations": {}}',
        'operations がオブジェクトでない': '{"version": 1, "operations": []}',
      };
      for (final MapEntry(key: name, value: text) in cases.entries) {
        test(name, () {
          settings.update(
            'GET /items',
            const OperationSettings(delay: Duration(seconds: 1)),
          );

          expect(
            () => applyProfile(settings, text, document),
            throwsFormatException,
          );
          expect(settings.changed.keys, ['GET /items']);
        });
      }
    });
  });

  group('validateProfileName', () {
    test('ふつうの名前は通す', () {
      for (final name in ['一覧が空', 'all errors', 'v1.2']) {
        expect(() => validateProfileName(name), returnsNormally, reason: name);
      }
    });

    test('ほかのディレクトリに書ける名前や、作れない名前を拒む', () {
      for (final name in [
        '',
        ' ',
        ' x',
        '.hidden',
        '..',
        'a/b',
        r'a\b',
        'a:b',
        'a\nb',
        'x' * (maxProfileNameLength + 1),
      ]) {
        expect(
          () => validateProfileName(name),
          throwsA(isA<ProfileStoreException>()),
          reason: name,
        );
      }
    });
  });
}
