import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:qeema/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._completeOnboarding)
    : super(const OnboardingInProgress(0));
  final CompleteOnboardingUseCase _completeOnboarding;
  static const totalPages = 4;

  void onPageChanged(int index) => emit(OnboardingInProgress(index));

  void skip() => _finish();

  void next() {
    final current = state;
    if (current is! OnboardingInProgress) return;
    if (current.currentPage >= totalPages - 1) {
      _finish();
      return;
    }
    emit(OnboardingInProgress(current.currentPage + 1));
  }

  Future<void> _finish() async {
    await _completeOnboarding();
    emit(const OnboardingCompleted());
  }
}
