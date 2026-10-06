import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/app_root.dart';
import 'package:qeema/core/constants/env_config.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
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

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LocaleCubit>()),
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
        BlocProvider(create: (_) => getIt<AppLockCubit>()),
      ],
      child: TranslationProvider(
        child: const AppLockLifecycleObserver(child: AppRoot()),
      ),
    ),
  );
}
