import 'package:qeema/core/i18n/strings.g.dart';

sealed class LocaleState {
  const LocaleState(this.locale);
  final AppLocale locale;
}

final class LocaleInitial extends LocaleState {
  const LocaleInitial(super.locale);
}

final class LocaleChanged extends LocaleState {
  const LocaleChanged(super.locale);
}
