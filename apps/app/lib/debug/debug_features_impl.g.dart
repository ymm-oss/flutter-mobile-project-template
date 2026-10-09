// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore, deprecated_member_use

part of 'debug_features_impl.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$debugPageRoute];

RouteBase get $debugPageRoute => GoRouteData.$route(
  path: '/debug',

  parentNavigatorKey: DebugPageRoute.$parentNavigatorKey,

  factory: _$DebugPageRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'navigation_debug',

      parentNavigatorKey: NavigationDebugPageRoute.$parentNavigatorKey,

      factory: _$NavigationDebugPageRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'talker',

      parentNavigatorKey: TalkerPageRoute.$parentNavigatorKey,

      factory: _$TalkerPageRoute._fromState,
    ),
  ],
);

mixin _$DebugPageRoute on GoRouteData {
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

mixin _$NavigationDebugPageRoute on GoRouteData {
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

mixin _$TalkerPageRoute on GoRouteData {
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
