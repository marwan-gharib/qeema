import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/app_router.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://your-project-id.supabase.co',
    publishableKey: 'your-anon-key',
  );

  await initDependencies();

  await LocaleSettings.useDeviceLocale();

  runApp(TranslationProvider(child: const QeemaApp()));
}

class QeemaApp extends StatelessWidget {
  const QeemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: context.t.app.name,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      supportedLocales: AppLocaleUtils.supportedLocales,
    );
  }
}
