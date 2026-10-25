import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/loading/shimmer_box.dart';
import 'package:qeema/core/animations/loading/shimmer_card.dart';
import 'package:qeema/core/animations/loading/shimmer_line.dart';
import 'package:qeema/core/theme/app_radius.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_surface_card.dart';

/// Mirrors the real `MarketPriceCard` geometry exactly: same outer padding,
/// same internal row layout (icon / text column / sparkline + badge column),
/// so the skeleton swaps in at the same measured height.
class MarketPricesSkeleton extends StatelessWidget {
  const MarketPricesSkeleton({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(AppSpacing.md),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, _) => AppSurfaceCard(
        padding: EdgeInsets.all(AppSpacing.md),
        borderRadius: AppRadius.md,
        child: Row(
          children: [
            const ShimmerBox(width: 32, height: 32, borderRadius: 16),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerLine(width: 110, height: 16, borderRadius: 8),
                  SizedBox(height: AppSpacing.xxxs),
                  const ShimmerLine(width: 90, height: 20, borderRadius: 8),
                  SizedBox(height: AppSpacing.xxxs),
                  const ShimmerLine(width: 130, height: 12, borderRadius: 8),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const ShimmerCard(width: 40, height: 44, borderRadius: 6),
                SizedBox(height: AppSpacing.tight),
                const ShimmerCard(width: 64, height: 20, borderRadius: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
