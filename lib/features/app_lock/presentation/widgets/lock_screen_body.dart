import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/animations/app_animated_entry.dart';
import 'package:qeema/core/animations/app_motion.dart';
import 'package:qeema/core/animations/entry_animation_type.dart';
import 'package:qeema/core/animations/micro_interactions/tap_scale.dart';
import 'package:qeema/core/constants/app_assets.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_state.dart';

class LockScreenBody extends StatelessWidget {
  const LockScreenBody({
    super.key,
    required this.onRetry,
    this.hasBiometrics = false,
  });

  final VoidCallback onRetry;
  final bool hasBiometrics;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.3),
            radius: 0.9,
            colors: [colors.primary.withValues(alpha: 0.12), colors.background],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppAssets.qeemaLogo, height: 80),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  context.t.app.name,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.t.app.tagline,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                BlocBuilder<LockCubit, AppLockState>(
                  builder: (context, state) {
                    return switch (state) {
                      AppLockInitial() => _buildAuthPrompt(context, false),
                      AppLockAuthenticating() => _buildAuthPrompt(
                        context,
                        true,
                      ),
                      AppLockError(failure: final failure) => _buildError(
                        context,
                        failure,
                      ),
                      AppLockUnlocked() => const SizedBox.shrink(),
                    };
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthPrompt(BuildContext context, bool isLoading) {
    final colors = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppAnimatedEntry(
          type: EntryAnimationType.popIn,
          duration: AppMotion.normal,
          child: TapScale(
            onTap: isLoading ? null : onRetry,
            child: Container(
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Icon(
                hasBiometrics ? Icons.fingerprint : Icons.lock_outline,
                size: 64,
                color: colors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          context.t.core.auth.unlockReason,
          style: context.textTheme.bodyLarge?.copyWith(
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        if (isLoading) ...[
          const SizedBox(height: AppSpacing.lg),
          AppButton(label: context.t.core.loading.message, isLoading: true),
        ],
      ],
    );
  }

  Widget _buildError(BuildContext context, Failure failure) {
    final message = _mapFailureToMessage(context, failure);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppAnimatedEntry(
          type: EntryAnimationType.fadeSlideUp,
          duration: AppMotion.normal,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: context.colors.error),
              const SizedBox(height: AppSpacing.md),
              Text(
                message,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: context.t.core.error.tryAgain,
                onPressed: onRetry,
                isOutline: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _mapFailureToMessage(BuildContext context, Failure failure) {
    return switch (failure) {
      LocalAuthCancelledFailure() => context.t.core.auth.biometricFailed,
      LocalAuthLockoutFailure() => context.t.appLock.tooManyAttempts,
      LocalAuthNoCredentialsFailure() => context.t.appLock.noCredentials,
      LocalAuthUnavailableFailure() => context.t.appLock.unavailable,
      _ => context.t.core.auth.biometricFailed,
    };
  }
}
