import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/helpers/chart_axis_helpers.dart';
import 'package:qeema/core/helpers/currency_formatter.dart';
import 'package:qeema/core/helpers/date_formatter.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';

class MarketPriceChart extends StatelessWidget {
  const MarketPriceChart({super.key, required this.priceHistory});

  final List<MarketPriceEntity> priceHistory;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t.assets;

    final spots = <FlSpot>[
      for (var i = 0; i < priceHistory.length; i++)
        FlSpot(i.toDouble(), priceHistory[i].price.toDouble()),
    ];

    var minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    var maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    if (maxY == minY) {
      minY -= 1;
      maxY += 1;
    }
    final yPadding = (maxY - minY) * 0.1;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.detail.valueTrend,
            style: context.textTheme.labelLarge?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          RepaintBoundary(
            child: SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: (maxY - minY) / 6,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: colors.divider.withAlpha(50),
                      strokeWidth: 1,
                    ),
                    drawVerticalLine: false,
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => colors.surfaceAlt,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final index = spot.x.toInt();
                          if (index < 0 || index >= priceHistory.length) {
                            return null;
                          }

                          final date = DateFormatter.formatShort(
                            priceHistory[index].priceDate,
                          );
                          final value = CurrencyFormatter.formatCompact(
                            Decimal.parse(spot.y.toStringAsFixed(0)),
                            decimalPlaces: 4,
                          );

                          return LineTooltipItem(
                            '$date\n',
                            context.textTheme.bodySmall!.copyWith(
                              color: colors.textSecondary,
                              fontSize: 10,
                            ),
                            children: [
                              TextSpan(
                                text: value,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        interval: (maxY - minY) / 3,
                        getTitlesWidget: (value, _) => Text(
                          CurrencyFormatter.formatCompact(
                            Decimal.parse(value.toStringAsFixed(0)),
                            decimalPlaces: 2,
                          ),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: calculateBottomInterval(priceHistory.length),
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index < 0 || index >= priceHistory.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              DateFormatter.formatShort(
                                priceHistory[index].priceDate,
                              ),
                              style: context.textTheme.bodySmall?.copyWith(
                                color: colors.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: minY - yPadding,
                  maxY: maxY + yPadding,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: colors.secondaryVariant,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            colors.secondaryVariant.withAlpha(60),
                            colors.secondaryVariant.withAlpha(0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
