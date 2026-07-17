import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import 'shimmer_box.dart';

/// A ready-made list of [ShimmerBox]es shaped like a typical asset row,
/// for use as the loading state on list-based screens.
class ShimmerListPlaceholder extends StatelessWidget {
  final int itemCount;

  const ShimmerListPlaceholder({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, _) => const Row(
        children: [
          ShimmerBox(width: 48, height: 48, borderRadius: 24),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 14),
                SizedBox(height: AppSpacing.xxs),
                ShimmerBox(width: 80, height: 12),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          ShimmerBox(width: 72, height: 14),
        ],
      ),
    );
  }
}
