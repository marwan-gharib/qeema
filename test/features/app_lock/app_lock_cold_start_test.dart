import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/screens/lock_screen.dart';

import 'app_lock_probe_harness.dart';

/// Cold start: with the lock enabled the router child must not build before
/// the unlock; disabled or lockless it builds directly.
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

  testWidgets(
    'Cold start enabled+lock: router child is NOT built before unlock; built once after unlock',
    (tester) async {
      final authCompleter = Completer<ApiResult<AppLockStatus>>();
      when(
        () => authenticate.call(any()),
      ).thenAnswer((_) => authCompleter.future);

      cubit = AppLockCubit(
        getEnabled,
        checkAvailable,
        authenticate,
        setRecentsPreviewHidden,
      );

      final router = GoRouter(
        initialLocation: '/splash',
        routes: [
          GoRoute(
            path: '/splash',
            builder: (context, state) => const SplashProbe(),
          ),
        ],
      );

      await tester.pumpWidget(
        buildAppWithOverlay(appLockCubit: cubit, router: router),
      );
      await tester.pump();

      // LockScreen is visible, SplashProbe is NOT built
      expect(find.byType(LockScreen), findsOneWidget);
      expect(find.byType(SplashProbe), findsNothing);
      expect(SplashProbe.buildCount, 0);

      // Unlock
      authCompleter.complete(const Success(AppLockStatus.authenticated));
      await tester.pumpAndSettle();

      // Now splash is built
      expect(find.byType(LockScreen), findsNothing);
      expect(find.byType(SplashProbe), findsOneWidget);
      expect(SplashProbe.buildCount, 1);
    },
  );

  testWidgets(
    'Cold start disabled / no device lock: lock UI never built, splash built directly',
    (tester) async {
      when(
        () => getEnabled.call(),
      ).thenAnswer((_) async => const Success(false));

      cubit = AppLockCubit(
        getEnabled,
        checkAvailable,
        authenticate,
        setRecentsPreviewHidden,
      );

      final router = GoRouter(
        initialLocation: '/splash',
        routes: [
          GoRoute(
            path: '/splash',
            builder: (context, state) => const SplashProbe(),
          ),
        ],
      );

      await tester.pumpWidget(
        buildAppWithOverlay(appLockCubit: cubit, router: router),
      );
      await tester.pumpAndSettle();

      // LockScreen was never shown
      expect(find.byType(LockScreen), findsNothing);
      expect(find.byType(SplashProbe), findsOneWidget);
    },
  );
}
