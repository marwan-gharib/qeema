import 'package:flutter/material.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';

class ChartNotEnoughData extends StatelessWidget {
  const ChartNotEnoughData({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t.assets;

    return Container(
      height: 250,
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.show_chart,
              size: 48,
              color: colors.textSecondary.withAlpha(100),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              t.chart.noDataTitle,
              style: context.textTheme.titleSmall?.copyWith(
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              t.chart.noDataSubtitle,
              style: context.textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
