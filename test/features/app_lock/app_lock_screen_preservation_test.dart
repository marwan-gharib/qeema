import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart' hide GlobalMaterialLocalizations;
import 'package:mocktail/mocktail.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/domain/usecases/authenticate_device_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/check_device_lock_available_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/get_app_lock_enabled_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/set_recents_preview_hidden_usecase.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/screens/lock_screen.dart';
import 'package:qeema/features/app_lock/presentation/widgets/app_lock_lifecycle_observer.dart';
import 'package:qeema/features/app_lock/presentation/widgets/app_lock_overlay.dart';

class FakeGetAppLockEnabledUseCase extends Mock
    implements GetAppLockEnabledUseCase {}

class FakeCheckDeviceLockAvailableUseCase extends Mock
    implements CheckDeviceLockAvailableUseCase {}

class FakeAuthenticateDeviceUseCase extends Mock
    implements AuthenticateDeviceUseCase {}

class FakeSetRecentsPreviewHiddenUseCase extends Mock
    implements SetRecentsPreviewHiddenUseCase {}

class ProbeCubit extends Cubit<int> {
  ProbeCubit() : super(0) {
    createCount++;
  }
  static int createCount = 0;
  static int closeCount = 0;
  static int loadDataCalls = 0;

  static void resetCounts() {
    createCount = 0;
    closeCount = 0;
    loadDataCalls = 0;
  }

  void loadData() {
    loadDataCalls++;
    emit(state + 1);
  }

  @override
  Future<void> close() {
    closeCount++;
    return super.close();
  }
}

class ProbeScreen extends StatefulWidget {
  const ProbeScreen({super.key});

  @override
  State<ProbeScreen> createState() => ProbeScreenState();
}

class ProbeScreenState extends State<ProbeScreen> {
  static int initCount = 0;
  static int disposeCount = 0;
  static ProbeScreenState? lastInstance;
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  int tapCount = 0;

  static void resetCounts() {
    initCount = 0;
    disposeCount = 0;
    lastInstance = null;
  }

  @override
  void initState() {
    super.initState();
    initCount++;
    lastInstance = this;
  }

  @override
  void dispose() {
    disposeCount++;
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Probe State: ${context.watch<ProbeCubit>().state}'),
            TextField(
              key: const ValueKey('probe_text_field'),
              controller: textController,
              focusNode: focusNode,
            ),
            ElevatedButton(
              key: const ValueKey('probe_button'),
              onPressed: () {
                setState(() {
                  tapCount++;
                });
              },
              child: Text('Tapped: $tapCount'),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashProbe extends StatefulWidget {
  const SplashProbe({super.key});

  static int buildCount = 0;

  @override
  State<SplashProbe> createState() => _SplashProbeState();
}

class _SplashProbeState extends State<SplashProbe> {
  @override
  Widget build(BuildContext context) {
    SplashProbe.buildCount++;
    return const Scaffold(body: Text('Splash Probe'));
  }
}

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

  Widget buildAppWithOverlay({
    required AppLockCubit appLockCubit,
    required GoRouter router,
  }) {
    return BlocProvider<AppLockCubit>.value(
      value: appLockCubit,
      child: TranslationProvider(
        child: AppLockLifecycleObserver(
          child: MaterialApp.router(
            routerConfig: router,
            theme: AppTheme.light(),
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            builder: (context, child) => child == null
                ? const SizedBox.shrink()
                : AppLockOverlay(child: child),
          ),
        ),
      ),
    );
  }

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

  testWidgets(
    'While locked: overlay is present, taps do not reach probe, focus is cleared, semantics excluded, back does not pop',
    (tester) async {
      when(
        () => authenticate.call(any()),
      ).thenAnswer((_) async => const Success(AppLockStatus.authenticated));

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

  testWidgets(
    'Subsequent lock cycles after first entry use overlay without rebuilding probe',
    (tester) async {
      when(
        () => authenticate.call(any()),
      ).thenAnswer((_) async => const Success(AppLockStatus.authenticated));

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

  testWidgets('Late resumed after success does not re-lock', (tester) async {
    when(
      () => authenticate.call(any()),
    ).thenAnswer((_) async => const Success(AppLockStatus.authenticated));

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
