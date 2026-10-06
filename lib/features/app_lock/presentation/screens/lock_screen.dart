import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/constants/app_assets.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/core/widgets/app_loader.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_state.dart';

class LockScreen extends StatelessWidget {
  const LockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The lock screen must never be popped: the router redirects to it from
    // every protected route, so a back gesture has to stay inside the app.
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: BlocBuilder<AppLockCubit, AppLockState>(
          builder: (context, state) {
            final t = context.t;
            final (message, prompting) = switch (state) {
              AppLockInitial() || AppLockChecking() => (null, true),
              AppLockLocked(:final reason) => switch (reason) {
                AppLockLockedReason.prompt => (null, true),
                AppLockLockedReason.cancelled => (null, false),
                AppLockLockedReason.lockedOut => (
                  t.app_lock.lockedOutMessage,
                  false,
                ),
              },
              AppLockUnlocked() || AppLockDisabled() => (null, true),
              AppLockError() => (t.app_lock.errorMessage, false),
            };

            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.lg,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppAssets.qeemaLogo, width: 88, height: 88),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        t.app_lock.title,
                        style: context.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        t.app_lock.hint,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (message != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          message,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colors.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      if (prompting)
                        const AppLoader()
                      else
                        AppButton(
                          label: t.app_lock.unlockButton,
                          onPressed: () =>
                              context.read<AppLockCubit>().unlock(),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
