import 'package:flutter/material.dart';
import 'package:qeema/core/animations/loading/shimmer_box.dart';
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
          ShimmerBox(height: 14, width: 120, borderRadius: 4),
          SizedBox(height: AppSpacing.md),
          ShimmerBox(height: 56, borderRadius: 12),
          SizedBox(height: AppSpacing.lg),
          ShimmerBox(height: 56, borderRadius: 12),
          SizedBox(height: AppSpacing.md),
          ShimmerBox(height: 56, borderRadius: 12),
          SizedBox(height: AppSpacing.md),
          ShimmerBox(height: 56, borderRadius: 12),
          SizedBox(height: AppSpacing.md),
          ShimmerBox(height: 56, borderRadius: 12),
          SizedBox(height: AppSpacing.lg),
          ShimmerBox(height: 48, borderRadius: 12),
          SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
