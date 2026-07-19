import 'package:qeema/core/error/failures.dart';

sealed class WelcomeState {
  const WelcomeState();
}

final class WelcomeInitial extends WelcomeState {
  const WelcomeInitial();
}

final class WelcomeGuestLoading extends WelcomeState {
  const WelcomeGuestLoading();
}

final class WelcomeGuestSuccess extends WelcomeState {
  const WelcomeGuestSuccess();
}

final class WelcomeGuestFailure extends WelcomeState {
  const WelcomeGuestFailure(this.failure);
  final Failure failure;
}
