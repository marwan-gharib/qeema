import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/usecase_without_params.dart';
import 'package:qeema/features/app_lock/domain/repositories/app_lock_repository.dart';

class CheckDeviceLockAvailableUseCase implements UseCaseWithoutParams<bool> {
  const CheckDeviceLockAvailableUseCase(this._repository);
  final AppLockRepository _repository;

  @override
  Future<ApiResult<bool>> call() => _repository.isDeviceLockAvailable();
}
