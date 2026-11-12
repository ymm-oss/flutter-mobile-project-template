import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_debug/ui.dart';

void main() {
  Widget emptyPage(BuildContext context, GoRouterState state) =>
      const SizedBox.shrink();

  Widget passThroughShell(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) => child;

  GoRouter createRouter(List<RouteBase> routes) => GoRouter(
    initialLocation: '/debug',
    routes: [
      ...routes,
      GoRoute(
        path: '/debug',
        builder: (context, state) => const Scaffold(body: RouteDropdownMenu()),
      ),
    ],
  );

  Future<void> pumpRouter(
    WidgetTester tester,
    List<RouteBase> routes,
  ) async {
    final router = createRouter(routes);
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
  }

  List<String> menuPaths(WidgetTester tester) => tester
      .widget<DropdownMenu<String>>(find.byType(DropdownMenu<String>))
      .dropdownMenuEntries
      .map((entry) => entry.value)
      .toList();

  group('パスの一覧', () {
    testWidgets('GoRoute の下の ShellRoute の子ルートは親のパスを引き継ぐ', (tester) async {
      await pumpRouter(tester, [
        GoRoute(
          path: '/parent',
          builder: emptyPage,
          routes: [
            ShellRoute(
              builder: passThroughShell,
              routes: [
                GoRoute(path: 'child', builder: emptyPage),
              ],
            ),
          ],
        ),
      ]);

      expect(menuPaths(tester), ['/parent', '/parent/child']);
    });

    testWidgets(
      'GoRoute の下の StatefulShellRoute の子ルートは親のパスを引き継ぐ',
      (tester) async {
        await pumpRouter(tester, [
          GoRoute(
            path: '/parent',
            builder: emptyPage,
            routes: [
              StatefulShellRoute.indexedStack(
                builder: (context, state, navigationShell) => navigationShell,
                branches: [
                  StatefulShellBranch(
                    routes: [
                      GoRoute(path: 'first', builder: emptyPage),
                    ],
                  ),
                  StatefulShellBranch(
                    routes: [
                      GoRoute(path: 'second', builder: emptyPage),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ]);

        expect(menuPaths(tester), [
          '/parent',
          '/parent/first',
          '/parent/second',
        ]);
      },
    );

    testWidgets('最上位の ShellRoute の子ルートはそのままのパスになる', (tester) async {
      await pumpRouter(tester, [
        ShellRoute(
          builder: passThroughShell,
          routes: [
            GoRoute(
              path: '/home',
              builder: emptyPage,
              routes: [
                GoRoute(path: 'detail', builder: emptyPage),
              ],
            ),
          ],
        ),
      ]);

      expect(menuPaths(tester), ['/home', '/home/detail']);
    });
  });

  testWidgets('Path の入力欄で送信すると遷移する', (tester) async {
    await pumpRouter(tester, [
      GoRoute(
        path: '/target',
        builder: (context, state) => const Text('target'),
      ),
    ]);

    await tester.enterText(find.widgetWithText(TextField, 'Path'), '/target');
    await tester.testTextInput.receiveAction(TextInputAction.go);
    await tester.pumpAndSettle();

    expect(find.text('target'), findsOneWidget);
  });
}
