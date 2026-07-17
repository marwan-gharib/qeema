import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_cubit.dart';
import 'package:qeema/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_state.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockCompleteOnboardingUseCase mockUseCase;
  late OnboardingCubit cubit;

  setUp(() {
    mockUseCase = MockCompleteOnboardingUseCase();
    cubit = OnboardingCubit(mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('OnboardingCubit', () {
    test('initial state is OnboardingInProgress(0)', () {
      expect(cubit.state, isA<OnboardingInProgress>());
      expect((cubit.state as OnboardingInProgress).currentPage, equals(0));
    });

    test('onPageChanged(2) emits OnboardingInProgress(2)', () async {
      final future = expectLater(
        cubit.stream,
        emits(
          isA<OnboardingInProgress>().having(
            (s) => s.currentPage,
            'currentPage',
            2,
          ),
        ),
      );
      cubit.onPageChanged(2);
      await future;
    });

    test('next from page 0 emits OnboardingInProgress(1)', () async {
      final future = expectLater(
        cubit.stream,
        emits(
          isA<OnboardingInProgress>().having(
            (s) => s.currentPage,
            'currentPage',
            1,
          ),
        ),
      );
      cubit.next();
      await future;
    });

    test(
      'next from last page calls usecase and emits OnboardingCompleted',
      () async {
        mockUseCase.result = const Success(null);

        cubit.onPageChanged(3);
        await Future(() {});

        final future = expectLater(
          cubit.stream,
          emits(isA<OnboardingCompleted>()),
        );
        cubit.next();
        await Future(() {});
        await future;
      },
    );

    test('skip calls usecase and emits OnboardingCompleted', () async {
      mockUseCase.result = const Success(null);

      final future = expectLater(
        cubit.stream,
        emits(isA<OnboardingCompleted>()),
      );
      cubit.skip();
      await Future(() {});
      await future;
    });

    test(
      'next on last page emits OnboardingCompleted even when usecase returns ResultFailure',
      () async {
        mockUseCase.result = const ResultFailure(CacheFailure());

        cubit.onPageChanged(3);
        await Future(() {});

        final future = expectLater(
          cubit.stream,
          emits(isA<OnboardingCompleted>()),
        );
        cubit.next();
        await Future(() {});
        await future;
      },
    );

    test('next does not throw when state is OnboardingCompleted', () async {
      mockUseCase.result = const Success(null);

      cubit.skip();
      await Future(() {});

      expect(cubit.state, isA<OnboardingCompleted>());
      expect(() => cubit.next(), returnsNormally);
    });

    test('next does not throw from OnboardingInProgress guard', () {
      expect(() => cubit.next(), returnsNormally);
    });
  });
}
