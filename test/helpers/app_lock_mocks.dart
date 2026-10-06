import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:qeema/core/router/app_lock_gate.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/domain/usecases/authenticate_device_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/check_device_lock_available_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/get_app_lock_enabled_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/set_app_lock_enabled_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/set_recents_preview_hidden_usecase.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';

class FakeAppLockGate implements AppLockGate {
  FakeAppLockGate({this.locked = false, this.completedFirstEntry = true});
  bool locked;
  bool completedFirstEntry;
  final ValueNotifier<int> _notifier = ValueNotifier(0);

  void setLocked(bool value) {
    locked = value;
    _notifier.value++;
  }

  void setCompletedFirstEntry(bool value) {
    completedFirstEntry = value;
    _notifier.value++;
  }

  @override
  bool get isLocked => locked;

  @override
  Listenable get listenable => _notifier;

  @override
  bool get hasCompletedFirstEntry => completedFirstEntry;
}

class MockGetAppLockEnabledUseCase implements GetAppLockEnabledUseCase {
  ApiResult<bool> result = const Success(true);
  int calls = 0;

  @override
  Future<ApiResult<bool>> call() async {
    calls++;
    return result;
  }
}

class MockSetAppLockEnabledUseCase implements SetAppLockEnabledUseCase {
  ApiResult<void> result = const Success(null);
  final List<bool> calls = [];

  @override
  Future<ApiResult<void>> call(bool input) async {
    calls.add(input);
    return result;
  }
}

class MockCheckDeviceLockAvailableUseCase
    implements CheckDeviceLockAvailableUseCase {
  ApiResult<bool> result = const Success(true);
  int calls = 0;

  @override
  Future<ApiResult<bool>> call() async {
    calls++;
    return result;
  }
}

class MockAuthenticateDeviceUseCase implements AuthenticateDeviceUseCase {
  ApiResult<AppLockStatus> result = const Success(AppLockStatus.authenticated);
  final List<String> reasons = [];

  /// When set, the prompt stays pending until the completer completes, so a
  /// test can act while the OS prompt is still on screen.
  Completer<ApiResult<AppLockStatus>>? gate;

  @override
  Future<ApiResult<AppLockStatus>> call(String input) async {
    reasons.add(input);
    final pending = gate;
    if (pending != null) return pending.future;
    return result;
  }
}

class MockSetRecentsPreviewHiddenUseCase
    implements SetRecentsPreviewHiddenUseCase {
  ApiResult<void> result = const Success(null);
  final List<bool> calls = [];

  @override
  Future<ApiResult<void>> call(bool input) async {
    calls.add(input);
    return result;
  }
}

class SpyAppLockCubit extends AppLockCubit {
  SpyAppLockCubit(
    super.getEnabled,
    super.checkAvailable,
    super.authenticate,
    super.setRecentsPreviewHidden,
  );
  int refreshCalls = 0;

  @override
  Future<void> refresh() {
    refreshCalls++;
    return super.refresh();
  }
}

/// Records how many prompts were started inside `duringAuthentication`, so a
/// test can assert the gate was told a foreign prompt is on screen.
class SpyAuthWindowAppLockCubit extends AppLockCubit {
  SpyAuthWindowAppLockCubit(
    super.getEnabled,
    super.checkAvailable,
    super.authenticate,
    super.setRecentsPreviewHidden,
  );
  int openWindows = 0;
  int maxConcurrentWindows = 0;

  @override
  Future<T> duringAuthentication<T>(Future<T> Function() action) {
    openWindows++;
    maxConcurrentWindows = openWindows > maxConcurrentWindows
        ? openWindows
        : maxConcurrentWindows;
    return super.duringAuthentication(action).whenComplete(() {
      openWindows--;
    });
  }
}
