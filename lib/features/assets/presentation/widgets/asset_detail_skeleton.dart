import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/loading/shimmer_box.dart';
import 'package:qeema/core/animations/loading/shimmer_card.dart';
import 'package:qeema/core/animations/loading/shimmer_line.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/core/widgets/app_surface_card.dart';

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
          const _HeaderBlock(),
          const SizedBox(height: AppSpacing.sm),
          const _GainLossPill(),
          const SizedBox(height: AppSpacing.md),
          const _ChartArea(),
          const SizedBox(height: AppSpacing.md),
          const _TimelineArea(),
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
  const _HeaderBlock();

  @override
  Widget build(BuildContext context) {
    return const AppSurfaceCard(
      padding: EdgeInsets.all(AppSpacing.lg),
      borderRadius: 16,
      child: Column(
        children: [
          ShimmerBox(width: 48, height: 48, borderRadius: 24),
          SizedBox(height: AppSpacing.sm),
          ShimmerLine(width: 120, height: 32, borderRadius: 6),
          SizedBox(height: AppSpacing.xxs),
          ShimmerLine(width: 60),
          SizedBox(height: AppSpacing.md),
          ShimmerLine(width: 160, height: 28, borderRadius: 6),
        ],
      ),
    );
  }
}

class _GainLossPill extends StatelessWidget {
  const _GainLossPill();

  @override
  Widget build(BuildContext context) {
    return const AppSurfaceCard(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          ShimmerBox(width: 20, height: 20, borderRadius: 10),
          SizedBox(width: AppSpacing.sm),
          ShimmerLine(width: 100, height: 20),
          SizedBox(width: AppSpacing.sm),
          ShimmerCard(width: 60, height: 20, borderRadius: 10),
        ],
      ),
    );
  }
}

class _ChartArea extends StatelessWidget {
  const _ChartArea();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: AppSurfaceCard(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLine(width: 100),
            SizedBox(height: AppSpacing.sm),
            ShimmerCard(height: 120, borderRadius: 8),
          ],
        ),
      ),
    );
  }
}

class _TimelineArea extends StatelessWidget {
  const _TimelineArea();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: AppSurfaceCard(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLine(width: 100),
            SizedBox(height: AppSpacing.sm),
            _TimelineRow(),
            _TimelineRow(),
            _TimelineRow(),
          ],
        ),
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
                ShimmerLine(height: 16),
                SizedBox(height: 2),
                ShimmerLine(width: 80, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
