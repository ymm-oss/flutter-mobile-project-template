import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_app/composition_root/data_sources/shared_preference_data_source.dart';
import 'package:flutter_app/configuration/build_config.dart';
import 'package:flutter_app/presentation/providers/build_config_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:internal_shared/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef InitializedValues = ({List<Override> overrideProviders});

final class AppInitializer {
  AppInitializer._();

  static Future<InitializedValues> initialize() async {
    LoggerManager.instance.initialize(isDebugMode: kDebugMode);

    final overrideProviders = await _initializeProviders();

    return (overrideProviders: overrideProviders);
  }

  /// Returns list of [Override] that should be applied to root [ProviderScope].
  static Future<List<Override>> _initializeProviders() async {
    final overrides = <Override>[];

    final packageInfo = await PackageInfo.fromPlatform();
    final preferences = await SharedPreferences.getInstance();

    final buildConfig = BuildConfig.fromPackageInfo(packageInfo);
    logger.info(buildConfig);

    overrides.addAll(
      [
        sharedPreferencesProvider.overrideWithValue(preferences),
        buildConfigProvider.overrideWithValue(buildConfig),
      ],
    );
    return overrides;
  }
}
