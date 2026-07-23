import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/animations/app_animated_entry.dart';
import 'package:qeema/core/animations/app_motion.dart';
import 'package:qeema/core/animations/entry_animation_type.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/core/widgets/app_snackbar.dart';
import 'package:qeema/features/auth/presentation/cubits/welcome_cubit/welcome_cubit.dart';
import 'package:qeema/features/auth/presentation/cubits/welcome_cubit/welcome_state.dart';
import 'package:qeema/features/auth/presentation/widgets/welcome_hero_illustration.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;

    return BlocConsumer<WelcomeCubit, WelcomeState>(
      listener: (context, state) {
        if (state is WelcomeGuestFailure) {
          final message = switch (state.failure) {
            final AnonymousSignInDisabledFailure _ =>
              t.auth.error.anonymousSignInDisabled,
            final NetworkAuthFailure _ => t.auth.error.networkError,
            _ => t.auth.error.unknownError,
          };
          AppSnackBar.showError(context, message);
        }
      },
      builder: (context, state) {
        final isGuestLoading = state is WelcomeGuestLoading;

        return Scaffold(
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.primary.withValues(alpha: 0.15),
                  colors.background,
                  colors.background,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    const AppAnimatedEntry(
                      type: EntryAnimationType.popIn,
                      child: WelcomeHeroIllustration(),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppAnimatedEntry(
                      type: EntryAnimationType.fadeSlideUp,
                      delay: AppMotion.normal,
                      child: Text(
                        t.auth.welcome.headline,
                        textAlign: TextAlign.center,
                        style: context.textTheme.displayMedium?.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppAnimatedEntry(
                      type: EntryAnimationType.fadeSlideUp,
                      delay:
                          AppMotion.normal + const Duration(milliseconds: 100),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: Text(
                          t.auth.welcome.subtext,
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(flex: 1),
                    AppAnimatedEntry(
                      type: EntryAnimationType.fadeSlideUp,
                      delay: AppMotion.slow,
                      child: Column(
                        children: [
                          AppButton(
                            label: t.auth.welcome.primaryCta,
                            isLoading: isGuestLoading,
                            onPressed: isGuestLoading
                                ? null
                                : () => context
                                      .read<WelcomeCubit>()
                                      .continueAsGuest(),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
