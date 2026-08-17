import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/constants/app_constants.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_state.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/local/cache/cache_service.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(this._cacheService)
    : super(LocaleInitial(LocaleSettings.currentLocale)) {
    unawaited(_restorePersistedLocale());
  }

  final CacheService _cacheService;

  Future<void> _restorePersistedLocale() async {
    final stored = await _cacheService.get(key: AppConstants.appLocaleKey);
    if (stored is! String) return;
    final locale = AppLocaleUtils.parse(stored);
    await LocaleSettings.setLocale(locale);
    emit(LocaleChanged(locale));
  }

  Future<void> setLocale(AppLocale locale) async {
    await LocaleSettings.setLocale(locale);
    await _cacheService.set(
      key: AppConstants.appLocaleKey,
      value: locale.languageCode,
    );
    emit(LocaleChanged(locale));
  }
}
