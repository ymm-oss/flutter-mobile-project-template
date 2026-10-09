import 'package:flutter/services.dart';
import 'package:flutter_app/composition_root/data_sources/shared_preference_data_source.dart';
import 'package:flutter_app/debug/debug_features_impl.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/presentation/providers/debug_features_provider.dart';
import 'package:flutter_app/router/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_design_ui/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
  });

  Future<ProviderContainer> pumpApp(
    WidgetTester tester, {
    required bool enableDebugFeatures,
  }) async {
    final debugFeatures = enableDebugFeatures ? createDebugFeatures() : null;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(preferences),
          if (debugFeatures != null) ...[
            debugFeaturesProvider.overrideWithValue(debugFeatures),
            ...debugFeatures.overrides,
          ],
        ],
        child: TranslationProvider(child: const MainApp()),
      ),
    );
    await tester.pumpAndSettle();
    return ProviderScope.containerOf(tester.element(find.byType(MainApp)));
  }

  Future<void> pressDebugShortcut(WidgetTester tester) async {
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyD);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pumpAndSettle();
  }

  testWidgets('デバッグ機能が有効な場合はショートカットキーでデバッグ画面を開ける', (tester) async {
    await pumpApp(tester, enableDebugFeatures: true);

    await pressDebugShortcut(tester);

    expect(find.text('Debug Mode'), findsOneWidget);
  });

  testWidgets('デバッグ機能が無効な場合はデバッグ画面のルートが存在しない', (tester) async {
    final container = await pumpApp(tester, enableDebugFeatures: false);

    await pressDebugShortcut(tester);
    expect(find.text('Debug Mode'), findsNothing);

    final paths = _collectPaths(
      container.read(routerProvider).configuration.routes,
    );
    expect(paths, contains('/'));
    expect(paths, isNot(contains('/debug')));
  });
}

List<String> _collectPaths(List<RouteBase> routes) {
  return [
    for (final route in routes) ...[
      if (route is GoRoute) route.path,
      ..._collectPaths(route.routes),
    ],
  ];
}
