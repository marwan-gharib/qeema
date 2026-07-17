import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/usecase_without_params.dart';
import 'package:qeema/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetOnboardingSeenUseCase implements UseCaseWithoutParams<bool> {
  const GetOnboardingSeenUseCase(this._repository);
  final OnboardingRepository _repository;

  @override
  Future<ApiResult<bool>> call() => _repository.hasSeenOnboarding();
}
