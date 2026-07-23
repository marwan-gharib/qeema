import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_state.dart';
import 'package:qeema/features/app_lock/presentation/screens/lock_screen.dart';

class _MockBiometricAuthService implements BiometricAuthService {
  @override
  Future<ApiResult<bool>> authenticate({
    required String localizedReason,
  }) async {
    return const Success(true);
  }

  @override
  Future<bool> get isDeviceSupported async => true;

  @override
  Future<bool> get canCheckBiometrics async => false;

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async => [];
}

final _mockBio = _MockBiometricAuthService();

Widget _buildTestApp(LockCubit cubit) {
  LocaleSettings.setLocaleSync(AppLocale.en);
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: LockScreen(onUnlocked: () {}, lockCubit: cubit),
    ),
  );
}

class _MockLockCubit extends LockCubit {
  _MockLockCubit(super.biometricAuthService, AppLockState initialState)
    : _initialState = initialState;

  final AppLockState _initialState;
  var authCallCount = 0;

  @override
  AppLockState get state => _initialState;

  @override
  Future<void> authenticate({required String localizedReason}) async {
    authCallCount++;
  }
}

void main() {
  group('LockScreen', () {
    testWidgets('renders unlock prompt in initial state', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(_MockLockCubit(_mockBio, const AppLockInitial())),
      );
      await tester.pump();

      expect(find.text('Qeema'), findsOneWidget);
      expect(find.text('Value'), findsOneWidget);
      expect(find.text('Unlock Qeema to view your finances'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byType(AppButton), findsNothing);
    });

    testWidgets('shows loading indicator when authenticating', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(_MockLockCubit(_mockBio, const AppLockAuthenticating())),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
    });

    testWidgets('shows mapped error on LocalAuthLockoutFailure', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          _MockLockCubit(
            _mockBio,
            const AppLockError(LocalAuthLockoutFailure()),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Too many attempts. Try again later.'), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('shows mapped error on LocalAuthCancelledFailure', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          _MockLockCubit(
            _mockBio,
            const AppLockError(LocalAuthCancelledFailure()),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Biometric authentication failed'), findsOneWidget);
    });

    testWidgets('shows mapped error on LocalAuthNoCredentialsFailure', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          _MockLockCubit(
            _mockBio,
            const AppLockError(LocalAuthNoCredentialsFailure()),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        find.text(
          'No device lock set up. Set up a screen lock in your device settings.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders with disableAnimations: true without error', (
      tester,
    ) async {
      LocaleSettings.setLocaleSync(AppLocale.en);
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: TranslationProvider(
            child: MaterialApp(
              theme: AppTheme.light(),
              home: LockScreen(
                onUnlocked: () {},
                lockCubit: _MockLockCubit(_mockBio, const AppLockInitial()),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Qeema'), findsOneWidget);
    });

    testWidgets('PopScope prevents back navigation', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(_MockLockCubit(_mockBio, const AppLockInitial())),
      );
      await tester.pump();

      final popScope = tester.widget<PopScope>(find.byType(PopScope));
      expect(popScope.canPop, false);
    });

    testWidgets('retry button triggers authenticate call', (tester) async {
      final cubit = _MockLockCubit(
        _mockBio,
        const AppLockError(LocalAuthCancelledFailure()),
      );
      await tester.pumpWidget(_buildTestApp(cubit));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      cubit.authCallCount = 0;
      await tester.tap(find.text('Try Again'));
      await tester.pump();

      expect(cubit.authCallCount, 1);
    });

    testWidgets('shows lock icon when biometrics unavailable', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(_MockLockCubit(_mockBio, const AppLockInitial())),
      );
      await tester.pump();

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byIcon(Icons.fingerprint), findsNothing);
    });
  });
}
