import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_state.dart';

class LockCubit extends Cubit<AppLockState> {
  LockCubit(this._biometricAuthService) : super(const AppLockInitial());

  final BiometricAuthService _biometricAuthService;

  void reset() => emit(const AppLockInitial());

  Future<bool> get canCheckBiometrics async =>
      await _biometricAuthService.canCheckBiometrics;

  Future<void> authenticate({required String localizedReason}) async {
    emit(const AppLockAuthenticating());
    final result = await _biometricAuthService.authenticate(
      localizedReason: localizedReason,
    );
    result.fold(
      onSuccess: (_) => emit(const AppLockUnlocked()),
      onFailure: (failure) => emit(AppLockError(failure)),
    );
  }
}
