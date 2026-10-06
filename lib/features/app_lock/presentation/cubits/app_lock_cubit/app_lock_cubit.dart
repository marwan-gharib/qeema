import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/extensions/api_result_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/app_lock_gate.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/domain/usecases/authenticate_device_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/check_device_lock_available_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/get_app_lock_enabled_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/set_recents_preview_hidden_usecase.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_state.dart';

class AppLockCubit extends Cubit<AppLockState> implements AppLockGate {
  AppLockCubit(
    this._getEnabledUseCase,
    this._checkAvailableUseCase,
    this._authenticateUseCase,
    this._setRecentsPreviewHiddenUseCase,
  ) : super(const AppLockInitial()) {
    _subscription = stream.listen((state) {
      _revision.value++;
    });
  }

  final GetAppLockEnabledUseCase _getEnabledUseCase;
  final CheckDeviceLockAvailableUseCase _checkAvailableUseCase;
  final AuthenticateDeviceUseCase _authenticateUseCase;
  final SetRecentsPreviewHiddenUseCase _setRecentsPreviewHiddenUseCase;

  late final StreamSubscription<AppLockState> _subscription;

  final ValueNotifier<int> _revision = ValueNotifier(0);
  bool _isAuthenticating = false;
  bool _requiresLock = true;
  bool? _syncedRequiresLock;
  bool _sawBackgroundPause = false;
  int _foreignAuthenticationDepth = 0;

  /// Set once the initial cold-start gate decision is reached (either unlocked
  /// after biometric success, or app lock disabled / device lock unavailable).
  /// Once true, never reset during the process lifetime so the router subtree
  /// stays mounted and subsequent locks use an overlay.
  bool _hasCompletedFirstEntry = false;

  @override
  bool get hasCompletedFirstEntry => _hasCompletedFirstEntry;

  @override
  void emit(AppLockState state) {
    if (!_hasCompletedFirstEntry &&
        (state is AppLockUnlocked || state is AppLockDisabled)) {
      _hasCompletedFirstEntry = true;
    }
    super.emit(state);
  }

  void _updateRequiresLock(bool value) {
    _requiresLock = value;
    if (_syncedRequiresLock == value) return;
    _syncedRequiresLock = value;
    unawaited(_syncRecentsPreview(value));
  }

  bool get _isPromptInFlight =>
      _isAuthenticating || _foreignAuthenticationDepth > 0;

  @override
  bool get isLocked => _isGateClosed(state);

  @override
  Listenable get listenable => _revision;

  Future<void> onAppResumed() async {
    // The OS prompt pauses and resumes the app, and the platform delivers the
    // auth result before the matching lifecycle event — so a resume routinely
    // arrives with the gate still closed after a cancel. Only a resume that
    // follows a real background pause (or the cold start, which has no
    // preceding pause) may evaluate; otherwise the prompt re-shows itself
    // forever and the lock screen's Unlock button is never reachable.
    if (_isPromptInFlight) return;
    final isColdStart = state is AppLockInitial;
    if (!_sawBackgroundPause && !isColdStart) return;
    _sawBackgroundPause = false;
    if (!_isGateClosed(state)) return;
    await _evaluateGate();
  }

  void onAppPaused() {
    // Backgrounding must not re-lock the app underneath a prompt another flow
    // owns (Settings authenticating before it disables App Lock), and must not
    // mark the app as backgrounded while our own prompt is up.
    if (_isPromptInFlight) return;
    _sawBackgroundPause = true;
    if (_requiresLock && state is AppLockUnlocked) {
      emit(const AppLockLocked(AppLockLockedReason.prompt));
    }
  }

  /// Runs [action] while the OS prompt is up on behalf of another flow, so a
  /// background/foreground round trip during that prompt neither re-locks the
  /// gate nor lets a resume start a second evaluation.
  Future<T> duringAuthentication<T>(Future<T> Function() action) async {
    _foreignAuthenticationDepth++;
    try {
      return await action();
    } finally {
      _foreignAuthenticationDepth--;
    }
  }

  Future<void> unlock() async {
    if (_isAuthenticating) return;
    await _evaluateGate();
  }

  /// Re-reads the enabled flag and device-lock availability without prompting,
  /// so a Settings toggle is reflected in the gate. Only applies while the
  /// gate is open — the lock screen owns the flow when it is closed.
  Future<void> refresh() async {
    if (_isAuthenticating) return;
    if (_isGateClosed(state)) return;
    await _evaluateGate(authenticateWhenRequired: false);
  }

  Future<void> _evaluateGate({bool authenticateWhenRequired = true}) async {
    _isAuthenticating = true;
    try {
      if (state is AppLockInitial) {
        emit(const AppLockChecking());
      }

      final enabledResult = await _getEnabledUseCase();
      final enabled = enabledResult.dataOrNull;
      if (enabled == null) {
        _updateRequiresLock(true);
        emit(
          AppLockError(enabledResult.failureOrNull ?? const UnknownFailure()),
        );
        return;
      }
      if (!enabled) {
        _updateRequiresLock(false);
        emit(const AppLockDisabled());
        return;
      }

      final availableResult = await _checkAvailableUseCase();
      final available = availableResult.dataOrNull;
      if (available == null) {
        _updateRequiresLock(true);
        emit(
          AppLockError(availableResult.failureOrNull ?? const UnknownFailure()),
        );
        return;
      }
      if (!available) {
        _updateRequiresLock(false);
        emit(const AppLockUnlocked());
        return;
      }

      _updateRequiresLock(true);
      if (!authenticateWhenRequired) {
        emit(const AppLockUnlocked());
        return;
      }

      emit(const AppLockLocked(AppLockLockedReason.prompt));
      final authResult = await _authenticateUseCase(t.app_lock.promptReason);
      authResult.fold(
        onSuccess: (status) {
          switch (status) {
            case AppLockStatus.authenticated:
              emit(const AppLockUnlocked());
            case AppLockStatus.notRequired:
              _updateRequiresLock(false);
              emit(const AppLockUnlocked());
            case AppLockStatus.failed:
              emit(const AppLockLocked(AppLockLockedReason.cancelled));
            case AppLockStatus.lockedOut:
              emit(const AppLockLocked(AppLockLockedReason.lockedOut));
          }
        },
        onFailure: (failure) => emit(AppLockError(failure)),
      );
    } finally {
      _isAuthenticating = false;
    }
  }

  Future<void> _syncRecentsPreview(bool hidden) async {
    // Best-effort: a platform that cannot hide the preview must not affect
    // the lock flow itself.
    final result = await _setRecentsPreviewHiddenUseCase(hidden);
    result.fold(onSuccess: (_) {}, onFailure: (_) {});
  }

  static bool _isGateClosed(AppLockState current) => switch (current) {
    AppLockUnlocked() || AppLockDisabled() => false,
    _ => true,
  };

  @override
  Future<void> close() async {
    // `Cubit.isClosed` is the authority here: disposing the revision twice
    // trips a debug assert.
    if (isClosed) return;
    await _subscription.cancel();
    _revision.dispose();
    await super.close();
  }
}
