import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/loading/shimmer_box.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_colors.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_button.dart';

class AssetDetailSkeleton extends StatelessWidget {
  const AssetDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeaderBlock(colors),
          const SizedBox(height: AppSpacing.sm),
          _GainLossPill(colors),
          const SizedBox(height: AppSpacing.md),
          _ChartArea(colors),
          const SizedBox(height: AppSpacing.md),
          _TimelineArea(colors),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: t.assets.detail.edit,
                  isOutline: true,
                  onPressed: null,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: t.core.actions.delete,
                  backgroundColor: colors.error,
                  onPressed: null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _HeaderBlock extends StatelessWidget {
  const _HeaderBlock(this.colors);
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          ShimmerBox(width: 48, height: 48, borderRadius: 24),
          SizedBox(height: AppSpacing.sm),
          ShimmerBox(width: 120, height: 32, borderRadius: 6),
          SizedBox(height: AppSpacing.xxs),
          ShimmerBox(width: 60, height: 14, borderRadius: 4),
          SizedBox(height: AppSpacing.md),
          ShimmerBox(width: 160, height: 28, borderRadius: 6),
        ],
      ),
    );
  }
}

class _GainLossPill extends StatelessWidget {
  const _GainLossPill(this.colors);
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          ShimmerBox(width: 20, height: 20, borderRadius: 10),
          SizedBox(width: AppSpacing.sm),
          ShimmerBox(width: 100, height: 20, borderRadius: 4),
          SizedBox(width: AppSpacing.sm),
          ShimmerBox(width: 60, height: 20, borderRadius: 10),
        ],
      ),
    );
  }
}

class _ChartArea extends StatelessWidget {
  const _ChartArea(this.colors);
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 100, height: 14, borderRadius: 4),
          SizedBox(height: AppSpacing.sm),
          ShimmerBox(height: 120, borderRadius: 8),
        ],
      ),
    );
  }
}

class _TimelineArea extends StatelessWidget {
  const _TimelineArea(this.colors);
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 100, height: 14, borderRadius: 4),
          SizedBox(height: AppSpacing.sm),
          _TimelineRow(),
          _TimelineRow(),
          _TimelineRow(),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2),
            child: ShimmerBox(width: 20, height: 20, borderRadius: 10),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 16, borderRadius: 4),
                SizedBox(height: 2),
                ShimmerBox(width: 80, height: 12, borderRadius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
