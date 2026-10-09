// デバッグ用パッケージはリリースにバンドルしないよう dev_dependencies に定義している。
// このファイルは `kDebugMode` でガードされた箇所からのみ参照されるため、
// リリースビルドでは tree shaking によって除外される。
// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/debug/debug_features.dart';
import 'package:flutter_app/presentation/providers/force_update_policy_notifier_provider.dart';
import 'package:flutter_app/presentation/providers/maintenance_policy_notifier_provider.dart';
import 'package:flutter_app/router/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_debug/ui.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';

part 'debug_features_impl.g.dart';
part 'routes/debug_page_route.dart';

/// [DebugFeatures] を生成する。
///
/// リリースビルドに含めないため、必ず `kDebugMode` でガードして呼び出すこと。
DebugFeatures createDebugFeatures() {
  final talker = TalkerFlutter.init(settings: TalkerSettings());
  return _DebugFeaturesImpl(talker: talker);
}

final class _DebugFeaturesImpl implements DebugFeatures {
  _DebugFeaturesImpl({required Talker talker}) : _talker = talker;

  final Talker _talker;

  @override
  List<Override> get overrides => [
    talkerProvider.overrideWithValue(_talker),
  ];

  @override
  List<ProviderObserver> get observers => [
    TalkerRiverpodObserver(talker: _talker),
  ];

  @override
  List<RouteBase> get routes => $appRoutes;

  @override
  TransitionBuilder get appBuilder =>
      (context, child) => _DebugApp(child: child ?? const SizedBox.shrink());
}

class _DebugApp extends ConsumerWidget {
  const _DebugApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enableAccessibilityTools = ref.watch(
      enableAccessibilityToolsProvider,
    );

    void openDebugPage() {
      final router = ref.read(routerProvider);
      final isDebugRoute = router.state.uri.path.startsWith(
        DebugPageRoute.path,
      );
      if (isDebugRoute) {
        return;
      }

      unawaited(router.push(const DebugPageRoute().location));
    }

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyD, shift: true):
            openDebugPage,
      },
      child: ShakeDetection(
        onShake: openDebugPage,
        child: enableAccessibilityTools
            ? AccessibilityTools(child: child)
            : child,
      ),
    );
  }
}
