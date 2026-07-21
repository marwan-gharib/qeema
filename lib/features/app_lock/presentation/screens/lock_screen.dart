import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/animations/app_animated_entry.dart';
import 'package:qeema/core/animations/app_motion.dart';
import 'package:qeema/core/animations/entry_animation_type.dart';
import 'package:qeema/core/constants/app_assets.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_state.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key, required this.onUnlocked, this.lockCubit});

  final VoidCallback onUnlocked;
  final LockCubit? lockCubit;

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  late final LockCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = widget.lockCubit ?? getIt<LockCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _triggerAuth());
  }

  void _triggerAuth() {
    _cubit.authenticate(localizedReason: context.t.core.auth.unlockReason);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocProvider.value(
        value: _cubit,
        child: BlocListener<LockCubit, AppLockState>(
          listenWhen: (previous, current) => current is AppLockUnlocked,
          listener: (context, state) => widget.onUnlocked(),
          child: Scaffold(body: _LockScreenBody(onRetry: _triggerAuth)),
        ),
      ),
    );
  }
}

class _LockScreenBody extends StatelessWidget {
  const _LockScreenBody({required this.onRetry});
  final VoidCallback onRetry;

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
        Icon(Icons.lock_outline, size: 64, color: colors.primary),
        const SizedBox(height: AppSpacing.md),
        Text(
          context.t.core.auth.unlockReason,
          style: context.textTheme.bodyLarge?.copyWith(
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        if (isLoading) ...[
          const SizedBox(height: AppSpacing.lg),
          const CircularProgressIndicator(),
        ],
      ],
    );
  }

  Widget _buildError(BuildContext context, Failure failure) {
    final message = _mapFailureToMessage(context, failure);
    return AppAnimatedEntry(
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
          IconButton(
            icon: Icon(
              Icons.lock_outline,
              size: 48,
              color: context.colors.primary,
            ),
            onPressed: onRetry,
            tooltip: context.t.core.error.tryAgain,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.t.core.error.tryAgain,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
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
