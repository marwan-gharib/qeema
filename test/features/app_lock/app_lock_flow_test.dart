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
import 'package:qeema/core/widgets/app_loader.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/domain/usecases/authenticate_device_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/check_device_lock_available_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/get_app_lock_enabled_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/set_recents_preview_hidden_usecase.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/screens/lock_screen.dart';
import 'package:qeema/features/app_lock/presentation/widgets/app_lock_lifecycle_observer.dart';

// Fakes
class FakeGetAppLockEnabledUseCase extends Mock
    implements GetAppLockEnabledUseCase {}

class FakeCheckDeviceLockAvailableUseCase extends Mock
    implements CheckDeviceLockAvailableUseCase {}

class FakeAuthenticateDeviceUseCase extends Mock
    implements AuthenticateDeviceUseCase {}

class FakeSetRecentsPreviewHiddenUseCase extends Mock
    implements SetRecentsPreviewHiddenUseCase {}

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

  Widget buildTestApp({required AppLockCubit cubit, required GoRouter router}) {
    return BlocProvider<AppLockCubit>.value(
      value: cubit,
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
          ),
        ),
      ),
    );
  }

  testWidgets(
    'Cold start -> lock screen -> authenticate success -> leaves /lock',
    (tester) async {
      // We use Completer to control the authenticate future
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
        initialLocation: '/home',
        refreshListenable: cubit.listenable,
        redirect: (context, state) {
          if (state.matchedLocation == '/lock') {
            if (cubit.isLocked) return null;
            return '/home';
          }
          if (cubit.isLocked) return '/lock';
          return null;
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) =>
                const Scaffold(body: Text('Home Screen')),
          ),
          GoRoute(
            path: '/lock',
            builder: (context, state) => const LockScreen(),
          ),
        ],
      );

      await tester.pumpWidget(buildTestApp(cubit: cubit, router: router));
      await tester.pump();

      // Should be on lock screen with a loader since prompt is in flight
      expect(find.byType(LockScreen), findsOneWidget);
      expect(find.byType(AppLoader), findsOneWidget);

      // Complete authentication successfully
      authCompleter.complete(const Success(AppLockStatus.authenticated));
      await tester.pumpAndSettle();

      // Router should have redirected to home, LockScreen should be gone
      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.byType(LockScreen), findsNothing);
    },
  );
}
