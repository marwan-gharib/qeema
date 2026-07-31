import 'package:flutter/material.dart';
import 'package:qeema/core/animations/loading/shimmer_box.dart';
import 'package:qeema/core/theme/app_spacing.dart';

/// Skeleton placeholder mirroring the loaded dashboard's exact section
/// dimensions: summary card (~160), ring block (~144), mini-card row (116),
/// and the trend chart block (~164).
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        80,
      ),
      children: [
        const ShimmerBox(height: 160, borderRadius: 16),
        const SizedBox(height: AppSpacing.lg),
        const Center(
          child: Column(
            children: [
              ShimmerBox(width: 120, height: 120, borderRadius: 60),
              SizedBox(height: AppSpacing.xs),
              ShimmerBox(height: 16, width: 180, borderRadius: 4),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 116,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (_, _) =>
                const ShimmerBox(width: 140, height: 116, borderRadius: 12),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const ShimmerBox(height: 14, width: 120, borderRadius: 4),
        const SizedBox(height: AppSpacing.xs),
        const ShimmerBox(height: 140, borderRadius: 12),
      ],
    );
  }
}
