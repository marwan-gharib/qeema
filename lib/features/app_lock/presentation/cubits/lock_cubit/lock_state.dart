import 'package:qeema/core/error/failures.dart';

sealed class AppLockState {
  const AppLockState();
}

final class AppLockInitial extends AppLockState {
  const AppLockInitial();
}

final class AppLockAuthenticating extends AppLockState {
  const AppLockAuthenticating();
}

final class AppLockError extends AppLockState {
  const AppLockError(this.failure);
  final Failure failure;
}

final class AppLockUnlocked extends AppLockState {
  const AppLockUnlocked();
}
