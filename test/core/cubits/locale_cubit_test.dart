import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/constants/app_constants.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_state.dart';
import 'package:qeema/core/i18n/strings.g.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockCacheService cacheService;

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    cacheService = MockCacheService();
  });

  test('starts with the current locale', () async {
    final cubit = LocaleCubit(cacheService);
    expect(cubit.state, isA<LocaleInitial>());
    expect(cubit.state.locale, AppLocale.en);
    await cubit.close();
  });

  test('setLocale persists the language and emits a changed state', () async {
    final cubit = LocaleCubit(cacheService);
    await cubit.setLocale(AppLocale.ar);

    expect(cubit.state, isA<LocaleChanged>());
    expect(cubit.state.locale, AppLocale.ar);
    expect(cacheService.getSync(key: AppConstants.appLocaleKey), 'ar');
    expect(LocaleSettings.currentLocale, AppLocale.ar);
    await cubit.close();
  });

  test('restores a persisted locale on startup', () async {
    await cacheService.set(key: AppConstants.appLocaleKey, value: 'ar');

    final cubit = LocaleCubit(cacheService);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state, isA<LocaleChanged>());
    expect(cubit.state.locale, AppLocale.ar);
    await cubit.close();
  });

  test('keeps the current locale when nothing is persisted', () async {
    final cubit = LocaleCubit(cacheService);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state, isA<LocaleInitial>());
    expect(cubit.state.locale, AppLocale.en);
    await cubit.close();
  });

  test('ignores a corrupted persisted value', () async {
    await cacheService.set(key: AppConstants.appLocaleKey, value: 'zz');

    final cubit = LocaleCubit(cacheService);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.locale, AppLocale.en);
    await cubit.close();
  });
}