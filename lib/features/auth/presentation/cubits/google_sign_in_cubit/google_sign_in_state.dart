import 'package:qeema/core/error/failures.dart';

sealed class GoogleSignInState {
  const GoogleSignInState();
}

final class GoogleSignInInitialState extends GoogleSignInState {
  const GoogleSignInInitialState();
}

final class GoogleSignInLoadingState extends GoogleSignInState {
  const GoogleSignInLoadingState();
}

final class GoogleSignInSuccessState extends GoogleSignInState {
  const GoogleSignInSuccessState();
}

final class GoogleSignInFailureState extends GoogleSignInState {
  const GoogleSignInFailureState(this.failure);
  final Failure failure;
}
  