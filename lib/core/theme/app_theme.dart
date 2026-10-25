import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/theme/app_borders.dart';
import 'package:qeema/core/theme/app_color_scheme.dart';
import 'package:qeema/core/theme/app_colors.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';
import 'package:qeema/core/theme/app_elevation.dart';
import 'package:qeema/core/theme/app_radius.dart';
import 'package:qeema/core/theme/app_sizes.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/theme/app_text_styles.dart';
import 'package:qeema/core/theme/app_text_theme.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final colors = AppColors.light;
    return ThemeData.light().copyWith(
      extensions: [
        AppColorsExtension.fromAppColors(colors),
        AppTextStylesExtension.defaults(),
      ],
      textTheme: AppTextTheme.textTheme,
      scaffoldBackgroundColor: colors.background,
      colorScheme: appColorScheme(colors, Brightness.light),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: AppElevation.none,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: AppElevation.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      inputDecorationTheme: _inputDecorationTheme(colors),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          minimumSize: const Size.fromHeight(AppSizes.minTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: AppBorders.hairline,
      ),
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
      extensions: [
        AppColorsExtension.fromAppColors(colors),
        AppTextStylesExtension.defaults(),
      ],
      textTheme: AppTextTheme.textTheme,
      scaffoldBackgroundColor: colors.background,
      colorScheme: appColorScheme(colors, Brightness.dark),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: AppElevation.none,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: AppElevation.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      inputDecorationTheme: _inputDecorationTheme(colors),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          minimumSize: const Size.fromHeight(AppSizes.minTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: AppBorders.hairline,
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(AppColors colors) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: BorderSide(color: colors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: BorderSide(color: colors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: BorderSide(
          color: colors.primary,
          width: AppBorders.emphasis,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: Responsive.adapt(14),
      ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );
  }

  static BottomSheetThemeData _bottomSheetTheme(AppColors colors) {
    return BottomSheetThemeData(
      backgroundColor: colors.surface,
      modalBackgroundColor: colors.surface,
      surfaceTintColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
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
