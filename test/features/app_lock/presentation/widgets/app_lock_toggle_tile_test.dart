import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/services/app_lock_service.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/widgets/app_lock_toggle_tile.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockLocalAuthentication localAuth;
  late MockSecureStorageService storage;
  late BiometricAuthService biometricAuthService;
  late AppLockService appLockService;
  late LockCubit lockCubit;

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    localAuth = MockLocalAuthentication();
    storage = MockSecureStorageService();
    biometricAuthService = BiometricAuthService(localAuth);
    appLockService = AppLockService(storage);
    lockCubit = LockCubit(biometricAuthService);
  });

  tearDown(() => lockCubit.close());

  Widget harness() {
    return TranslationProvider(
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Center(
            child: AppLockToggleTile(
              appLockService: appLockService,
              biometricAuthService: biometricAuthService,
              lockCubit: lockCubit,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets(
    'disables the switch and explains when the device is unsupported',
    (tester) async {
      localAuth.isDeviceSupportedResult = false;

      await tester.pumpWidget(harness());
      await settle(tester);

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.onChanged, isNull);
      expect(switchWidget.value, false);
      expect(
        find.text(
          'Your device doesn\'t have a screen lock set up. Set one up in your '
          'device settings to use this feature.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('enabling authenticates, persists, and flips the switch', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await settle(tester);

    await tester.tap(find.byType(Switch));
    await settle(tester);

    expect(tester.widget<Switch>(find.byType(Switch)).value, true);
    expect(await storage.read(key: 'is_local_auth_enabled'), 'true');
  });

  testWidgets('disabling authenticates and persists off', (tester) async {
    await storage.write(key: 'is_local_auth_enabled', value: 'true');

    await tester.pumpWidget(harness());
    await settle(tester);
    expect(tester.widget<Switch>(find.byType(Switch)).value, true);

    await tester.tap(find.byType(Switch));
    await settle(tester);

    expect(tester.widget<Switch>(find.byType(Switch)).value, false);
    expect(await storage.read(key: 'is_local_auth_enabled'), 'false');
  });

  testWidgets('a cancelled authentication keeps the switch unchanged', (
    tester,
  ) async {
    localAuth.throwException = true;
    localAuth.exceptionToThrow = const LocalAuthException(
      code: LocalAuthExceptionCode.userCanceled,
    );

    await tester.pumpWidget(harness());
    await settle(tester);

    await tester.tap(find.byType(Switch));
    await settle(tester);

    expect(tester.widget<Switch>(find.byType(Switch)).value, false);
    expect(find.text('Authentication was cancelled.'), findsOneWidget);
  });

  testWidgets('no device credentials shows the no-device-lock message', (
    tester,
  ) async {
    localAuth.throwException = true;
    localAuth.exceptionToThrow = const LocalAuthException(
      code: LocalAuthExceptionCode.noCredentialsSet,
    );

    await tester.pumpWidget(harness());
    await settle(tester);

    await tester.tap(find.byType(Switch));
    await settle(tester);

    expect(tester.widget<Switch>(find.byType(Switch)).value, false);
    expect(
      find.text(
        'Your device doesn\'t have a screen lock set up. Set one up in your '
        'device settings to use this feature.',
      ),
      findsOneWidget,
    );
  });
}
