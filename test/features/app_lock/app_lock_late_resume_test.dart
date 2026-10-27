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

/// A resumed event arriving while already unlocked must not re-lock or prompt.
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

  testWidgets('Late resumed after success does not re-lock', (tester) async {
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

    expect(find.byType(ProbeScreen), findsOneWidget);

    // An unprompted / late resumed does not lock or prompt
    await cubit.onAppResumed();
    await tester.pumpAndSettle();

    expect(find.byType(LockScreen), findsNothing);
    expect(find.byType(ProbeScreen), findsOneWidget);
  });
}
