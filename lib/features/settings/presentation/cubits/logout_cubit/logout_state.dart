import 'package:qeema/core/error/failures.dart';

sealed class LogoutState {
  const LogoutState();
}

final class LogoutInitial extends LogoutState {
  const LogoutInitial();
}

final class LogoutLoading extends LogoutState {
  const LogoutLoading();
}

final class LogoutSuccess extends LogoutState {
  const LogoutSuccess();
}

final class LogoutFailure extends LogoutState {
  const LogoutFailure(this.failure);
  final Failure failure;
}
