import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_line_chart.dart';
import 'package:qeema/core/widgets/app_surface_card.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';

class MarketPriceChart extends StatelessWidget {
  const MarketPriceChart({super.key, required this.priceHistory});

  final List<MarketPriceEntity> priceHistory;

  @override
  Widget build(BuildContext context) {
    final t = context.t.assets;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: AppSurfaceCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.detail.valueTrend,
              style: context.textTheme.labelLarge?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppLineChart(
              points: [
                for (final point in priceHistory)
                  (date: point.priceDate, value: point.price),
              ],
              lineColor: context.colors.secondaryVariant,
              height: 250,
              gridIntervalDivisor: 6,
              leftTitleIntervalDivisor: 3,
              bottomLabelCount: 4,
            ),
          ],
        ),
      ),
    );
  }
}
