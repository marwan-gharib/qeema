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

/// After the first entry, later lock/unlock cycles keep using the overlay
/// without ever rebuilding or disposing the probe.
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
    when(
      () => authenticate.call(any()),
    ).thenAnswer((_) async => const Success(AppLockStatus.authenticated));
  });

  tearDown(() {
    cubit.close();
  });

  testWidgets(
    'Subsequent lock cycles after first entry use overlay without rebuilding probe',
    (tester) async {
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

      final firstInstance = ProbeScreenState.lastInstance;
      expect(firstInstance, isNotNull);

      // Lock cycle 1
      cubit.onAppPaused();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(LockScreen), findsOneWidget);
      await cubit.onAppResumed();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(LockScreen), findsNothing);

      // Lock cycle 2
      cubit.onAppPaused();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(LockScreen), findsOneWidget);
      await cubit.onAppResumed();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(LockScreen), findsNothing);

      // Probe was never disposed
      expect(ProbeScreenState.disposeCount, 0);
      expect(identical(ProbeScreenState.lastInstance, firstInstance), isTrue);
    },
  );
}
