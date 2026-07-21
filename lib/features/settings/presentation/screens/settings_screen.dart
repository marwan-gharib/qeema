import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/settings/presentation/cubits/settings_cubit/settings_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/settings_cubit/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsCubit>()..load(),
      child: const _SettingsBody(),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.navigation.settings)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.t.settings.securitySection,
              style: context.textTheme.titleMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return switch (state) {
                  SettingsInitial() => const SizedBox.shrink(),
                  SettingsLoadSuccess(
                    :final isLockEnabled,
                    :final isDeviceSupported,
                  ) =>
                    _buildLockToggle(context, isLockEnabled, isDeviceSupported),
                  SettingsToggleInProgress(
                    :final isLockEnabled,
                    :final isDeviceSupported,
                  ) =>
                    _buildLockToggle(
                      context,
                      isLockEnabled,
                      isDeviceSupported,
                      isLoading: true,
                    ),
                  SettingsToggleError(
                    :final failure,
                    :final isLockEnabled,
                    :final isDeviceSupported,
                  ) =>
                    _buildLockToggleWithError(
                      context,
                      failure,
                      isLockEnabled,
                      isDeviceSupported,
                    ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockToggle(
    BuildContext context,
    bool isLockEnabled,
    bool isDeviceSupported, {
    bool isLoading = false,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(context.t.settings.requireUnlock),
              value: isLockEnabled && isDeviceSupported,
              onChanged: isDeviceSupported && !isLoading
                  ? (value) => context.read<SettingsCubit>().toggleLock(value)
                  : null,
              secondary: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      isDeviceSupported ? Icons.lock_outline : Icons.lock_open,
                    ),
            ),
            if (!isDeviceSupported)
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  bottom: AppSpacing.sm,
                ),
                child: Text(
                  context.t.settings.noDeviceLock,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockToggleWithError(
    BuildContext context,
    Failure failure,
    bool isLockEnabled,
    bool isDeviceSupported,
  ) {
    final message = _mapFailureToMessage(context, failure);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLockToggle(context, isLockEnabled, isDeviceSupported),
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.md),
          child: Text(
            message,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.error,
            ),
          ),
        ),
      ],
    );
  }

  String _mapFailureToMessage(BuildContext context, Failure failure) {
    return switch (failure) {
      LocalAuthCancelledFailure() => context.t.settings.authCancelled,
      LocalAuthLockoutFailure() => context.t.appLock.tooManyAttempts,
      _ => context.t.core.auth.biometricFailed,
    };
  }
}
