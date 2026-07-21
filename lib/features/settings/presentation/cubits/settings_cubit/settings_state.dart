import 'package:qeema/core/error/failures.dart';

sealed class SettingsState {
  const SettingsState();
}

final class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

final class SettingsLoadSuccess extends SettingsState {
  const SettingsLoadSuccess({
    required this.isLockEnabled,
    required this.isDeviceSupported,
  });
  final bool isLockEnabled;
  final bool isDeviceSupported;
}

final class SettingsToggleInProgress extends SettingsState {
  const SettingsToggleInProgress({
    required this.isLockEnabled,
    required this.isDeviceSupported,
  });
  final bool isLockEnabled;
  final bool isDeviceSupported;
}

final class SettingsToggleError extends SettingsState {
  const SettingsToggleError({
    required this.failure,
    required this.isLockEnabled,
    required this.isDeviceSupported,
  });
  final Failure failure;
  final bool isLockEnabled;
  final bool isDeviceSupported;
}
