import 'package:qeema/core/utils/api_result.dart';

abstract class OnboardingRepository {
  Future<ApiResult<bool>> hasSeenOnboarding();
  Future<ApiResult<void>> markOnboardingSeen();
}
