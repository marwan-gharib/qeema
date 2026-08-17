import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/settings/presentation/cubits/delete_account_cubit/delete_account_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/delete_account_cubit/delete_account_state.dart';

import '../../../../helpers/settings_mocks.dart';

void main() {
  late MockDeleteAccountUseCase useCase;
  late DeleteAccountCubit cubit;

  setUp(() {
    useCase = MockDeleteAccountUseCase();
    cubit = DeleteAccountCubit(useCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('DeleteAccountCubit', () {
    test('initial state is DeleteAccountInitial', () {
      expect(cubit.state, isA<DeleteAccountInitial>());
    });

    test('emits Deleting then Success on a successful deletion', () async {
      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<DeleteAccountDeleting>(),
          isA<DeleteAccountSuccess>(),
        ]),
      );
      unawaited(cubit.deleteAccount());
      await future;
    });

    test('emits Deleting then Failure when the use case fails', () async {
      useCase.result = const ResultFailure(AccountDeletionFailure());

      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<DeleteAccountDeleting>(),
          isA<DeleteAccountFailure>(),
        ]),
      );
      unawaited(cubit.deleteAccount());
      await future;
    });
  });
}