import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_line_chart.dart';
import 'package:qeema/core/widgets/app_surface_card.dart';

/// A value-trend chart card shared by assets and market prices (WIDGET-3).
/// The [title] comes from the caller, localized at the call site.
class MarketPriceChart extends StatelessWidget {
  const MarketPriceChart({
    super.key,
    required this.points,
    required this.title,
  });

  final List<AppChartPoint> points;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: AppSurfaceCard(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.textTheme.labelLarge?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            AppLineChart(
              semanticsTitle: context.t.charts.semantics.priceHistory,
              points: points,
              lineColor: context.colors.secondaryVariant,
              height: 250,
              gridIntervalDivisor: 6,
              leftTitleIntervalDivisor: 2,
              bottomLabelCount: 4,
            ),
          ],
        ),
      ),
    );
  }
}
