/// Which asset operation a failure came from. Presentation maps this to a
/// localized message; it is never rendered as text.
enum AssetOperation { read, add, update, delete, loadHistory }

/// Failures cross layer boundaries carrying only a machine-readable [code]
/// and a log-only [debugDetail]. Neither field is ever rendered — presentation
/// translates the concrete subtype through a single mapper.
sealed class Failure {
  const Failure([this.debugDetail, this.code]);

  final String? debugDetail;
  final String? code;
}

final class CacheFailure extends Failure {
  const CacheFailure([super.debugDetail, super.code]);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.debugDetail, super.code]);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.debugDetail, super.code]);
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure([super.debugDetail, super.code]);
}

final class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.debugDetail, super.code]);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.debugDetail, super.code]);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.debugDetail, super.code]);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.debugDetail, super.code]);
}

final class PriceRequiredFailure extends ValidationFailure {
  const PriceRequiredFailure([super.debugDetail, super.code]);
}

class AuthFailure extends Failure {
  const AuthFailure([super.debugDetail, super.code]);
}

final class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure([super.debugDetail, super.code]);
}

final class NetworkAuthFailure extends AuthFailure {
  const NetworkAuthFailure([super.debugDetail, super.code]);
}

final class TooManyRequestsFailure extends AuthFailure {
  const TooManyRequestsFailure([super.debugDetail, super.code]);
}

final class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure([super.debugDetail, super.code]);
}

final class AnonymousSignInDisabledFailure extends AuthFailure {
  const AnonymousSignInDisabledFailure([super.debugDetail, super.code]);
}

final class SignOutFailure extends Failure {
  const SignOutFailure([super.debugDetail, super.code]);
}

final class AccountDeletionFailure extends Failure {
  const AccountDeletionFailure([super.debugDetail, super.code]);
}

final class AccountDeletionPartialFailure extends AccountDeletionFailure {
  const AccountDeletionPartialFailure([super.debugDetail, super.code]);
}

final class LocalAuthCancelledFailure extends Failure {
  const LocalAuthCancelledFailure([super.debugDetail, super.code]);
}

final class LocalAuthLockoutFailure extends Failure {
  const LocalAuthLockoutFailure([super.debugDetail, super.code]);
}

final class LocalAuthNoCredentialsFailure extends Failure {
  const LocalAuthNoCredentialsFailure([super.debugDetail, super.code]);
}

final class LocalAuthUnavailableFailure extends Failure {
  const LocalAuthUnavailableFailure([super.debugDetail, super.code]);
}

final class LocalAuthUnknownFailure extends Failure {
  const LocalAuthUnknownFailure([super.debugDetail, super.code]);
}

final class AssetNotFoundFailure extends Failure {
  const AssetNotFoundFailure() : super(null, 'asset_not_found');
}

final class InvalidAssetAmountFailure extends Failure {
  const InvalidAssetAmountFailure() : super(null, 'invalid_asset_amount');
}

final class AssetOperationFailure extends Failure {
  const AssetOperationFailure(this.operation, [super.debugDetail, super.code]);
  final AssetOperation operation;
}

sealed class FinancialFailure extends Failure {
  const FinancialFailure([super.debugDetail, super.code]);
}

final class CalculationFailure extends FinancialFailure {
  const CalculationFailure([super.debugDetail, super.code]);
}

final class InflationDataMissingFailure extends FinancialFailure {
  const InflationDataMissingFailure(
    this.missingMonths, [
    super.debugDetail,
    super.code,
  ]);
  final List<DateTime> missingMonths;
}

final class PriceFetchFailure extends FinancialFailure {
  const PriceFetchFailure(this.assetTypeCode, [super.debugDetail, super.code]);
  final String assetTypeCode;
}
