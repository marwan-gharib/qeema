import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';

abstract class AppLockRepository {
  Future<ApiResult<bool>> isEnabled();

  Future<ApiResult<void>> setEnabled(bool enabled);

  Future<ApiResult<bool>> isDeviceLockAvailable();

  Future<ApiResult<AppLockStatus>> authenticate(String reason);

  Future<ApiResult<void>> setRecentsPreviewHidden(bool hidden);
}
