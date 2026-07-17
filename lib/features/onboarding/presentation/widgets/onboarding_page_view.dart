import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/animations/app_animated_entry.dart';
import 'package:qeema/core/animations/app_motion.dart';
import 'package:qeema/core/animations/entry_animation_type.dart';
import 'package:qeema/core/animations/micro_interactions/tap_scale.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_cubit.dart';
import 'package:qeema/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_state.dart';
import 'package:qeema/features/onboarding/presentation/widgets/onboarding_illustration.dart';
import 'package:qeema/features/onboarding/presentation/widgets/onboarding_page_indicator.dart';
import 'package:qeema/features/onboarding/presentation/widgets/onboarding_slide.dart';

class OnboardingPageView extends StatefulWidget {
  const OnboardingPageView({super.key});

  @override
  State<OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingInProgress) {
          // Guard: only animate if the target page differs from current,
          // preventing infinite loop with PageView.onPageChanged (swipe -> cubit -> listener -> animate -> PageView -> onPageChanged -> cubit -> ...)
          final currentPage = _pageController.page?.round();
          if (currentPage != null && currentPage != state.currentPage) {
            _pageController.animateToPage(
              state.currentPage,
              duration: AppMotion.slow,
              curve: AppMotion.entrance,
            );
          }
        }
      },
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          return switch (state) {
            OnboardingInProgress(currentPage: final page) => _buildContent(
              context,
              page,
              t,
            ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, int currentPage, Translations t) {
    final isLastPage = currentPage >= OnboardingCubit.totalPages - 1;

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: OnboardingCubit.totalPages,
          onPageChanged: (index) {
            context.read<OnboardingCubit>().onPageChanged(index);
          },
          itemBuilder: (context, index) {
            final slide = _slides(context)[index];
            return OnboardingSlide(
              key: ValueKey('slide_$index'),
              illustrationType: slide.$1,
              headline: slide.$2,
              body: slide.$3,
            );
          },
        ),
        Positioned(
          top: AppSpacing.xl,
          right: AppSpacing.md,
          child: IntrinsicWidth(
            child: AppAnimatedEntry(
              type: EntryAnimationType.fadeSlideDown,
              duration: AppMotion.slow,
              delay: const Duration(milliseconds: 200),
              child: TapScale(
                onTap: isLastPage
                    ? null
                    : () => context.read<OnboardingCubit>().skip(),
                child: AnimatedOpacity(
                  duration: AppMotion.slow,
                  opacity: isLastPage ? 0.0 : 1.0,
                  child: AppButton(
                    label: t.onboarding.skip,
                    onPressed: isLastPage
                        ? null
                        : () => context.read<OnboardingCubit>().skip(),
                    isText: true,
                    backgroundColor: context.colors.background,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: AppSpacing.xxl,
          left: 0,
          right: 0,
          child: AppAnimatedEntry(
            type: EntryAnimationType.fadeSlideUp,
            duration: AppMotion.slow,
            delay: const Duration(milliseconds: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OnboardingPageIndicator(
                  totalPages: OnboardingCubit.totalPages,
                  currentPage: currentPage,
                ),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: TapScale(
                    onTap: () => context.read<OnboardingCubit>().next(),
                    child: AnimatedSwitcher(
                      duration: AppMotion.normal,
                      switchInCurve: AppMotion.entrance,
                      switchOutCurve: AppMotion.exit,
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: AppButton(
                        key: ValueKey(isLastPage ? 'getStarted' : 'next'),
                        label: isLastPage
                            ? t.onboarding.getStarted
                            : t.onboarding.next,
                        onPressed: () => context.read<OnboardingCubit>().next(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<(OnboardingIllustrationType, String, String)> _slides(
    BuildContext context,
  ) {
    final t = context.t;
    return [
      (
        OnboardingIllustrationType.moneyValue,
        t.onboarding.slide1Headline,
        t.onboarding.slide1Body,
      ),
      (
        OnboardingIllustrationType.assetTracking,
        t.onboarding.slide2Headline,
        t.onboarding.slide2Body,
      ),
      (
        OnboardingIllustrationType.inflationChart,
        t.onboarding.slide3Headline,
        t.onboarding.slide3Body,
      ),
      (
        OnboardingIllustrationType.getStarted,
        t.onboarding.slide4Headline,
        t.onboarding.slide4Body,
      ),
    ];
  }
}
