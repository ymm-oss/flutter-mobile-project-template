// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'app_colors.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$AppColors on ThemeExtension<AppColors> {
  @override
  ThemeExtension<AppColors> copyWith({Color? icon}) {
    final _this = (this as AppColors);

    return AppColors(icon: icon ?? _this.icon);
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    final _this = (this as AppColors);

    return AppColors(icon: Color.lerp(_this.icon, other.icon, t)!);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as AppColors);
    final _other = (other as AppColors);

    return _other.icon == _this.icon;
  }

  @override
  int get hashCode {
    final _this = (this as AppColors);

    return Object.hash(runtimeType, _this.icon);
  }
}

extension AppColorsBuildContext on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
