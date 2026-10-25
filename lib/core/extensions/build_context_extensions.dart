import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/constants/asset_type_codes.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_colors.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';
import 'package:qeema/core/theme/app_text_styles.dart';

extension BuildContextExtensions on BuildContext {
  AppColors get colors =>
      Theme.of(this).extension<AppColorsExtension>()!.asAppColors;

  /// Falls back to freshly built styles for trees wrapped in a bare
  /// `MaterialApp` (theme-less test harnesses).
  AppTextStylesExtension get textStyles =>
      Theme.of(this).extension<AppTextStylesExtension>() ??
      AppTextStylesExtension.defaults();

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension AssetTypeLocalization on BuildContext {
  String assetTypeName(String code) {
    final assetTypes = t.assets.list;
    return switch (code) {
      AssetTypeCodes.cashEgp => assetTypes.tabEgp,
      AssetTypeCodes.usd => assetTypes.tabUsd,
      AssetTypeCodes.gold21 => assetTypes.tabGold21,
      AssetTypeCodes.gold24 => assetTypes.tabGold24,
      _ => code,
    };
  }
}
