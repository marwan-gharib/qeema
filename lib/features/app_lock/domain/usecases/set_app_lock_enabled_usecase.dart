import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/repositories/app_lock_repository.dart';

class SetAppLockEnabledUseCase {
  const SetAppLockEnabledUseCase(this._repository);
  final AppLockRepository _repository;

  Future<ApiResult<void>> call(bool input) => _repository.setEnabled(input);
}
