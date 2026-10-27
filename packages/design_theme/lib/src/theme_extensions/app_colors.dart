import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'app_colors.g.theme.dart';

@themeExtensions
class AppColors extends ThemeExtension<AppColors> with _$AppColors {
  const AppColors({
    required this.icon,
  });

  /// Create a light [AppColors].
  factory AppColors.light() => const AppColors(icon: Color(0xFF009688));

  /// Create a dark [AppColors].
  factory AppColors.dark() => const AppColors(icon: Color(0xFF80CBC4));

  final Color icon;
}
