import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_cubit.dart';
import 'package:qeema/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_state.dart';
import 'package:qeema/features/onboarding/presentation/widgets/onboarding_page_view.dart';
import '../../../../helpers/mocks.dart';

Widget _buildPageView({required OnboardingCubit cubit}) {
  LocaleSettings.setLocaleSync(AppLocale.en);
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: SizedBox.expand(
          child: BlocProvider<OnboardingCubit>.value(
            value: cubit,
            child: const OnboardingPageView(),
          ),
        ),
      ),
    ),
  );
}

Future<void> drainTimers(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump(const Duration(milliseconds: 2000));
}

void main() {
  late MockCompleteOnboardingUseCase mockUseCase;
  late OnboardingCubit cubit;

  setUp(() {
    mockUseCase = MockCompleteOnboardingUseCase();
    cubit = OnboardingCubit(mockUseCase);
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  tearDown(() {
    cubit.close();
  });

  group('OnboardingPageView widget', () {
    testWidgets('renders Skip and Next on slide 1', (tester) async {
      await tester.pumpWidget(_buildPageView(cubit: cubit));
      await drainTimers(tester);

      expect(find.text('Skip'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('renders Get Started on last slide', (tester) async {
      cubit.onPageChanged(3);
      await tester.pumpWidget(_buildPageView(cubit: cubit));
      await drainTimers(tester);

      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('tapping Next advances page', (tester) async {
      await tester.pumpWidget(_buildPageView(cubit: cubit));
      await drainTimers(tester);

      await tester.tap(find.text('Next'));
      await tester.pump();
      await drainTimers(tester);

      expect(cubit.state, isA<OnboardingInProgress>());
    });

    testWidgets('tapping Skip completes onboarding', (tester) async {
      mockUseCase.result = const Success(null);
      await tester.pumpWidget(_buildPageView(cubit: cubit));
      await drainTimers(tester);

      await tester.tap(find.text('Skip'));
      await tester.pump();
      await drainTimers(tester);

      expect(cubit.state, isA<OnboardingCompleted>());
    });
  });
}
