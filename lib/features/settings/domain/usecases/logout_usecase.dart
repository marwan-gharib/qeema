import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/usecase_without_params.dart';
import 'package:qeema/features/settings/domain/repositories/account_repository.dart';

class LogoutUseCase implements UseCaseWithoutParams<void> {
  const LogoutUseCase(this._repository);
  final AccountRepository _repository;

  @override
  Future<ApiResult<void>> call() => _repository.logout();
}
