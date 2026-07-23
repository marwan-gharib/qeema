import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/core/router/app_router.dart';
import 'package:qeema/core/services/app_lock_service.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/utils/logger.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/screens/lock_screen.dart';
import 'package:qeema/features/app_lock/presentation/widgets/app_lock_gate.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late Future<ColdStartDecision> _decisionFuture;

  @override
  void initState() {
    super.initState();
    _decisionFuture = _resolveColdStartDecision();
  }

  Future<ColdStartDecision> _resolveColdStartDecision() async {
    try {
      return await _resolveColdStartDecisionFromGetIt().timeout(
        const Duration(seconds: 10),
      );
    } on TimeoutException {
      Logger.warning(
        '[AppRoot] cold-start decision timed out, defaulting to requireUnlock',
      );
      return ColdStartDecision.requireUnlock;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ColdStartDecision>(
      future: _decisionFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const _ColdStartDecidingPlaceholder();
        }
        if (snapshot.data == ColdStartDecision.requireUnlock) {
          return MaterialApp(
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            supportedLocales: AppLocaleUtils.supportedLocales,
            home: ColdStartLockScreen(
              onUnlocked: () => setState(() {
                _decisionFuture = Future.value(ColdStartDecision.proceed);
              }),
            ),
          );
        }
        return const QeemaApp();
      },
    );
  }
}

Future<ColdStartDecision> _resolveColdStartDecisionFromGetIt() async {
  final hasSession =
      getIt<SupabaseClientProvider>().client.auth.currentSession != null;
  return resolveColdStartDecision(
    hasSession: hasSession,
    isEnabled: getIt<AppLockService>().isEnabled(),
    isDeviceSupported: getIt<BiometricAuthService>().isDeviceSupported,
  );
}

Future<ColdStartDecision> resolveColdStartDecision({
  required bool hasSession,
  required Future<bool> isEnabled,
  required Future<bool> isDeviceSupported,
}) async {
  if (!hasSession || !await isEnabled || !await isDeviceSupported) {
    return ColdStartDecision.proceed;
  }
  return ColdStartDecision.requireUnlock;
}

enum ColdStartDecision { proceed, requireUnlock }

class _ColdStartDecidingPlaceholder extends StatelessWidget {
  const _ColdStartDecidingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(color: AppTheme.light().scaffoldBackgroundColor),
    );
  }
}

class ColdStartLockScreen extends StatelessWidget {
  const ColdStartLockScreen({
    super.key,
    required this.onUnlocked,
    this.lockCubit,
  });

  final VoidCallback onUnlocked;
  final LockCubit? lockCubit;

  @override
  Widget build(BuildContext context) {
    return LockScreen(onUnlocked: onUnlocked, lockCubit: lockCubit);
  }
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
      builder: (context, child) => AppLockGate(child: child!),
    );
  }
}
