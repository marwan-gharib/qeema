import 'dart:async';

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

/// KEY regression: lock then unlock must preserve probe screen state and
/// cubit without re-requesting data.
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
    'KEY regression: lock then unlock preserves probe state and cubit without re-requesting data',
    (tester) async {
      final authCompleter1 = Completer<ApiResult<AppLockStatus>>();
      var callCount = 0;
      when(() => authenticate.call(any())).thenAnswer((_) {
        callCount++;
        if (callCount == 1) return authCompleter1.future;
        return Future.value(const Success(AppLockStatus.authenticated));
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
              create: (_) => ProbeCubit()..loadData(),
              child: const ProbeScreen(),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        buildAppWithOverlay(appLockCubit: cubit, router: router),
      );
      await tester.pump();

      // Cold start unlocks
      authCompleter1.complete(const Success(AppLockStatus.authenticated));
      await tester.pumpAndSettle();

      expect(find.text('Probe State: 1'), findsOneWidget);
      final initialScreenInstance = ProbeScreenState.lastInstance;
      expect(initialScreenInstance, isNotNull);
      expect(ProbeScreenState.initCount, 1);
      expect(ProbeScreenState.disposeCount, 0);
      expect(ProbeCubit.createCount, 1);
      expect(ProbeCubit.closeCount, 0);
      expect(ProbeCubit.loadDataCalls, 1);

      // Now background the app (lock)
      cubit.onAppPaused();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(LockScreen), findsOneWidget);

      // Probe is NOT disposed on lock!
      expect(
        ProbeScreenState.disposeCount,
        0,
        reason: 'Probe screen must not be disposed on lock',
      );
      expect(
        ProbeCubit.closeCount,
        0,
        reason: 'Probe cubit must not be closed on lock',
      );

      // Now resume and unlock
      await cubit.onAppResumed();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(LockScreen), findsNothing);

      // The key assertion: probe state was NOT disposed, NOT recreated, NO new loadData call
      expect(
        ProbeScreenState.disposeCount,
        0,
        reason: 'Probe screen must not be disposed on lock',
      );
      expect(
        ProbeScreenState.initCount,
        1,
        reason: 'Probe screen initState must run only once',
      );
      expect(
        identical(ProbeScreenState.lastInstance, initialScreenInstance),
        isTrue,
        reason:
            'Probe screen State instance must be identical across lock/unlock',
      );
      expect(
        ProbeCubit.closeCount,
        0,
        reason: 'Probe cubit must not be closed on lock',
      );
      expect(
        ProbeCubit.createCount,
        1,
        reason: 'Probe cubit must be created only once',
      );
      expect(
        ProbeCubit.loadDataCalls,
        1,
        reason: 'Data must not be re-requested on unlock',
      );
    },
  );
}
