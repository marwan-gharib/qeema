class Failure {
  const Failure(this.message);
  final String? message;
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message]);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message]);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message]);
}

final class ValidationFailure extends Failure {
  const ValidationFailure([super.message]);
}

class FinancialFailure extends Failure {
  const FinancialFailure([super.message]);
}

final class CalculationFailure extends FinancialFailure {
  const CalculationFailure(this.reason, [super.message]);
  final String reason;
}

final class InflationDataMissingFailure extends FinancialFailure {
  const InflationDataMissingFailure(this.missingMonths, [super.message]);
  final List<DateTime> missingMonths;
}

final class PriceFetchFailure extends FinancialFailure {
  const PriceFetchFailure(this.assetTypeCode, [super.message]);
  final String assetTypeCode;
}

final class NetworkAuthFailure extends AuthFailure {
  const NetworkAuthFailure([super.message]);
}

final class TooManyRequestsFailure extends AuthFailure {
  const TooManyRequestsFailure([super.message]);
}

final class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure([super.message]);
}

final class AnonymousSignInDisabledFailure extends AuthFailure {
  const AnonymousSignInDisabledFailure([super.message]);
}

final class LocalAuthCancelledFailure extends Failure {
  const LocalAuthCancelledFailure([super.message]);
}

final class LocalAuthLockoutFailure extends Failure {
  const LocalAuthLockoutFailure([super.message]);
}

final class LocalAuthNoCredentialsFailure extends Failure {
  const LocalAuthNoCredentialsFailure([super.message]);
}

final class LocalAuthUnavailableFailure extends Failure {
  const LocalAuthUnavailableFailure([super.message]);
}

final class LocalAuthUnknownFailure extends Failure {
  const LocalAuthUnknownFailure([super.message]);
}
