import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/helpers/currency_formatter.dart';
import 'package:qeema/core/helpers/date_formatter.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/home/domain/entities/portfolio_snapshot_entity.dart';

class RealValueTrendChart extends StatelessWidget {
  const RealValueTrendChart({super.key, required this.trendData});

  final List<PortfolioSnapshotEntity> trendData;

  @override
  Widget build(BuildContext context) {
    if (trendData.length < 2) {
      return const _NotEnoughData();
    }
    return _buildChart(context, trendData);
  }

  Widget _buildChart(
    BuildContext context,
    List<PortfolioSnapshotEntity> trendData,
  ) {
    final colors = context.colors;

    final spots = <FlSpot>[
      for (var i = 0; i < trendData.length; i++)
        FlSpot(i.toDouble(), trendData[i].realTotal.toDouble()),
    ];

    var minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    var maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    if (maxY == minY) {
      minY -= 1;
      maxY += 1;
    }
    final yPadding = (maxY - minY) * 0.1;

    return RepaintBoundary(
      child: SizedBox(
        height: 250,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              horizontalInterval: (maxY - minY) / 10,
              getDrawingHorizontalLine: (value) =>
                  FlLine(color: colors.divider.withAlpha(50), strokeWidth: 1),
              drawVerticalLine: false,
            ),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => colors.surfaceAlt,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final index = spot.x.toInt();
                    if (index < 0 || index >= trendData.length) return null;

                    final date = DateFormatter.formatShort(
                      trendData[index].date,
                    );
                    final value = CurrencyFormatter.formatCompact(
                      Decimal.parse(spot.y.toStringAsFixed(0)),
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
                  interval: (maxY - minY) / 7,
                  getTitlesWidget: (value, _) => Text(
                    CurrencyFormatter.formatCompact(
                      Decimal.parse(value.toStringAsFixed(0)),
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
                  interval: _calculateBottomInterval(trendData.length),
                  getTitlesWidget: (value, _) {
                    final index = value.toInt();
                    if (index < 0 || index >= trendData.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text(
                        DateFormatter.formatShort(trendData[index].date),
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
    );
  }
}

double _calculateBottomInterval(int pointCount) {
  const targetLabelCount = 5;
  return (pointCount / targetLabelCount)
      .ceilToDouble()
      .clamp(1.0, pointCount.toDouble())
      .toDouble();
}

class _NotEnoughData extends StatelessWidget {
  const _NotEnoughData();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;

    return Container(
      height: 250,
      padding: const EdgeInsets.all(AppSpacing.md),
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
              t.assets.chart.noDataTitle,
              style: context.textTheme.titleSmall?.copyWith(
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              t.assets.chart.noDataSubtitle,
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
