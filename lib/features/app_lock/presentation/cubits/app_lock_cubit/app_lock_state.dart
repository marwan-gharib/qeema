import 'package:qeema/core/error/failures.dart';

sealed class AppLockState {
  const AppLockState();
}

final class AppLockInitial extends AppLockState {
  const AppLockInitial();
}

final class AppLockChecking extends AppLockState {
  const AppLockChecking();
}

enum AppLockLockedReason {
  /// The OS prompt is (or is about to be) shown.
  prompt,

  /// The user cancelled or failed the prompt.
  cancelled,

  /// The OS locked out further attempts temporarily.
  lockedOut,
}

final class AppLockLocked extends AppLockState {
  const AppLockLocked(this.reason);
  final AppLockLockedReason reason;
}

final class AppLockUnlocked extends AppLockState {
  const AppLockUnlocked();
}

final class AppLockDisabled extends AppLockState {
  const AppLockDisabled();
}

final class AppLockError extends AppLockState {
  const AppLockError(this.failure);
  final Failure failure;
}
