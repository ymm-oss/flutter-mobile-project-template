part of 'package:flutter_app/router/router.dart';

const homeShellBranch = TypedStatefulShellBranch<HomeShellBranch>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<HomePageRoute>(
      path: HomePageRoute.path,
    ),
  ],
);

class HomeShellBranch extends StatefulShellBranchData {
  const new();
}

class HomePageRoute extends GoRouteData with $HomePageRoute {
  const new();

  static const path = '/';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CustomAppLifecycleListener(
      onResume: () {
        // Example: Obtain the latest AppStatus and update if needed.
      },
      // By overriding the Provider in the Route build method, it is possible to
      // switch the implementation of Navigator based on the source of
      // navigation or the state.
      child: const ProviderScope(child: HomePage()),
    );
  }
}
