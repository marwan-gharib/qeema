import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/loading/shimmer_box.dart';
import 'package:qeema/core/animations/loading/shimmer_card.dart';
import 'package:qeema/core/animations/loading/shimmer_line.dart';
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
      padding: const EdgeInsets.all(AppSpacing.md),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, _) => const AppSurfaceCard(
        padding: EdgeInsets.all(AppSpacing.md),
        borderRadius: 16,
        child: Row(
          children: [
            ShimmerBox(width: 32, height: 32, borderRadius: 16),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLine(width: 110, height: 16, borderRadius: 8),
                  SizedBox(height: 2),
                  ShimmerLine(width: 90, height: 20, borderRadius: 8),
                  SizedBox(height: 2),
                  ShimmerLine(width: 130, height: 12, borderRadius: 8),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ShimmerCard(width: 40, height: 44, borderRadius: 6),
                SizedBox(height: 6),
                ShimmerCard(width: 64, height: 20, borderRadius: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
