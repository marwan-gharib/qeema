import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/services/app_lock_service.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/core/utils/logger.dart';
import 'package:qeema/features/settings/presentation/cubits/settings_cubit/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._appLockService, this._biometricAuthService)
    : super(const SettingsInitial());

  final AppLockService _appLockService;
  final BiometricAuthService _biometricAuthService;

  Future<void> load() async {
    final isLockEnabled = await _appLockService.isEnabled();
    final isDeviceSupported = await _biometricAuthService.isDeviceSupported;
    emit(
      SettingsLoadSuccess(
        isLockEnabled: isLockEnabled,
        isDeviceSupported: isDeviceSupported,
      ),
    );
  }

  Future<void> toggleLock(bool enable) async {
    final current = state;
    final isLockEnabled = switch (current) {
      SettingsLoadSuccess(:final isLockEnabled) => isLockEnabled,
      SettingsToggleInProgress(:final isLockEnabled) => isLockEnabled,
      SettingsToggleError(:final isLockEnabled) => isLockEnabled,
      _ => false,
    };
    final isDeviceSupported = switch (current) {
      SettingsLoadSuccess(:final isDeviceSupported) => isDeviceSupported,
      SettingsToggleInProgress(:final isDeviceSupported) => isDeviceSupported,
      SettingsToggleError(:final isDeviceSupported) => isDeviceSupported,
      _ => false,
    };

    if (!isDeviceSupported) {
      Logger.info(
        '[Settings] toggleLock($enable) — device not supported, returning early',
      );
      return;
    }

    Logger.info('[Settings] toggleLock($enable) — emitting ToggleInProgress');
    emit(
      SettingsToggleInProgress(
        isLockEnabled: isLockEnabled,
        isDeviceSupported: isDeviceSupported,
      ),
    );

    final authResult = await _biometricAuthService.authenticate(
      localizedReason: enable
          ? 'Authenticate to enable app lock'
          : 'Authenticate to disable app lock',
    );

    Logger.info('[Settings] toggleLock — authResult received, calling fold');
    await authResult.fold(
      onSuccess: (authenticated) async {
        Logger.info(
          '[Settings] toggleLock — fold onSuccess, authenticated: $authenticated',
        );
        if (authenticated) {
          if (enable) {
            await _appLockService.setEnabled();
          } else {
            await _appLockService.setDisabled();
          }
          final writtenValue = await _appLockService.isEnabled();
          Logger.info(
            '[Settings] toggleLock — write confirmed, read-back: $writtenValue',
          );
          emit(
            SettingsLoadSuccess(
              isLockEnabled: enable,
              isDeviceSupported: isDeviceSupported,
            ),
          );
        } else {
          Logger.info(
            '[Settings] toggleLock — auth returned false, not persisting',
          );
          emit(
            SettingsToggleError(
              failure: const LocalAuthCancelledFailure(),
              isLockEnabled: isLockEnabled,
              isDeviceSupported: isDeviceSupported,
            ),
          );
        }
      },
      onFailure: (failure) {
        Logger.warning('[Settings] toggleLock — fold onFailure: $failure');
        emit(
          SettingsToggleError(
            failure: failure,
            isLockEnabled: isLockEnabled,
            isDeviceSupported: isDeviceSupported,
          ),
        );
      },
    );
  }
}
