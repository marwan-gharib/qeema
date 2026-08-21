import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';

extension FailureLocalization on Failure {
  String localizedMessage(BuildContext context) {
    final t = context.t;
    return switch (this) {
      NetworkFailure() => t.core.failure.networkFailure,
      CacheFailure() => t.core.failure.cacheFailure,
      ServerFailure() => t.core.error.serverError,
      AssetNotFoundFailure() => t.assets.failure.assetNotFound,
      InvalidAssetAmountFailure() => t.assets.failure.invalidAmount,
      PriceFetchFailure(:final assetTypeCode) =>
        t.core.failure.priceFetchFailure.replaceAll(
          '{assetTypeCode}',
          context.assetTypeName(assetTypeCode),
        ),
      InflationDataMissingFailure(:final missingMonths) =>
        t.core.failure.inflationDataMissing.replaceAll(
          '{count}',
          '${missingMonths.length}',
        ),
      CalculationFailure(:final reason) =>
        t.core.failure.calculationFailed.replaceAll('{reason}', reason),
      NetworkAuthFailure() => t.auth.error.networkError,
      TooManyRequestsFailure() => t.auth.error.tooManyRequests,
      AnonymousSignInDisabledFailure() => t.auth.error.anonymousSignInDisabled,
      AccountDeletionPartialFailure() => t.settings.deletePartialFailure,
      AccountDeletionFailure() => t.settings.deleteFailed,
      LocalAuthCancelledFailure() => t.settings.authCancelled,
      LocalAuthLockoutFailure() => t.appLock.tooManyAttempts,
      LocalAuthNoCredentialsFailure() => t.appLock.noCredentials,
      LocalAuthUnavailableFailure() => t.appLock.unavailable,
      _ => t.core.failure.unknownFailure,
    };
  }
}
