import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/extensions/api_result_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/features/app_lock/domain/usecases/authenticate_device_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/check_device_lock_available_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/get_app_lock_enabled_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/set_app_lock_enabled_usecase.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/app_lock_settings_cubit/app_lock_settings_state.dart';
import 'package:qeema/features/settings/presentation/mappers/app_lock_prompt_mapper.dart';

class AppLockSettingsCubit extends Cubit<AppLockSettingsState> {
  AppLockSettingsCubit(
    this._getEnabled,
    this._setEnabled,
    this._checkAvailable,
    this._authenticate,
    this._appLock,
  ) : super(const AppLockSettingsLoading());

  final GetAppLockEnabledUseCase _getEnabled;
  final SetAppLockEnabledUseCase _setEnabled;
  final CheckDeviceLockAvailableUseCase _checkAvailable;
  final AuthenticateDeviceUseCase _authenticate;
  final AppLockCubit _appLock;

  /// The Settings route is torn down as soon as the gate redirects to `/lock`,
  /// which closes this cubit while its own OS prompt is still in flight. Every
  /// emit past that point has to be dropped instead of throwing.
  void _safeEmit(AppLockSettingsState next) {
    if (isClosed) return;
    emit(next);
  }

  Future<void> load() async {
    _safeEmit(const AppLockSettingsLoading());
    final enabledResult = await _getEnabled();
    final availableResult = await _checkAvailable();
    if (isClosed) return;
    final enabled = enabledResult.dataOrNull;
    final available = availableResult.dataOrNull;
    if (enabled == null || available == null) {
      _safeEmit(
        AppLockSettingsFailure(
          enabledResult.failureOrNull ?? availableResult.failureOrNull!,
        ),
      );
      return;
    }
    _safeEmit(
      AppLockSettingsLoaded(isEnabled: enabled, deviceLockAvailable: available),
    );
  }

  /// Toggling off requires OS authentication first; toggling on applies
  /// immediately. Failures keep the switch at its previous value.
  Future<void> setEnabled(bool value) async {
    final current = state;
    if (current is! AppLockSettingsLoaded || current.isBusy) return;
    if (!value) {
      _safeEmit(current.copyWith(isBusy: true));
      // The prompt must run inside the gate's authentication window: without
      // it, the pause the OS prompt causes re-locks the app and redirects to
      // `/lock` underneath this screen.
      final authResult = await _appLock.duringAuthentication(
        () => _authenticate(t.app_lock.disableReason),
      );
      if (isClosed) return;
      if (AppLockPromptMapper.fromResult(authResult) !=
          AppLockPromptOutcome.confirmed) {
        _safeEmit(current);
        return;
      }
    }
    final result = await _setEnabled(value);
    if (isClosed) return;
    final saved = result.fold(onSuccess: (_) => true, onFailure: (_) => false);
    if (!saved) {
      // Keep the switch at its previous value when persistence fails.
      _safeEmit(current);
      return;
    }
    _safeEmit(current.copyWith(isBusy: false, isEnabled: value));
  }
}
