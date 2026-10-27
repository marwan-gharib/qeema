import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetOnboardingSeenUseCase {
  const GetOnboardingSeenUseCase(this._repository);
  final OnboardingRepository _repository;

  Future<ApiResult<bool>> call() => _repository.hasSeenOnboarding();
}
