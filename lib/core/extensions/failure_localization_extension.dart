import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';

/// The single place a [Failure] becomes user-facing text. Subtypes are matched
/// most-specific first and the switch is exhaustive, so a new failure type is a
/// compile error here rather than a silently untranslated message.
extension FailureLocalization on Failure {
  String localizedMessage(BuildContext context) {
    final t = context.t;
    return switch (this) {
      SessionExpiredFailure() => t.core.failure.sessionExpired,
      NetworkAuthFailure() => t.auth.error.networkError,
      TooManyRequestsFailure() => t.auth.error.tooManyRequests,
      UnknownAuthFailure() => t.auth.error.unknownError,
      AnonymousSignInDisabledFailure() => t.auth.error.anonymousSignInDisabled,
      AuthFailure() => t.auth.error.unknownError,
      AccountDeletionPartialFailure() => t.settings.deletePartialFailure,
      AccountDeletionFailure() => t.settings.deleteFailed,
      SignOutFailure() => t.settings.logoutFailed,
      NetworkFailure() => t.core.failure.networkFailure,
      TimeoutFailure() => t.core.failure.timeout,
      ForbiddenFailure() => t.core.failure.forbidden,
      NotFoundFailure() => t.core.failure.notFound,
      ServerFailure() => t.core.error.serverError,
      CacheFailure() => t.core.failure.cacheFailure,
      PriceRequiredFailure() => t.assets.failure.priceRequiredMarket,
      ValidationFailure() => t.core.failure.validation,
      LocalAuthCancelledFailure() => t.app_lock.cancelledMessage,
      LocalAuthLockoutFailure() => t.app_lock.lockedOutMessage,
      LocalAuthNoCredentialsFailure() => t.app_lock.noCredentialsMessage,
      LocalAuthUnavailableFailure() => t.app_lock.unavailableMessage,
      LocalAuthUnknownFailure() => t.app_lock.errorMessage,
      AssetNotFoundFailure() => t.assets.failure.assetNotFound,
      InvalidAssetAmountFailure() => t.assets.failure.invalidAmount,
      AssetOperationFailure(:final operation) => switch (operation) {
        AssetOperation.read => t.assets.failure.fetchFailed,
        AssetOperation.add => t.assets.failure.addFailed,
        AssetOperation.update => t.assets.failure.updateFailed,
        AssetOperation.delete => t.assets.failure.deleteFailed,
        AssetOperation.loadHistory => t.assets.failure.historyLoadFailed,
      },
      PriceFetchFailure(:final assetTypeCode) =>
        t.core.failure.priceFetchFailure(
          assetTypeCode: context.assetTypeName(assetTypeCode),
        ),
      InflationDataMissingFailure(:final missingMonths) =>
        t.core.failure.inflationDataMissing(n: missingMonths.length),
      CalculationFailure() => t.core.failure.calculationFailed,
      UnknownFailure() => t.core.failure.unknownFailure,
    };
  }
}
