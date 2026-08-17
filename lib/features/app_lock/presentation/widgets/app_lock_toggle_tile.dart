import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/services/app_lock_service.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_snackbar.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_state.dart';

/// The App Lock settings toggle: device-support gating, and a biometric
/// authentication step before any enable/disable takes effect. Lives in the
/// app_lock feature and is embedded by the Settings screen — never rebuilt
/// there.
class AppLockToggleTile extends StatefulWidget {
  const AppLockToggleTile({
    super.key,
    this.appLockService,
    this.biometricAuthService,
    this.lockCubit,
  });

  final AppLockService? appLockService;
  final BiometricAuthService? biometricAuthService;
  final LockCubit? lockCubit;

  @override
  State<AppLockToggleTile> createState() => _AppLockToggleTileState();
}

class _AppLockToggleTileState extends State<AppLockToggleTile> {
  late final AppLockService _appLockService;
  late final BiometricAuthService _biometricAuthService;
  late final LockCubit _lockCubit;

  bool _enabled = false;
  bool _deviceSupported = true;
  bool _pendingValue = false;

  @override
  void initState() {
    super.initState();
    _appLockService = widget.appLockService ?? getIt<AppLockService>();
    _biometricAuthService =
        widget.biometricAuthService ?? getIt<BiometricAuthService>();
    _lockCubit = widget.lockCubit ?? getIt<LockCubit>();
    _load();
  }

  @override
  void dispose() {
    if (widget.lockCubit == null) {
      _lockCubit.close();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final supported = await _biometricAuthService.isDeviceSupported;
    final enabled = await _appLockService.isEnabled();
    if (!mounted) return;
    setState(() {
      _deviceSupported = supported;
      _enabled = enabled;
    });
  }

  void _onToggle(bool value) {
    if (value == _enabled) return;
    _pendingValue = value;
    _lockCubit.authenticate(localizedReason: context.t.core.auth.unlockReason);
  }

  Future<void> _applyPendingToggle() async {
    if (_pendingValue) {
      await _appLockService.setEnabled();
    } else {
      await _appLockService.setDisabled();
    }
    if (!mounted) return;
    setState(() => _enabled = _pendingValue);
  }

  void _showAuthError(Failure failure) {
    final t = context.t;
    final message = switch (failure) {
      final LocalAuthCancelledFailure _ => t.settings.authCancelled,
      final LocalAuthNoCredentialsFailure _ => t.settings.noDeviceLock,
      final LocalAuthUnavailableFailure _ => t.settings.noDeviceLock,
      _ => failure.message ?? t.core.failure.unknownFailure,
    };
    AppSnackBar.showError(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;

    return BlocProvider.value(
      value: _lockCubit,
      child: BlocListener<LockCubit, AppLockState>(
        listener: (context, state) {
          switch (state) {
            case AppLockInitial():
            case AppLockAuthenticating():
              break;
            case AppLockUnlocked():
              _applyPendingToggle();
            case AppLockError(:final failure):
              _showAuthError(failure);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(Icons.lock_outline, size: 22, color: colors.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.settings.requireUnlock,
                      style: context.textTheme.bodyLarge,
                    ),
                    if (!_deviceSupported) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        t.settings.noDeviceLock,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Switch(
                value: _enabled,
                onChanged: _deviceSupported ? _onToggle : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
