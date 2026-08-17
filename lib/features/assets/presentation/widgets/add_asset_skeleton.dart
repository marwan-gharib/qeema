import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/loading/shimmer_card.dart';
import 'package:qeema/core/animations/loading/shimmer_line.dart';
import 'package:qeema/core/theme/app_spacing.dart';

class AddAssetSkeleton extends StatelessWidget {
  const AddAssetSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLine(width: 120),
          SizedBox(height: AppSpacing.md),
          ShimmerCard(height: 56),
          SizedBox(height: AppSpacing.lg),
          ShimmerCard(height: 56),
          SizedBox(height: AppSpacing.md),
          ShimmerCard(height: 56),
          SizedBox(height: AppSpacing.md),
          ShimmerCard(height: 56),
          SizedBox(height: AppSpacing.md),
          ShimmerCard(height: 56),
          SizedBox(height: AppSpacing.lg),
          ShimmerCard(height: 48),
          SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
