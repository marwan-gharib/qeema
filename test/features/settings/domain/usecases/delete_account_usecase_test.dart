import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/settings/domain/repositories/account_repository.dart';
import 'package:qeema/features/settings/domain/usecases/delete_account_usecase.dart';

class _MockAccountRepository implements AccountRepository {
  ApiResult<void> result = const Success(null);

  @override
  Future<ApiResult<void>> deleteAccount() async => result;
}

void main() {
  test('returns the repository result on success', () async {
    final repository = _MockAccountRepository();
    final usecase = DeleteAccountUseCase(repository);

    final result = await usecase();

    expect(result, isA<Success<void>>());
  });

  test('propagates a repository failure', () async {
    final repository = _MockAccountRepository()
      ..result = const ResultFailure(AccountDeletionFailure());
    final usecase = DeleteAccountUseCase(repository);

    final result = await usecase();

    expect(result, isA<ResultFailure<void>>());
    expect(
      (result as ResultFailure<void>).failure,
      isA<AccountDeletionFailure>(),
    );
  });
}
