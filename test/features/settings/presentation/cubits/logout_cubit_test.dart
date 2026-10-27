import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/settings/domain/usecases/logout_usecase.dart';
import 'package:qeema/features/settings/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/logout_cubit/logout_state.dart';

import '../../../../helpers/settings_mocks.dart';

class _PendingLogoutUseCase implements LogoutUseCase {
  _PendingLogoutUseCase(this.completer);
  final Completer<ApiResult<void>> completer;
  int calls = 0;

  @override
  Future<ApiResult<void>> call() async {
    calls++;
    return completer.future;
  }
}

void main() {
  late MockLogoutUseCase useCase;
  late MockIsCurrentUserAnonymousUseCase anonymousUseCase;
  late LogoutCubit cubit;

  setUp(() {
    useCase = MockLogoutUseCase();
    anonymousUseCase = MockIsCurrentUserAnonymousUseCase();
    cubit = LogoutCubit(useCase, anonymousUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('LogoutCubit', () {
    test('initial state is LogoutInitial', () {
      expect(cubit.state, isA<LogoutInitial>());
    });

    test('isCurrentUserAnonymous delegates to the usecase', () {
      anonymousUseCase = MockIsCurrentUserAnonymousUseCase(isAnonymous: true);
      cubit = LogoutCubit(useCase, anonymousUseCase);
      expect(cubit.isCurrentUserAnonymous(), isTrue);
      anonymousUseCase = MockIsCurrentUserAnonymousUseCase(isAnonymous: false);
      cubit = LogoutCubit(useCase, anonymousUseCase);
      expect(cubit.isCurrentUserAnonymous(), isFalse);
    });

    test('emits Loading then Success on successful logout', () async {
      final future = expectLater(
        cubit.stream,
        emitsInOrder([isA<LogoutLoading>(), isA<LogoutSuccess>()]),
      );
      unawaited(cubit.logout());
      await future;
      expect(useCase.calls, 1);
    });

    test('emits Loading then Failure when the use case fails', () async {
      useCase.result = const ResultFailure(UnknownFailure());

      final future = expectLater(
        cubit.stream,
        emitsInOrder([isA<LogoutLoading>(), isA<LogoutFailure>()]),
      );
      unawaited(cubit.logout());
      await future;
    });

    test('ignores logout while already loading', () async {
      final completer = Completer<ApiResult<void>>();
      final pending = _PendingLogoutUseCase(completer);
      cubit = LogoutCubit(pending, anonymousUseCase);

      unawaited(cubit.logout());
      await Future<void>.delayed(Duration.zero);
      expect(pending.calls, 1);

      // A second call while loading should be ignored
      unawaited(cubit.logout());
      await Future<void>.delayed(Duration.zero);
      expect(pending.calls, 1);

      completer.complete(const Success(null));
      await Future<void>.delayed(Duration.zero);
    });
  });
}
