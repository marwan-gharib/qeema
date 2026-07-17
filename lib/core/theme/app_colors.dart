import 'package:flutter/material.dart';

class AppColors {
  const AppColors({
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

  static const light = AppColors(
    primary: Color(0xFFF5A623),
    primaryVariant: Color(0xFFE08E0B),
    secondary: Color(0xFFA8CD3A),
    secondaryVariant: Color(0xFF6FBF73),
    background: Color(0xFFFFFBF2),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFFFF3D9),
    textPrimary: Color(0xFF2B2A26),
    textSecondary: Color(0xFF79766D),
    error: Color(0xFFD96C4B),
    divider: Color(0xFFEFE7D6),
    onPrimary: Color(0xFFFFFFFF),
  );

  static const dark = AppColors(
    primary: Color(0xFFF0B84D),
    primaryVariant: Color(0xFFFFC96B),
    secondary: Color(0xFFB5D66B),
    secondaryVariant: Color(0xFF7FCB83),
    background: Color(0xFF17160F),
    surface: Color(0xFF221F17),
    surfaceAlt: Color(0xFF2E2717),
    textPrimary: Color(0xFFF5F0E3),
    textSecondary: Color(0xFFA69E8C),
    error: Color(0xFFE38468),
    divider: Color(0xFF3A3527),
    onPrimary: Color(0xFFFFFFFF),
  );
}
