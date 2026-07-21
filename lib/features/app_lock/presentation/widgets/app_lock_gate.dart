import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/core/services/app_lock_service.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_state.dart';
import 'package:qeema/features/app_lock/presentation/screens/lock_screen.dart';

class AppLockGate extends StatefulWidget {
  const AppLockGate({
    super.key,
    required this.child,
    this.appLockService,
    this.biometricAuthService,
    this.supabaseClientProvider,
  });

  final Widget child;
  final AppLockService? appLockService;
  final BiometricAuthService? biometricAuthService;
  final SupabaseClientProvider? supabaseClientProvider;

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> with WidgetsBindingObserver {
  late final AppLockService _appLockService;
  late final BiometricAuthService _biometricAuthService;
  late final SupabaseClientProvider _supabaseProvider;

  bool _isLocked = false;
  bool _initialized = false;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _appLockService = widget.appLockService ?? getIt<AppLockService>();
    _biometricAuthService =
        widget.biometricAuthService ?? getIt<BiometricAuthService>();
    _supabaseProvider =
        widget.supabaseClientProvider ?? getIt<SupabaseClientProvider>();
    WidgetsBinding.instance.addObserver(this);
    _checkOnColdStart();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _initialized &&
        !_isAuthenticating) {
      _checkOnResume();
    }
  }

  Future<void> _checkOnColdStart() async {
    final session = _supabaseProvider.client.auth.currentSession;
    final hasSession = session != null;
    if (hasSession && await _shouldLock()) {
      if (mounted) setState(() => _isLocked = true);
    }
    if (mounted) setState(() => _initialized = true);
  }

  Future<void> _checkOnResume() async {
    if (await _shouldLock()) {
      if (mounted) setState(() => _isLocked = true);
    }
  }

  Future<bool> _shouldLock() async {
    final enabled = await _appLockService.isEnabled();
    if (!enabled) return false;
    final deviceSupported = await _biometricAuthService.isDeviceSupported;
    return deviceSupported;
  }

  void _onUnlocked() {
    if (mounted) setState(() => _isLocked = false);
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
      OverlayEntry(
        builder: (context) => Stack(
          children: [
            widget.child,
            if (_isLocked)
              BlocProvider(
                create: (_) => getIt<LockCubit>(),
                child: BlocListener<LockCubit, AppLockState>(
                  listener: (context, state) {
                    switch (state) {
                      case AppLockAuthenticating():
                        setState(() => _isAuthenticating = true);
                      case AppLockUnlocked():
                        setState(() {
                          _isLocked = false;
                          _isAuthenticating = false;
                        });
                        break;
                      case AppLockError():
                        // small cooldown so a lifecycle `resumed` event that
                        // arrives right as the OS prompt closes (even on
                        // failure/cancel) doesn't race this flag being cleared
                        Future.delayed(const Duration(milliseconds: 400), () {
                          if (mounted) setState(() => _isAuthenticating = false);
                        });
                        break;
                      case AppLockInitial():
                        break;
                    }
                  },
                  child: LockScreen(onUnlocked: _onUnlocked),
                ),
              ),
          ],
        ),
      ),],
    );
  }
}
