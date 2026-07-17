sealed class OnboardingState {
  const OnboardingState();
}

final class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

final class OnboardingInProgress extends OnboardingState {
  const OnboardingInProgress(this.currentPage);
  final int currentPage;
}

final class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted();
}
