import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/services/app_lock_service.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/features/settings/presentation/cubits/settings_cubit/settings_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/settings_cubit/settings_state.dart';
import 'package:qeema/features/settings/presentation/screens/settings_screen.dart';

import '../../../../helpers/mocks.dart';

Widget _buildTestApp() {
  LocaleSettings.setLocaleSync(AppLocale.en);
  return TranslationProvider(
    child: MaterialApp(theme: AppTheme.light(), home: const SettingsScreen()),
  );
}

void main() {
  late MockLocalAuthentication mockLocalAuth;
  late MockSecureStorageService mockStorage;
  late AppLockService appLockService;
  late BiometricAuthService biometricAuthService;
  late SettingsCubit cubit;

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    mockLocalAuth = MockLocalAuthentication();
    mockStorage = MockSecureStorageService();
    appLockService = AppLockService(mockStorage);
    biometricAuthService = BiometricAuthService(mockLocalAuth);
    cubit = SettingsCubit(appLockService, biometricAuthService);
    getIt.registerFactory<SettingsCubit>(() => cubit);
  });

  tearDown(() {
    cubit.close();
    getIt.reset();
  });

  group('SettingsScreen', () {
    testWidgets('renders security section title', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pump();

      expect(find.text('Security'), findsOneWidget);
    });

    testWidgets('shows lock toggle loaded state', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      cubit.emit(
        const SettingsLoadSuccess(
          isLockEnabled: false,
          isDeviceSupported: true,
        ),
      );
      await tester.pump();

      expect(find.text('Require device unlock to open Qeema'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('shows disabled toggle with caption when device unsupported', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp());
      cubit.emit(
        const SettingsLoadSuccess(
          isLockEnabled: false,
          isDeviceSupported: false,
        ),
      );
      await tester.pump();

      expect(find.text('Require device unlock to open Qeema'), findsOneWidget);
      expect(
        find.text(
          "Your device doesn't have a screen lock set up. Set one up in your device settings to use this feature.",
        ),
        findsOneWidget,
      );
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.onChanged, isNull);
    });

    testWidgets('shows error message on toggle error', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      cubit.emit(
        const SettingsToggleError(
          failure: LocalAuthCancelledFailure(),
          isLockEnabled: false,
          isDeviceSupported: true,
        ),
      );
      await tester.pump();

      expect(find.text('Authentication was cancelled.'), findsOneWidget);
    });
  });
}
