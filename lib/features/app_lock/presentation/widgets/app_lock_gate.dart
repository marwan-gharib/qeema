import 'package:flutter/material.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/core/services/app_lock_service.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/screens/lock_screen.dart';

class AppLockGate extends StatefulWidget {
  const AppLockGate({
    super.key,
    required this.child,
    this.appLockService,
    this.biometricAuthService,
    this.lockCubit,
    this.hasSession,
  });

  final Widget child;
  final AppLockService? appLockService;
  final BiometricAuthService? biometricAuthService;
  final LockCubit? lockCubit;

  /// Override for the session check in [._shouldLock].
  /// When null, defaults to [SupabaseClientProvider] via GetIt.
  final bool? hasSession;

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> with WidgetsBindingObserver {
  late final AppLockService _appLockService;
  late final BiometricAuthService _biometricAuthService;
  late final LockCubit _cubit;

  bool _isLocked = false;
  AppLifecycleState? _previousState;

  @override
  void initState() {
    super.initState();
    _appLockService = widget.appLockService ?? getIt<AppLockService>();
    _biometricAuthService =
        widget.biometricAuthService ?? getIt<BiometricAuthService>();
    _cubit = widget.lockCubit ?? getIt<LockCubit>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (widget.lockCubit == null) {
      _cubit.close();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _previousState == AppLifecycleState.paused &&
        !_isLocked) {
      _checkOnResume();
    }
    _previousState = state;
  }

  Future<void> _checkOnResume() async {
    if (await _shouldLock()) {
      if (mounted) setState(() => _isLocked = true);
    }
  }

  Future<bool> _shouldLock() async {
    final hasSession =
        widget.hasSession ??
        getIt<SupabaseClientProvider>().client.auth.currentSession != null;
    if (!hasSession) return false;
    final enabled = await _appLockService.isEnabled();
    if (!enabled) return false;
    final deviceSupported = await _biometricAuthService.isDeviceSupported;
    return deviceSupported;
  }

  void _onUnlocked() {
    _cubit.reset();
    _previousState = null;
    if (mounted) setState(() => _isLocked = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isLocked)
          LockScreen(onUnlocked: _onUnlocked, lockCubit: _cubit),
      ],
    );
  }
}
