import 'package:qeema/core/error/failures.dart';

sealed class AppLockSettingsState {
  const AppLockSettingsState();
}

final class AppLockSettingsLoading extends AppLockSettingsState {
  const AppLockSettingsLoading();
}

final class AppLockSettingsLoaded extends AppLockSettingsState {
  const AppLockSettingsLoaded({
    required this.isEnabled,
    required this.deviceLockAvailable,
    this.isBusy = false,
  });

  final bool isEnabled;
  final bool deviceLockAvailable;
  final bool isBusy;

  AppLockSettingsLoaded copyWith({
    bool? isEnabled,
    bool? deviceLockAvailable,
    bool? isBusy,
  }) => AppLockSettingsLoaded(
    isEnabled: isEnabled ?? this.isEnabled,
    deviceLockAvailable: deviceLockAvailable ?? this.deviceLockAvailable,
    isBusy: isBusy ?? this.isBusy,
  );
}

final class AppLockSettingsFailure extends AppLockSettingsState {
  const AppLockSettingsFailure(this.failure);
  final Failure failure;
}
