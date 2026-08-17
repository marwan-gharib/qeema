import 'package:qeema/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_state.dart';
import 'package:qeema/core/i18n/strings.g.dart';

/// Test seam: the real `setLocale` awaits `LocaleSettings.setLocale`, which
/// loads the deferred `strings_ar` library — a future that never completes
/// inside `testWidgets`' FakeAsync. Real behavior is covered by unit tests.
class RecordingLocaleCubit extends LocaleCubit {
  RecordingLocaleCubit(super.cache);

  final List<AppLocale> requested = [];

  @override
  Future<void> setLocale(AppLocale locale) async {
    requested.add(locale);
    emit(LocaleChanged(locale));
  }
}
