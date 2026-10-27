import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/settings/domain/repositories/account_repository.dart';

class LogoutUseCase {
  const LogoutUseCase(this._repository);
  final AccountRepository _repository;

  Future<ApiResult<void>> call() => _repository.logout();
}
