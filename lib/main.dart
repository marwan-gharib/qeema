import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qeema/app_root.dart';
import 'package:qeema/core/constants/env_config.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    publishableKey: EnvConfig.supabasepublishableKey,
  );

  await initDependencies();

  await LocaleSettings.useDeviceLocale();

  runApp(TranslationProvider(child: const AppRoot()));
}

