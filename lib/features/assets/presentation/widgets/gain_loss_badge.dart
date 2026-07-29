import 'package:flutter/material.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';

class GainLossBadge extends StatelessWidget {
  const GainLossBadge({super.key, this.gainLossPercent, this.gainLossAmount});

  final double? gainLossPercent;
  final double? gainLossAmount;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    if (gainLossPercent == null || gainLossAmount == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: colors.divider.withAlpha(40),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '—',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: colors.textSecondary),
        ),
      );
    }

    final isGain = gainLossAmount! >= 0;
    final bgColor = isGain ? colors.secondaryVariant : colors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor.withAlpha(38),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isGain ? Icons.arrow_upward : Icons.arrow_downward,
            size: 12,
            color: bgColor,
          ),
          const SizedBox(width: 2),
          Text(
            '${gainLossPercent!.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: bgColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
