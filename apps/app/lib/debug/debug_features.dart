import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// デバッグビルドでのみ有効にするデバッグ機能を表す。
///
/// 実装は `debug_features_impl.dart` にあり、`kDebugMode` でガードされた箇所からのみ
/// 生成される。リリースビルドではデバッグ機能の実装やデバッグ用パッケージへの参照が
/// 無くなるため、Dart の tree shaking によってバイナリから除外される。
///
/// デバッグ機能を利用する側は、このインターフェースのみに依存すること。
abstract interface class DebugFeatures {
  /// ルートの [ProviderScope] に適用する [Override] の一覧。
  List<Override> get overrides;

  /// ルートの [ProviderScope] に登録する [ProviderObserver] の一覧。
  List<ProviderObserver> get observers;

  /// デバッグ画面のルート一覧。
  List<RouteBase> get routes;

  /// アプリ全体をラップする [TransitionBuilder]。
  ///
  /// デバッグ画面への動線（シェイク、ショートカットキー）やアクセシビリティツールを提供する。
  TransitionBuilder get appBuilder;
}
