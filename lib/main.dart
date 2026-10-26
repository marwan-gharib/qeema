import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qeema/app_root.dart';
import 'package:qeema/core/constants/env_config.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/router/app_providers.dart';
import 'package:qeema/features/app_lock/presentation/widgets/app_lock_lifecycle_observer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    publishableKey: EnvConfig.supabasepublishableKey,
  );

  await initDependencies();

  await LocaleSettings.useDeviceLocale();
  await initializeDateFormatting(LocaleSettings.currentLocale.languageCode);

  await Responsive.ensureInitialized();

  runApp(
    AppProviders(
      child: TranslationProvider(
        child: const AppLockLifecycleObserver(child: AppRoot()),
      ),
    ),
  );
}
