import 'package:flutter/material.dart';
import 'package:qeema/core/theme/app_colors.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.secondaryVariant,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.textPrimary,
    required this.textSecondary,
    required this.error,
    required this.divider,
    required this.onPrimary,
  });

  factory AppColorsExtension.fromAppColors(AppColors colors) {
    return AppColorsExtension(
      primary: colors.primary,
      primaryVariant: colors.primaryVariant,
      secondary: colors.secondary,
      secondaryVariant: colors.secondaryVariant,
      background: colors.background,
      surface: colors.surface,
      surfaceAlt: colors.surfaceAlt,
      textPrimary: colors.textPrimary,
      textSecondary: colors.textSecondary,
      error: colors.error,
      divider: colors.divider,
      onPrimary: colors.onPrimary,
    );
  }
  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color secondaryVariant;
  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color textPrimary;
  final Color textSecondary;
  final Color error;
  final Color divider;
  final Color onPrimary;

  AppColors get asAppColors => AppColors(
    primary: primary,
    primaryVariant: primaryVariant,
    secondary: secondary,
    secondaryVariant: secondaryVariant,
    background: background,
    surface: surface,
    surfaceAlt: surfaceAlt,
    textPrimary: textPrimary,
    textSecondary: textSecondary,
    error: error,
    divider: divider,
    onPrimary: onPrimary,
  );

  @override
  AppColorsExtension copyWith({
    Color? primary,
    Color? primaryVariant,
    Color? secondary,
    Color? secondaryVariant,
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? textPrimary,
    Color? textSecondary,
    Color? error,
    Color? divider,
    Color? onPrimary,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      primaryVariant: primaryVariant ?? this.primaryVariant,
      secondary: secondary ?? this.secondary,
      secondaryVariant: secondaryVariant ?? this.secondaryVariant,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      error: error ?? this.error,
      divider: divider ?? this.divider,
      onPrimary: onPrimary ?? this.onPrimary,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryVariant: Color.lerp(primaryVariant, other.primaryVariant, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryVariant: Color.lerp(
        secondaryVariant,
        other.secondaryVariant,
        t,
      )!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      error: Color.lerp(error, other.error, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
    );
  }
}
