// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore, deprecated_member_use

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$mainPageShellRoute, $maintenancePageRoute];

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

String _$routerHash() => r'ce55d4be66dab6b1629ecde4d9b2ae6525211cdb';
