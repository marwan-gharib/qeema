import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/constants/app_constants.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_state.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockCacheService cacheService;

  setUp(() {
    cacheService = MockCacheService();
  });

  test('starts with the system theme', () async {
    final cubit = ThemeCubit(cacheService);
    expect(cubit.state, isA<ThemeInitial>());
    expect(cubit.state.mode, ThemeMode.system);
    await cubit.close();
  });

  test('setThemeMode persists the mode and emits a changed state', () async {
    final cubit = ThemeCubit(cacheService);
    await cubit.setThemeMode(ThemeMode.dark);

    expect(cubit.state, isA<ThemeChanged>());
    expect(cubit.state.mode, ThemeMode.dark);
    expect(
      cacheService.getSync(key: AppConstants.appThemeModeKey),
      ThemeMode.dark.name,
    );
    await cubit.close();
  });

  test('restores a persisted mode on startup', () async {
    await cacheService.set(
      key: AppConstants.appThemeModeKey,
      value: ThemeMode.light.name,
    );

    final cubit = ThemeCubit(cacheService);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state, isA<ThemeChanged>());
    expect(cubit.state.mode, ThemeMode.light);
    await cubit.close();
  });

  test('keeps the system mode when nothing is persisted', () async {
    final cubit = ThemeCubit(cacheService);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state, isA<ThemeInitial>());
    expect(cubit.state.mode, ThemeMode.system);
    await cubit.close();
  });

  test('falls back to system for an unknown persisted value', () async {
    await cacheService.set(key: AppConstants.appThemeModeKey, value: 'neon');

    final cubit = ThemeCubit(cacheService);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.mode, ThemeMode.system);
    await cubit.close();
  });
}