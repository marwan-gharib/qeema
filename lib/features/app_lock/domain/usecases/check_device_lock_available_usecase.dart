import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/repositories/app_lock_repository.dart';

class CheckDeviceLockAvailableUseCase {
  const CheckDeviceLockAvailableUseCase(this._repository);
  final AppLockRepository _repository;

  Future<ApiResult<bool>> call() => _repository.isDeviceLockAvailable();
}
