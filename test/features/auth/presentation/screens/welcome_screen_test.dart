import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/core/router/route_paths.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:qeema/features/auth/presentation/cubits/google_sign_in_cubit/google_sign_in_cubit.dart';
import 'package:qeema/features/auth/presentation/cubits/welcome_cubit/welcome_cubit.dart';
import 'package:qeema/features/auth/presentation/cubits/welcome_cubit/welcome_state.dart';
import 'package:qeema/features/auth/presentation/screens/welcome_screen.dart';

import '../../../../helpers/mocks.dart';

Widget _buildTestApp(WelcomeCubit cubit, GoogleSignInCubit googleCubit) {
  LocaleSettings.setLocaleSync(AppLocale.en);
  final router = GoRouter(
    initialLocation: RoutePaths.welcome,
    routes: [
      GoRoute(
        path: RoutePaths.welcome,
        name: RouteNames.welcome,
        builder: (_, _) => MultiBlocProvider(
          providers: [
            BlocProvider<WelcomeCubit>.value(value: cubit),
            BlocProvider<GoogleSignInCubit>.value(value: googleCubit),
          ],
          child: const WelcomeScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (_, _) => const Scaffold(),
      ),
    ],
  );
  return TranslationProvider(
    child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
  );
}

Future<void> pumpWithAnimation(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump(const Duration(milliseconds: 2000));
}

void main() {
  late MockContinueAsGuestUseCase mockUseCase;
  late WelcomeCubit cubit;
  late GoogleSignInCubit googleCubit;

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    mockUseCase = MockContinueAsGuestUseCase();
    cubit = WelcomeCubit(mockUseCase);
    googleCubit = GoogleSignInCubit(GoogleSignInUseCase(MockAuthRepository()));
  });

  tearDown(() {
    cubit.close();
    googleCubit.close();
  });

  group('WelcomeScreen', () {
    testWidgets('renders primary CTA button and disclosure text', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(cubit, googleCubit));
      await pumpWithAnimation(tester);

      expect(find.text('Know what your money is really worth'), findsOneWidget);
      expect(
        find.text(
          'Track your savings against inflation and see your real '
          'purchasing power over time.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('tapping primary CTA calls cubit', (tester) async {
      await tester.pumpWidget(_buildTestApp(cubit, googleCubit));
      await pumpWithAnimation(tester);

      expect(cubit.state, isA<WelcomeInitial>());

      await tester.tap(find.text('Continue as Guest'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(cubit.state, isNot(isA<WelcomeInitial>()));
    });

    testWidgets('shows loading on primary CTA while signing in', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(cubit, googleCubit));
      await pumpWithAnimation(tester);

      unawaited(cubit.continueAsGuest());

      expect(cubit.state, isA<WelcomeGuestLoading>());
    });

    testWidgets('shows snackbar on AnonymousSignInDisabledFailure', (
      tester,
    ) async {
      mockUseCase.result = const ResultFailure(
        AnonymousSignInDisabledFailure(),
      );

      await tester.pumpWidget(_buildTestApp(cubit, googleCubit));
      await pumpWithAnimation(tester);

      await tester.tap(find.text('Continue as Guest'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      expect(
        find.text(
          'Guest sign-in is currently unavailable. Please try again later.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders with disableAnimations: true without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: _buildTestApp(cubit, googleCubit),
        ),
      );
      await tester.pump();

      expect(find.text('Know what your money is really worth'), findsOneWidget);
    });

    testWidgets('renders with dark theme without error', (tester) async {
      LocaleSettings.setLocaleSync(AppLocale.en);
      final router = GoRouter(
        initialLocation: RoutePaths.welcome,
        routes: [
          GoRoute(
            path: RoutePaths.welcome,
            name: RouteNames.welcome,
            builder: (_, _) => MultiBlocProvider(
              providers: [
                BlocProvider<WelcomeCubit>.value(value: cubit),
                BlocProvider<GoogleSignInCubit>.value(value: googleCubit),
              ],
              child: const WelcomeScreen(),
            ),
          ),
          GoRoute(
            path: RoutePaths.home,
            name: RouteNames.home,
            builder: (_, _) => const Scaffold(),
          ),
        ],
      );
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp.router(
            theme: AppTheme.dark(),
            routerConfig: router,
          ),
        ),
      );
      await pumpWithAnimation(tester);

      expect(find.text('Know what your money is really worth'), findsOneWidget);
    });
  });
}
