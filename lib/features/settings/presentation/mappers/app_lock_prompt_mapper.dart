import 'package:qeema/core/extensions/api_result_extensions.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';

/// What the App Lock switch may do with an OS prompt result. Presentation-only,
/// so the settings layer never branches on the domain enum itself.
enum AppLockPromptOutcome {
  /// The OS confirmed the user.
  confirmed,

  /// The prompt was cancelled, failed, locked out, or could not run.
  declined,
}

class AppLockPromptMapper {
  const AppLockPromptMapper._();

  /// Only a confirmed OS authentication may change the App Lock setting.
  /// Cancelled, locked out, no credentials and an unavailable sensor all
  /// decline, so an unavailable sensor can never be read as consent.
  static AppLockPromptOutcome fromResult(ApiResult<AppLockStatus> result) =>
      result.dataOrNull == AppLockStatus.authenticated
      ? AppLockPromptOutcome.confirmed
      : AppLockPromptOutcome.declined;
}
