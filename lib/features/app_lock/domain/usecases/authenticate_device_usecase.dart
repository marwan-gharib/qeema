import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/domain/repositories/app_lock_repository.dart';

class AuthenticateDeviceUseCase {
  const AuthenticateDeviceUseCase(this._repository);
  final AppLockRepository _repository;

  Future<ApiResult<AppLockStatus>> call(String input) =>
      _repository.authenticate(input);
}
