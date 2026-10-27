import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/screens/lock_screen.dart';

import 'app_lock_probe_harness.dart';

/// Cancel/lockout/error keep the overlay up and expose the Unlock button;
/// tapping Unlock retries the prompt.
void main() {
  late FakeGetAppLockEnabledUseCase getEnabled;
  late FakeCheckDeviceLockAvailableUseCase checkAvailable;
  late FakeAuthenticateDeviceUseCase authenticate;
  late FakeSetRecentsPreviewHiddenUseCase setRecentsPreviewHidden;
  late AppLockCubit cubit;

  setUpAll(() {
    LocaleSettings.useDeviceLocale();
  });

  setUp(() {
    ProbeCubit.resetCounts();
    ProbeScreenState.resetCounts();
    SplashProbe.buildCount = 0;

    getEnabled = FakeGetAppLockEnabledUseCase();
    checkAvailable = FakeCheckDeviceLockAvailableUseCase();
    authenticate = FakeAuthenticateDeviceUseCase();
    setRecentsPreviewHidden = FakeSetRecentsPreviewHiddenUseCase();

    when(() => getEnabled.call()).thenAnswer((_) async => const Success(true));
    when(
      () => checkAvailable.call(),
    ).thenAnswer((_) async => const Success(true));
    when(
      () => setRecentsPreviewHidden.call(any()),
    ).thenAnswer((_) async => const Success(null));
  });

  tearDown(() {
    cubit.close();
  });

  testWidgets('Cancel/lockout/error: overlay stays, Unlock retry works', (
    tester,
  ) async {
    var callCount = 0;
    when(() => authenticate.call(any())).thenAnswer((_) async {
      callCount++;
      if (callCount == 1) {
        return const Success(AppLockStatus.failed);
      }
      return const Success(AppLockStatus.authenticated);
    });

    cubit = AppLockCubit(
      getEnabled,
      checkAvailable,
      authenticate,
      setRecentsPreviewHidden,
    );

    final router = GoRouter(
      initialLocation: '/probe',
      routes: [
        GoRoute(
          path: '/probe',
          builder: (context, state) => BlocProvider(
            create: (_) => ProbeCubit(),
            child: const ProbeScreen(),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      buildAppWithOverlay(appLockCubit: cubit, router: router),
    );
    await tester.pumpAndSettle();

    // First prompt failed -> cancelled reason -> shows Unlock button
    expect(find.byType(LockScreen), findsOneWidget);
    expect(find.text(t.app_lock.unlockButton), findsOneWidget);
    expect(find.byType(ProbeScreen), findsNothing);

    // Tap Unlock to retry
    await tester.tap(find.text(t.app_lock.unlockButton));
    await tester.pumpAndSettle();

    // Second prompt succeeded -> unlocked -> probe visible
    expect(find.byType(LockScreen), findsNothing);
    expect(find.byType(ProbeScreen), findsOneWidget);
  });
}
