import 'package:flutter/material.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';

class DashboardLoadingSkeleton extends StatelessWidget {
  const DashboardLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      children: [
        _shimmerBox(colors, width: double.infinity, height: 100),
        const SizedBox(height: 24),
        _shimmerBox(colors, width: 120, height: 120),
        const SizedBox(height: 24),
        SizedBox(
          height: 100,
          child: Row(
            children: List.generate(
              4,
              (i) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _shimmerBox(colors, width: 140, height: 100),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _shimmerBox(colors, width: double.infinity, height: 140),
      ],
    );
  }

  Widget _shimmerBox(
    AppColorsExtension colors, {
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.divider.withAlpha(40),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
