import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/loading/shimmer_box.dart';
import 'package:qeema/core/animations/loading/shimmer_card.dart';
import 'package:qeema/core/animations/loading/shimmer_line.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/theme/app_spacing.dart';

/// Skeleton placeholder mirroring the loaded dashboard's exact section
/// dimensions: summary card (~160), ring block (~144), mini-card row (116),
/// and the trend chart block (~164).
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        Responsive.height(80),
      ),
      children: [
        const ShimmerCard(height: 160, borderRadius: 16),
        SizedBox(height: AppSpacing.lg),
        Center(
          child: Column(
            children: [
              const ShimmerBox(width: 120, height: 120, borderRadius: 60),
              SizedBox(height: AppSpacing.xs),
              const ShimmerLine(width: 180, height: 16),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: Responsive.height(116),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm),
            itemBuilder: (_, _) => const ShimmerCard(width: 140, height: 116),
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        const ShimmerLine(width: 120),
        SizedBox(height: AppSpacing.xs),
        const ShimmerCard(),
      ],
    );
  }
}
