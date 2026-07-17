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
