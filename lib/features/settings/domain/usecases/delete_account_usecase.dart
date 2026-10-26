import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/settings/domain/repositories/account_repository.dart';

class DeleteAccountUseCase {
  const DeleteAccountUseCase(this._repository);
  final AccountRepository _repository;

  Future<ApiResult<void>> call() => _repository.deleteAccount();
}
