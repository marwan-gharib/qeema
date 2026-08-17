import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/loading/shimmer_box.dart';
import 'package:qeema/core/animations/loading/shimmer_card.dart';
import 'package:qeema/core/animations/loading/shimmer_line.dart';
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
        const ShimmerCard(height: 160, borderRadius: 16),
        const SizedBox(height: AppSpacing.lg),
        const Center(
          child: Column(
            children: [
              ShimmerBox(width: 120, height: 120, borderRadius: 60),
              SizedBox(height: AppSpacing.xs),
              ShimmerLine(width: 180, height: 16),
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
            itemBuilder: (_, _) => const ShimmerCard(width: 140, height: 116),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const ShimmerLine(width: 120),
        const SizedBox(height: AppSpacing.xs),
        const ShimmerCard(),
      ],
    );
  }
}
