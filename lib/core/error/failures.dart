class Failure {
  final String message;
  const Failure(this.message);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong on our end.']);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not read local data.']);
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.']);
}

final class FinancialFailure extends Failure {
  const FinancialFailure(super.message);
}

final class PriceFetchFailure extends FinancialFailure {
  final String assetTypeCode;
  PriceFetchFailure(this.assetTypeCode)
    : super('Could not fetch price for $assetTypeCode');
}

final class InflationDataMissingFailure extends FinancialFailure {
  final List<DateTime> missingMonths;
  InflationDataMissingFailure(this.missingMonths)
    : super('Inflation data missing for ${missingMonths.length} month(s)');
}

final class CalculationFailure extends FinancialFailure {
  final String reason;
  CalculationFailure(this.reason) : super('Calculation failed: $reason');
}
