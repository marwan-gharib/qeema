import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/responsive/responsive.dart';

class AppTextTheme {
  const AppTextTheme._();

  /// Type scale in baseline design units (375×812); every size is scaled
  /// through [Responsive.font] when the theme is built.
  static TextTheme get textTheme => TextTheme(
    displayLarge: TextStyle(
      fontSize: Responsive.font(32),
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      fontSize: Responsive.font(28),
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: TextStyle(
      fontSize: Responsive.font(24),
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      fontSize: Responsive.font(20),
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      fontSize: Responsive.font(18),
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontSize: Responsive.font(16),
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      fontSize: Responsive.font(16),
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      fontSize: Responsive.font(14),
      fontWeight: FontWeight.normal,
    ),
    bodySmall: TextStyle(
      fontSize: Responsive.font(12),
      fontWeight: FontWeight.normal,
    ),
    labelLarge: TextStyle(
      fontSize: Responsive.font(14),
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      fontSize: Responsive.font(11),
      fontWeight: FontWeight.w500,
    ),
  );
}
