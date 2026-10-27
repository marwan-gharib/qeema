import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/onboarding/domain/repositories/onboarding_repository.dart';

class CompleteOnboardingUseCase {
  const CompleteOnboardingUseCase(this._repository);
  final OnboardingRepository _repository;

  Future<ApiResult<void>> call() => _repository.markOnboardingSeen();
}
