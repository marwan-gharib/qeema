import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/app_animated_entry.dart';
import 'package:qeema/core/animations/app_motion.dart';
import 'package:qeema/core/animations/entry_animation_type.dart';
import 'package:qeema/core/constants/app_assets.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/extensions/failure_localization_extension.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/core/widgets/app_content_box.dart';
import 'package:qeema/core/widgets/app_snackbar.dart';
import 'package:qeema/features/auth/presentation/cubits/google_sign_in_cubit/google_sign_in_cubit.dart';
import 'package:qeema/features/auth/presentation/cubits/google_sign_in_cubit/google_sign_in_state.dart';
import 'package:qeema/features/auth/presentation/cubits/welcome_cubit/welcome_cubit.dart';
import 'package:qeema/features/auth/presentation/cubits/welcome_cubit/welcome_state.dart';
import 'package:qeema/features/auth/presentation/widgets/welcome_hero_illustration.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;

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
          child: AppContentBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  const AppAnimatedEntry(
                    type: EntryAnimationType.popIn,
                    child: WelcomeHeroIllustration(),
                  ),
                  SizedBox(height: AppSpacing.xl),
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
                  SizedBox(height: AppSpacing.sm),
                  AppAnimatedEntry(
                    type: EntryAnimationType.fadeSlideUp,
                    delay: AppMotion.normal + const Duration(milliseconds: 100),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
                  BlocConsumer<GoogleSignInCubit, GoogleSignInState>(
                    listener: (context, state) {
                      if (state is GoogleSignInFailureState) {
                        AppSnackBar.showError(
                          context,
                          state.failure.localizedMessage(context),
                        );
                      } else if (state is GoogleSignInSuccessState) {
                        context.goNamed(RouteNames.home);
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is GoogleSignInLoadingState;
                      return AppAnimatedEntry(
                        type: EntryAnimationType.fadeSlideUp,
                        delay: AppMotion.slow,
                        child: Column(
                          children: [
                            AppButton(
                              label: t.auth.welcome.googleSignInCta,
                              prefixWidget: Image.asset(
                                AppAssets.googleLogo,
                                width: AppSpacing.lg,
                                height: AppSpacing.lg,
                              ),
                              isLoading: isLoading,
                              onPressed: isLoading
                                  ? null
                                  : () => context
                                        .read<GoogleSignInCubit>()
                                        .googleSignIn(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: AppSpacing.md),
                  BlocConsumer<WelcomeCubit, WelcomeState>(
                    listener: (context, state) {
                      if (state is WelcomeGuestFailure) {
                        AppSnackBar.showError(
                          context,
                          state.failure.localizedMessage(context),
                        );
                      } else if (state is WelcomeGuestSuccess) {
                        context.goNamed(RouteNames.home);
                      }
                    },
                    builder: (context, state) {
                      final isGuestLoading = state is WelcomeGuestLoading;
                      return AppAnimatedEntry(
                        type: EntryAnimationType.fadeSlideUp,
                        delay: AppMotion.slow,
                        child: Column(
                          children: [
                            AppButton(
                              label: t.auth.welcome.continueAsGuestCta,
                              isLoading: isGuestLoading,
                              onPressed: isGuestLoading
                                  ? null
                                  : () => context
                                        .read<WelcomeCubit>()
                                        .continueAsGuest(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
