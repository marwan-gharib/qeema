import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/screens/lock_screen.dart';
import 'package:qeema/features/app_lock/presentation/widgets/app_lock_overlay.dart';

import 'app_lock_probe_harness.dart';

/// While locked: overlay present, taps do not reach the probe, focus is
/// cleared, child semantics are excluded, and the back button does not pop.
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
    'While locked: overlay is present, taps do not reach probe, focus is cleared, semantics excluded, back does not pop',
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

      // Focus text field
      final textField = find.byKey(const ValueKey('probe_text_field'));
      await tester.tap(textField);
      await tester.pumpAndSettle();
      expect(ProbeScreenState.lastInstance!.focusNode.hasFocus, isTrue);

      // Lock app (simulate background)
      cubit.onAppPaused();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // 1. Overlay is present
      expect(find.byType(LockScreen), findsOneWidget);

      // 2. Focus is cleared
      expect(ProbeScreenState.lastInstance!.focusNode.hasFocus, isFalse);

      // 3. Taps do not reach probe button
      final probeButton = find.byKey(
        const ValueKey('probe_button'),
        skipOffstage: false,
      );
      expect(probeButton, findsOneWidget);
      await tester.tap(probeButton, warnIfMissed: false);
      await tester.pump();
      expect(ProbeScreenState.lastInstance!.tapCount, 0);

      // 4. Semantics of child are excluded
      final excludeSemantics = tester.widget<ExcludeSemantics>(
        find
            .descendant(
              of: find.byType(AppLockOverlay),
              matching: find.byType(ExcludeSemantics),
            )
            .first,
      );
      expect(excludeSemantics.excluding, isTrue);

      // 5. Back button does not pop probe
      final handled = await tester.binding.handlePopRoute();
      expect(handled, isTrue);
      expect(ProbeScreenState.disposeCount, 0);
    },
  );
}
