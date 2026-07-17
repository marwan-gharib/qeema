import 'package:flutter/material.dart';
import 'package:qeema/core/animations/app_motion.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/theme/app_spacing.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    required this.totalPages,
    required this.currentPage,
  });
  final int totalPages;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < totalPages; i++)
          AnimatedContainer(
            duration: AppMotion.slow,
            curve: AppMotion.entrance,
            width: i == currentPage ? 24 : 8,
            height: 8,
            margin: EdgeInsets.only(
              right: i < totalPages - 1 ? AppSpacing.xs : 0,
            ),
            decoration: BoxDecoration(
              color: i == currentPage ? colors.primary : colors.divider,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}
