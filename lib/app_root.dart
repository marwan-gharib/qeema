import 'package:cupertino_ui/cupertino_ui.dart'
    show GlobalCupertinoLocalizations;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_state.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_state.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/app_router.dart';
import 'package:qeema/core/theme/app_theme.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return const QeemaApp();
  }
}

class QeemaApp extends StatelessWidget {
  const QeemaApp({super.key});

  /// Build counter for the freeze regression test — asserts MaterialApp is
  /// not rebuilt in a loop when theme/locale changes are emitted.
  static int debugMaterialAppBuilds = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            debugMaterialAppBuilds++;
            return MaterialApp.router(
              title: context.t.app.name,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: themeState.mode,
              locale: localeState.locale.flutterLocale,
              routerConfig: AppRouter.router,
              supportedLocales: AppLocaleUtils.supportedLocales,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
            );
          },
        );
      },
    );
  }
}