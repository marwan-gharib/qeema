import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/theme/app_color_scheme.dart';
import 'package:qeema/core/theme/app_colors.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';
import 'package:qeema/core/theme/app_text_theme.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final colors = AppColors.light;
    return ThemeData.light().copyWith(
      extensions: [AppColorsExtension.fromAppColors(colors)],
      textTheme: AppTextTheme.textTheme,
      scaffoldBackgroundColor: colors.background,
      colorScheme: appColorScheme(colors, Brightness.light),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(color: colors.divider, thickness: 1),
      dialogTheme: _dialogTheme(colors),
      bottomSheetTheme: _bottomSheetTheme(colors),
      snackBarTheme: _snackBarTheme(colors),
      iconTheme: IconThemeData(color: colors.textPrimary),
      listTileTheme: ListTileThemeData(
        textColor: colors.textPrimary,
        iconColor: colors.textSecondary,
      ),
      textButtonTheme: _textButtonTheme(colors),
      outlinedButtonTheme: _outlinedButtonTheme(colors),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
    );
  }

  static ThemeData dark() {
    final colors = AppColors.dark;
    return ThemeData.dark().copyWith(
      extensions: [AppColorsExtension.fromAppColors(colors)],
      textTheme: AppTextTheme.textTheme,
      scaffoldBackgroundColor: colors.background,
      colorScheme: appColorScheme(colors, Brightness.dark),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(color: colors.divider, thickness: 1),
    );
  }

  static DialogThemeData _dialogTheme(AppColors colors) {
    return DialogThemeData(
      backgroundColor: colors.surface,
      surfaceTintColor: colors.surface,
      titleTextStyle: AppTextTheme.textTheme.titleMedium?.copyWith(
        color: colors.textPrimary,
      ),
      contentTextStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
        color: colors.textSecondary,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  static BottomSheetThemeData _bottomSheetTheme(AppColors colors) {
    return BottomSheetThemeData(
      backgroundColor: colors.surface,
      modalBackgroundColor: colors.surface,
      surfaceTintColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  static SnackBarThemeData _snackBarTheme(AppColors colors) {
    return SnackBarThemeData(
      backgroundColor: colors.surfaceAlt,
      contentTextStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
        color: colors.textPrimary,
      ),
      actionTextColor: colors.primaryVariant,
    );
  }

  static TextButtonThemeData _textButtonTheme(AppColors colors) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: colors.primaryVariant),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(AppColors colors) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.primaryVariant,
        side: BorderSide(color: colors.primaryVariant),
      ),
    );
  }
}
