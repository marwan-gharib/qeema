import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/core/widgets/app_loader.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_state.dart';
import 'package:qeema/features/app_lock/presentation/screens/lock_screen.dart';

import '../../../../helpers/app_lock_mocks.dart';

void main() {
  late MockGetAppLockEnabledUseCase getEnabled;
  late MockCheckDeviceLockAvailableUseCase checkAvailable;
  late MockAuthenticateDeviceUseCase authenticate;
  late MockSetRecentsPreviewHiddenUseCase setRecentsPreviewHidden;
  late AppLockCubit cubit;

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    getEnabled = MockGetAppLockEnabledUseCase();
    checkAvailable = MockCheckDeviceLockAvailableUseCase();
    authenticate = MockAuthenticateDeviceUseCase();
    setRecentsPreviewHidden = MockSetRecentsPreviewHiddenUseCase();
    cubit = AppLockCubit(
      getEnabled,
      checkAvailable,
      authenticate,
      setRecentsPreviewHidden,
    );
  });

  tearDown(() {
    cubit.close();
  });

  Widget harness() {
    return TranslationProvider(
      child: BlocProvider<AppLockCubit>.value(
        value: cubit,
        child: MaterialApp(theme: AppTheme.light(), home: const LockScreen()),
      ),
    );
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('shows the prompt loader while the state is still checking', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await settle(tester);

    expect(find.byType(AppLoader), findsOneWidget);
    expect(find.text('Qeema is locked'), findsOneWidget);
    expect(find.text('Use your device credentials to unlock'), findsOneWidget);
    expect(find.byType(AppButton), findsNothing);
  });

  testWidgets('shows the unlock button after the user cancels the prompt', (
    tester,
  ) async {
    authenticate.result = const Success(AppLockStatus.failed);
    await cubit.onAppResumed();

    await tester.pumpWidget(harness());
    await settle(tester);

    expect(find.byType(AppButton), findsOneWidget);
    expect(find.widgetWithText(AppButton, 'Unlock'), findsOneWidget);
    expect(find.byType(AppLoader), findsNothing);
  });

  testWidgets('shows the locked-out message when the OS locks out attempts', (
    tester,
  ) async {
    authenticate.result = const Success(AppLockStatus.lockedOut);
    await cubit.onAppResumed();

    await tester.pumpWidget(harness());
    await settle(tester);

    expect(
      find.text('Too many attempts. Try again after the cooldown.'),
      findsOneWidget,
    );
    expect(find.widgetWithText(AppButton, 'Unlock'), findsOneWidget);
  });

  testWidgets('shows the error message and stays locked when evaluation '
      'fails', (tester) async {
    getEnabled.result = const ResultFailure(CacheFailure());
    await cubit.onAppResumed();

    await tester.pumpWidget(harness());
    await settle(tester);

    expect(
      find.text("Couldn't verify your identity. Try again."),
      findsOneWidget,
    );
    expect(find.widgetWithText(AppButton, 'Unlock'), findsOneWidget);
  });

  testWidgets('a back gesture cannot pop the lock screen', (tester) async {
    authenticate.result = const Success(AppLockStatus.failed);
    await cubit.onAppResumed();

    var popResults = 0;
    await tester.pumpWidget(
      TranslationProvider(
        child: BlocProvider<AppLockCubit>.value(
          value: cubit,
          child: MaterialApp(
            theme: AppTheme.light(),
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () => Navigator.of(context)
                      .push(
                        MaterialPageRoute<void>(
                          builder: (_) => const LockScreen(),
                        ),
                      )
                      .then((_) => popResults++),
                  child: const Text('enter'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await settle(tester);

    await tester.tap(find.text('enter'));
    await tester.pumpAndSettle();
    expect(find.byType(LockScreen), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(
      find.byType(LockScreen),
      findsOneWidget,
      reason: 'PopScope(canPop: false) must keep the user on /lock',
    );
    expect(popResults, 0);
  });

  testWidgets('tapping Unlock re-evaluates the gate and opens when the '
      'prompt succeeds', (tester) async {
    authenticate.result = const Success(AppLockStatus.failed);
    await cubit.onAppResumed();
    await tester.pumpWidget(harness());
    await settle(tester);
    expect(find.byType(AppButton), findsOneWidget);

    authenticate.result = const Success(AppLockStatus.authenticated);
    await tester.tap(find.widgetWithText(AppButton, 'Unlock'));
    await settle(tester);

    expect(cubit.state, isA<AppLockUnlocked>());
    expect(find.byType(AppButton), findsNothing);
    expect(find.byType(AppLoader), findsOneWidget);
  });
}
