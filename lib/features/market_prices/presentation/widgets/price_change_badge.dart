import 'package:decimal/decimal.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';

/// Sibling to the assets feature's `GainLossBadge`, sharing its visual
/// language (arrow + tinted pill) but accepting a `Decimal?` percent so an
/// insufficient-history state can render a muted dash instead.
class PriceChangeBadge extends StatelessWidget {
  const PriceChangeBadge({super.key, this.percent});

  final Decimal? percent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final percent = this.percent;
    if (percent == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: colors.divider.withAlpha(40),
          borderRadius: BorderRadius.circular(12),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(38),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isGain ? Icons.arrow_upward : Icons.arrow_downward,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 2),
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
