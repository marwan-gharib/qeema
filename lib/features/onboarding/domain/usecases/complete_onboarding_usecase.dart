import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/usecase_without_params.dart';
import 'package:qeema/features/onboarding/domain/repositories/onboarding_repository.dart';

class CompleteOnboardingUseCase implements UseCaseWithoutParams<void> {
  const CompleteOnboardingUseCase(this._repository);
  final OnboardingRepository _repository;

  @override
  Future<ApiResult<void>> call() => _repository.markOnboardingSeen();
}
