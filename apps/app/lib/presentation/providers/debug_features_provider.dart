import 'package:flutter_app/debug/debug_features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debug_features_provider.g.dart';

/// デバッグ機能を提供する。
///
/// デバッグビルドでのみ override され、リリースビルドでは常に `null` を返す。
@Riverpod(keepAlive: true)
DebugFeatures? debugFeatures(Ref ref) => null;
