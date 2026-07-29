import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';
import 'package:qeema/features/home/domain/entities/portfolio_snapshot_entity.dart';

class RealValueTrendChart extends StatelessWidget {
  const RealValueTrendChart({super.key, required this.trendData});

  final List<PortfolioSnapshotEntity> trendData;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final t = context.t;

    if (trendData.length < 2) {
      return SizedBox(
        height: 140,
        child: Center(
          child: Text(
            t.home.notEnoughTrendData,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.textSecondary),
          ),
        ),
      );
    }

    final spots = trendData.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.realTotal);
    }).toList();

    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final yPadding = (maxY - minY) * 0.1;

    return RepaintBoundary(
      child: SizedBox(
        height: 140,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              horizontalInterval: (maxY - minY) / 4,
              getDrawingHorizontalLine: (value) =>
                  FlLine(color: colors.divider.withAlpha(30), strokeWidth: 1),
              drawVerticalLine: false,
            ),
            titlesData: const FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
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
            lineTouchData: const LineTouchData(enabled: false),
          ),
        ),
      ),
    );
  }
}
