import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';

class GainLossBadge extends StatelessWidget {
  const GainLossBadge({
    super.key,
    required this.value,
    required this.percentage,
  });
  final Decimal value;
  final Decimal percentage;

  @override
  Widget build(BuildContext context) {
    final isGain = value >= Decimal.zero;
    final color = isGain ? context.colors.secondary : context.colors.error;

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style:
          context.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ) ??
          const TextStyle(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isGain ? Icons.trending_up : Icons.trending_down,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              '${isGain ? '+' : ''}${value.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)',
            ),
          ],
        ),
      ),
    );
  }
}
