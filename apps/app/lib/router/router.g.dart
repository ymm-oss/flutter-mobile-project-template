// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore, deprecated_member_use

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $debugPageRoute,
  $mainPageShellRoute,
  $maintenancePageRoute,
];

RouteBase get $debugPageRoute => GoRouteData.$route(
  path: '/debug',
  hasOverriddenOnExit: false,
  parentNavigatorKey: DebugPageRoute.$parentNavigatorKey,
  factory: $DebugPageRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'navigation_debug',
      hasOverriddenOnExit: false,
      parentNavigatorKey: NavigationDebugPageRoute.$parentNavigatorKey,
      factory: $NavigationDebugPageRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'talker',
      hasOverriddenOnExit: false,
      parentNavigatorKey: TalkerPageRoute.$parentNavigatorKey,
      factory: $TalkerPageRoute._fromState,
    ),
  ],
);

mixin $DebugPageRoute on GoRouteData {
  static DebugPageRoute _fromState(GoRouterState state) =>
      const DebugPageRoute();

  @override
  String get location => GoRouteData.$location('/debug');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $NavigationDebugPageRoute on GoRouteData {
  static NavigationDebugPageRoute _fromState(GoRouterState state) =>
      const NavigationDebugPageRoute();

  @override
  String get location => GoRouteData.$location('/debug/navigation_debug');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $TalkerPageRoute on GoRouteData {
  static TalkerPageRoute _fromState(GoRouterState state) =>
      const TalkerPageRoute();

  @override
  String get location => GoRouteData.$location('/debug/talker');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mainPageShellRoute => StatefulShellRouteData.$route(
  factory: $MainPageShellRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/',
          hasOverriddenOnExit: false,
          factory: $HomePageRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/setting',
          hasOverriddenOnExit: false,
          factory: $SettingPageRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'license',
              hasOverriddenOnExit: false,
              factory: $LicensePageRoute._fromState,
            ),
          ],
        ),
      ],
    ),
  ],
);

extension $MainPageShellRouteExtension on MainPageShellRoute {
  static MainPageShellRoute _fromState(GoRouterState state) =>
      const MainPageShellRoute();
}

mixin $HomePageRoute on GoRouteData {
  static HomePageRoute _fromState(GoRouterState state) => const HomePageRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingPageRoute on GoRouteData {
  static SettingPageRoute _fromState(GoRouterState state) =>
      const SettingPageRoute();

  @override
  String get location => GoRouteData.$location('/setting');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LicensePageRoute on GoRouteData {
  static LicensePageRoute _fromState(GoRouterState state) =>
      const LicensePageRoute();

  @override
  String get location => GoRouteData.$location('/setting/license');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $maintenancePageRoute => GoRouteData.$route(
  path: '/maintenance',
  hasOverriddenOnExit: false,
  factory: $MaintenancePageRoute._fromState,
);

mixin $MaintenancePageRoute on GoRouteData {
  static MaintenancePageRoute _fromState(GoRouterState state) =>
      const MaintenancePageRoute();

  @override
  String get location => GoRouteData.$location('/maintenance');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(router)
final routerProvider = RouterProvider._();

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  RouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return router(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$routerHash() => r'7f2c119c1ed13737bc4e35a5527ceed85f06309a';
