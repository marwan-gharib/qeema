import 'package:qeema/core/constants/app_constants.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/local/cache/cache_service.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/onboarding/domain/repositories/onboarding_repository.dart';

final class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._cacheService);
  final CacheService _cacheService;

  @override
  Future<ApiResult<bool>> hasSeenOnboarding() async {
    try {
      final value = await _cacheService.get(
        key: AppConstants.onboardingCompletedKey,
      );
      return Success(value is bool && value);
    } catch (e) {
      return const ResultFailure(CacheFailure());
    }
  }

  @override
  Future<ApiResult<void>> markOnboardingSeen() async {
    try {
      await _cacheService.set(
        key: AppConstants.onboardingCompletedKey,
        value: true,
      );
      return const Success(null);
    } catch (e) {
      return const ResultFailure(CacheFailure());
    }
  }
}
