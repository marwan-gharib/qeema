import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/auth/presentation/cubits/welcome_cubit/welcome_cubit.dart';
import 'package:qeema/features/auth/presentation/cubits/welcome_cubit/welcome_state.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockContinueAsGuestUseCase mockUseCase;
  late WelcomeCubit cubit;

  setUp(() {
    mockUseCase = MockContinueAsGuestUseCase();
    cubit = WelcomeCubit(mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('WelcomeCubit', () {
    test('initial state is WelcomeInitial', () {
      expect(cubit.state, isA<WelcomeInitial>());
    });

    test(
      'emits GuestLoading then GuestSuccess on successful guest sign-in',
      () async {
        final future = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<WelcomeGuestLoading>(),
            isA<WelcomeGuestSuccess>(),
          ]),
        );
        unawaited(cubit.continueAsGuest());
        await future;
      },
    );

    test('emits GuestLoading then GuestFailure on error', () async {
      mockUseCase.result = const ResultFailure(
        AnonymousSignInDisabledFailure(),
      );

      final future = expectLater(
        cubit.stream,
        emitsInOrder([isA<WelcomeGuestLoading>(), isA<WelcomeGuestFailure>()]),
      );
      unawaited(cubit.continueAsGuest());
      await future;
    });

    test('emits GuestFailure with correct failure type', () async {
      mockUseCase.result = const ResultFailure(
        AnonymousSignInDisabledFailure(),
      );

      unawaited(cubit.continueAsGuest());
      await Future(() {});

      expect(cubit.state, isA<WelcomeGuestFailure>());
      expect(
        (cubit.state as WelcomeGuestFailure).failure,
        isA<AnonymousSignInDisabledFailure>(),
      );
    });
  });
}
