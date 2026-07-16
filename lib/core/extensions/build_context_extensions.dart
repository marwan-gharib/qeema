import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_colors_extension.dart';

extension BuildContextExtensions on BuildContext {
  AppColors get colors =>
      Theme.of(this).extension<AppColorsExtension>()!.asAppColors;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;
}
