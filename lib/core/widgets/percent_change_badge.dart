import 'package:decimal/decimal.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/theme/app_radius.dart';
import 'package:qeema/core/theme/app_sizes.dart';
import 'package:qeema/core/theme/app_spacing.dart';

/// A small signed-percentage pill (arrow + tinted background), green for a
/// gain and terracotta for a loss. A `null` percent renders a muted dash for
/// insufficient-history states.
class PercentChangeBadge extends StatelessWidget {
  const PercentChangeBadge({super.key, this.percent});

  final Decimal? percent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final percent = this.percent;
    if (percent == null) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxxs,
        ),
        decoration: BoxDecoration(
          color: colors.divider.withAlpha(40),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          '—',
          style: context.textTheme.labelSmall?.copyWith(
            color: colors.textSecondary,
          ),
        ),
      );
    }

    final isGain = percent >= Decimal.zero;
    final color = isGain ? colors.secondaryVariant : colors.error;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxxs,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(38),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isGain ? Icons.arrow_upward : Icons.arrow_downward,
            size: AppSizes.iconMicro,
            color: color,
          ),
          SizedBox(width: AppSpacing.xxxs),
          Text(
            '${percent.toStringAsFixed(1)}%',
            style: context.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
