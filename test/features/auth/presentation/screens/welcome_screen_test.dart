import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/core/router/route_paths.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/auth/presentation/cubits/welcome_cubit/welcome_cubit.dart';
import 'package:qeema/features/auth/presentation/cubits/welcome_cubit/welcome_state.dart';
import 'package:qeema/features/auth/presentation/screens/welcome_screen.dart';
import '../../../../helpers/mocks.dart';

Widget _buildTestApp(WelcomeCubit cubit) {
  LocaleSettings.setLocaleSync(AppLocale.en);
  final router = GoRouter(
    initialLocation: RoutePaths.welcome,
    routes: [
      GoRoute(
        path: RoutePaths.welcome,
        name: RouteNames.welcome,
        builder: (_, _) =>
            BlocProvider.value(value: cubit, child: const WelcomeScreen()),
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

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    mockUseCase = MockContinueAsGuestUseCase();
    cubit = WelcomeCubit(mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('WelcomeScreen', () {
    testWidgets('renders primary CTA button and disclosure text', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(cubit));
      await pumpWithAnimation(tester);

      expect(find.text('Start Tracking Your Savings'), findsOneWidget);
      expect(
        find.text('No account needed. You can create one later.'),
        findsOneWidget,
      );
    });

    testWidgets('tapping primary CTA calls cubit', (tester) async {
      await tester.pumpWidget(_buildTestApp(cubit));
      await pumpWithAnimation(tester);

      expect(cubit.state, isA<WelcomeInitial>());

      await tester.tap(find.text('Start Tracking Your Savings'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(cubit.state, isNot(isA<WelcomeInitial>()));
    });

    testWidgets('shows loading on primary CTA while signing in', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(cubit));
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

      await tester.pumpWidget(_buildTestApp(cubit));
      await pumpWithAnimation(tester);

      await tester.tap(find.text('Start Tracking Your Savings'));
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
          child: _buildTestApp(cubit),
        ),
      );
      await tester.pump();

      expect(find.text('Start Tracking Your Savings'), findsOneWidget);
    });

    testWidgets('renders with dark theme without error', (tester) async {
      LocaleSettings.setLocaleSync(AppLocale.en);
      final router = GoRouter(
        initialLocation: RoutePaths.welcome,
        routes: [
          GoRoute(
            path: RoutePaths.welcome,
            name: RouteNames.welcome,
            builder: (_, _) =>
                BlocProvider.value(value: cubit, child: const WelcomeScreen()),
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

      expect(find.text('Start Tracking Your Savings'), findsOneWidget);
    });
  });
}
