import 'package:material_ui/material_ui.dart';

sealed class AppThemeState {
  const AppThemeState(this.mode);
  final ThemeMode mode;
}

final class ThemeInitial extends AppThemeState {
  const ThemeInitial(super.mode);
}

final class ThemeChanged extends AppThemeState {
  const ThemeChanged(super.mode);
}
