import 'package:flutter/material.dart';

import 'app_colors.dart';

Color _onColor(Color bg) {
  final lum = 0.299 * bg.r + 0.587 * bg.g + 0.114 * bg.b;
  return lum > 0.5 ? const Color(0xFF2B2A26) : Colors.white;
}

ColorScheme appColorScheme(AppColors colors, Brightness brightness) {
  return ColorScheme(
    brightness: brightness,
    primary: colors.primary,
    onPrimary: _onColor(colors.primary),
    primaryContainer: colors.primaryVariant,
    onPrimaryContainer: _onColor(colors.primaryVariant),
    secondary: colors.secondary,
    onSecondary: _onColor(colors.secondary),
    secondaryContainer: colors.secondaryVariant,
    onSecondaryContainer: _onColor(colors.secondaryVariant),
    surface: colors.surface,
    onSurface: colors.textPrimary,
    surfaceContainerHighest: colors.surfaceAlt,
    onSurfaceVariant: colors.textSecondary,
    error: colors.error,
    onError: _onColor(colors.error),
    outline: colors.divider,
    outlineVariant: colors.divider,
  );
}
