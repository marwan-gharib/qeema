import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/usecase.dart';
import 'package:qeema/features/app_lock/domain/repositories/app_lock_repository.dart';

class SetAppLockEnabledUseCase implements UseCase<void, bool> {
  const SetAppLockEnabledUseCase(this._repository);
  final AppLockRepository _repository;

  @override
  Future<ApiResult<void>> call(bool input) => _repository.setEnabled(input);
}
