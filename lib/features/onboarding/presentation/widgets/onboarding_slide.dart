import 'package:flutter/material.dart';
import 'package:qeema/core/animations/app_animated_entry.dart';
import 'package:qeema/core/animations/app_motion.dart';
import 'package:qeema/core/animations/entry_animation_type.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/onboarding/presentation/widgets/onboarding_illustration.dart';

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({
    super.key,
    required this.illustrationType,
    required this.headline,
    required this.body,
  });
  final OnboardingIllustrationType illustrationType;
  final String headline;
  final String body;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          const Spacer(flex: 2),
          AppAnimatedEntry(
            type: EntryAnimationType.popIn,
            duration: AppMotion.slow,
            curve: AppMotion.emphasized,
            child: OnboardingIllustration(type: illustrationType),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppAnimatedEntry(
            type: EntryAnimationType.fadeSlideUp,
            duration: AppMotion.normal,
            curve: AppMotion.entrance,
            delay: const Duration(milliseconds: 150),
            child: Text(
              headline,
              style: textTheme.displayLarge!.copyWith(fontSize: 26),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppAnimatedEntry(
            type: EntryAnimationType.fadeSlideUp,
            duration: AppMotion.normal,
            curve: AppMotion.entrance,
            delay: const Duration(milliseconds: 300),
            child: Text(
              body,
              style: textTheme.bodyLarge?.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
