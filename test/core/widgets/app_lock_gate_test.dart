import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/services/app_lock_service.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/screens/lock_screen.dart';
import 'package:qeema/features/app_lock/presentation/widgets/app_lock_gate.dart';

import '../../helpers/mocks.dart';

class _StubLockCubit extends LockCubit {
  _StubLockCubit(super.service);

  @override
  Future<void> authenticate({required String localizedReason}) async {}
}

Widget _buildTestApp({
  required AppLockService lockService,
  required BiometricAuthService bioService,
  required Widget child,
  LockCubit? lockCubit,
  bool? hasSession,
}) {
  LocaleSettings.setLocaleSync(AppLocale.en);
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: AppLockGate(
        appLockService: lockService,
        biometricAuthService: bioService,
        lockCubit: lockCubit,
        hasSession: hasSession,
        child: child,
      ),
    ),
  );
}

void main() {
  late MockLocalAuthentication mockLocalAuth;
  late MockSecureStorageService mockStorage;
  late BiometricAuthService biometricAuthService;
  late AppLockService appLockService;
  late LockCubit stubCubit;

  setUp(() {
    mockLocalAuth = MockLocalAuthentication();
    mockStorage = MockSecureStorageService();
    biometricAuthService = BiometricAuthService(mockLocalAuth);
    appLockService = AppLockService(mockStorage);
    stubCubit = _StubLockCubit(biometricAuthService);
  });

  group('AppLockGate (resume)', () {
    testWidgets('no lock when flag is disabled', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          lockService: appLockService,
          bioService: biometricAuthService,
          lockCubit: stubCubit,
          child: const Text('app content'),
        ),
      );
      await tester.pump();

      expect(find.text('app content'), findsOneWidget);
      expect(find.text('Qeema'), findsNothing);
    });

    testWidgets('no lock when device not supported', (tester) async {
      mockLocalAuth.isDeviceSupportedResult = false;
      await appLockService.setEnabled();
      await tester.pumpWidget(
        _buildTestApp(
          lockService: appLockService,
          bioService: biometricAuthService,
          lockCubit: stubCubit,
          child: const Text('app content'),
        ),
      );
      await tester.pump();

      expect(find.text('app content'), findsOneWidget);
      expect(find.text('Qeema'), findsNothing);
    });

    testWidgets('no lock before any lifecycle resume event', (tester) async {
      await appLockService.setEnabled();
      await tester.pumpWidget(
        _buildTestApp(
          lockService: appLockService,
          bioService: biometricAuthService,
          lockCubit: stubCubit,
          child: const Text('app content'),
        ),
      );
      await tester.pump();

      expect(find.byType(AppLockGate), findsOneWidget);
      expect(find.text('app content'), findsOneWidget);
      expect(find.text('Qeema'), findsNothing);
    });

    testWidgets('shows lock on lifecycle resume when enabled', (tester) async {
      await appLockService.setEnabled();
      await tester.pumpWidget(
        _buildTestApp(
          lockService: appLockService,
          bioService: biometricAuthService,
          lockCubit: stubCubit,
          hasSession: true,
          child: const Text('app content'),
        ),
      );
      await tester.pump();

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(LockScreen), findsOneWidget);
    });

    testWidgets('ignores stale resume without preceding pause', (tester) async {
      await appLockService.setEnabled();
      await tester.pumpWidget(
        _buildTestApp(
          lockService: appLockService,
          bioService: biometricAuthService,
          lockCubit: stubCubit,
          hasSession: true,
          child: const Text('app content'),
        ),
      );
      await tester.pump();

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(LockScreen), findsNothing);
      expect(find.text('app content'), findsOneWidget);
    });
  });
}
