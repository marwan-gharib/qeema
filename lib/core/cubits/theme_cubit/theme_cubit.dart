import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/constants/app_constants.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_state.dart';
import 'package:qeema/core/local/cache/cache_service.dart';

class ThemeCubit extends Cubit<AppThemeState> {
  ThemeCubit(this._cacheService) : super(const ThemeInitial(ThemeMode.system)) {
    unawaited(_restorePersistedTheme());
  }

  final CacheService _cacheService;

  Future<void> _restorePersistedTheme() async {
    final stored = await _cacheService.get(key: AppConstants.appThemeModeKey);
    if (stored is! String) return;
    final mode = ThemeMode.values.firstWhere(
      (m) => m.name == stored,
      orElse: () => ThemeMode.system,
    );
    emit(ThemeChanged(mode));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _cacheService.set(
      key: AppConstants.appThemeModeKey,
      value: mode.name,
    );
    emit(ThemeChanged(mode));
  }
}
