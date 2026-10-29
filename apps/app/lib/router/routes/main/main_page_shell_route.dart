part of 'package:flutter_app/router/router.dart';

@TypedStatefulShellRoute<MainPageShellRoute>(
  branches: [
    homeShellBranch,
    settingShellBranch,
  ],
)
class MainPageShellRoute extends StatefulShellRouteData {
  const new();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MainPage(navigationShell: navigationShell);
  }
}
