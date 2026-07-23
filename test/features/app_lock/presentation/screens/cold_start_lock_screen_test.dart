import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/app_root.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_state.dart';
import 'package:qeema/features/app_lock/presentation/screens/lock_screen.dart';

import '../../../../helpers/mocks.dart';

class _MockLockCubit extends LockCubit {
  _MockLockCubit(super.service);

  @override
  Future<void> authenticate({required String localizedReason}) async {}

  @override
  AppLockState get state => const AppLockInitial();
}

class _MockBioService extends BiometricAuthService {
  _MockBioService(super.localAuth);

  @override
  Future<bool> get canCheckBiometrics async => false;
}

Widget _buildTestApp(Widget child) {
  LocaleSettings.setLocaleSync(AppLocale.en);
  return TranslationProvider(
    child: MaterialApp(theme: AppTheme.light(), home: child),
  );
}

void main() {
  group('ColdStartLockScreen', () {
    late LockCubit cubit;

    setUp(() {
      cubit = _MockLockCubit(_MockBioService(MockLocalAuthentication()));
    });

    testWidgets('renders LockScreen', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(ColdStartLockScreen(onUnlocked: () {}, lockCubit: cubit)),
      );
      await tester.pump();

      expect(find.byType(LockScreen), findsOneWidget);
    });

    testWidgets('no ParentDataWidget or RenderFlex exception', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(ColdStartLockScreen(onUnlocked: () {}, lockCubit: cubit)),
      );
      await tester.pump();

      expect(find.byType(LockScreen), findsOneWidget);
    });

    testWidgets('PopScope prevents back navigation', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(ColdStartLockScreen(onUnlocked: () {}, lockCubit: cubit)),
      );
      await tester.pump();

      final popScope = tester.widget<PopScope>(find.byType(PopScope));
      expect(popScope.canPop, false);
    });

    testWidgets('reduced motion renders without error', (tester) async {
      LocaleSettings.setLocaleSync(AppLocale.en);
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: TranslationProvider(
            child: MaterialApp(
              theme: AppTheme.light(),
              home: ColdStartLockScreen(onUnlocked: () {}, lockCubit: cubit),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(LockScreen), findsOneWidget);
    });
  });
}
