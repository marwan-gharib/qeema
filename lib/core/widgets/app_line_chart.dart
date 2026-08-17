import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/helpers/currency_formatter.dart';
import 'package:qeema/core/helpers/date_formatter.dart';
import 'package:qeema/core/theme/app_spacing.dart';

/// A single chartable point shared by every line chart in the app. Features
/// map their own domain entities to this shape at the call site.
typedef AppChartPoint = ({DateTime date, Decimal value});

/// A configurable `fl_chart` line chart with a themed grid, axis labels,
/// tooltip, and gradient fill.
///
/// Home's trend chart, the asset detail price chart, and the market price
/// sparkline all render through this widget; per-feature knobs (axis label
/// density, tooltip presence, bar width, y padding) are parameters, so no
/// feature re-implements chart construction.
class AppLineChart extends StatelessWidget {
  const AppLineChart({
    super.key,
    required this.points,
    required this.lineColor,
    this.showAxisLabels = true,
    this.showTooltip = true,
    this.width,
    this.height = 180,
    this.barWidth = 2,
    this.yPaddingFactor = 0.1,
    this.gridIntervalDivisor = 10,
    this.leftTitleIntervalDivisor = 7,
    this.bottomLabelCount = 5,
    this.gradientAlpha = 60,
    this.dateFormatter,
    this.valueFormatter,
  });

  final List<AppChartPoint> points;
  final Color lineColor;
  final bool showAxisLabels;
  final bool showTooltip;
  final double? width;
  final double height;
  final double barWidth;
  final double yPaddingFactor;
  final int gridIntervalDivisor;
  final int leftTitleIntervalDivisor;
  final int bottomLabelCount;
  final int gradientAlpha;
  final String Function(DateTime date)? dateFormatter;
  final String Function(Decimal value, int decimalPlaces)? valueFormatter;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final formatDate = dateFormatter ?? DateFormatter.formatShort;
    final formatValue =
        valueFormatter ??
        (Decimal value, int decimalPlaces) => CurrencyFormatter.formatCompact(
          value,
          decimalPlaces: decimalPlaces,
        );

    final spots = <FlSpot>[
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].value.toDouble()),
    ];

    var minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    var maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    if (maxY == minY) {
      minY -= 1;
      maxY += 1;
    }
    final yPadding = (maxY - minY) * yPaddingFactor;
    final yRange = maxY - minY;

    return RepaintBoundary(
      child: SizedBox(
        width: width,
        height: height,
        child: LineChart(
          LineChartData(
            gridData: showAxisLabels
                ? FlGridData(
                    show: true,
                    horizontalInterval: yRange / gridIntervalDivisor,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: colors.divider.withAlpha(50),
                      strokeWidth: 1,
                    ),
                    drawVerticalLine: false,
                  )
                : const FlGridData(show: false),
            lineTouchData: showTooltip
                ? LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => colors.surfaceAlt,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final index = spot.x.toInt();
                          if (index < 0 || index >= points.length) {
                            return null;
                          }

                          final date = formatDate(points[index].date);
                          final value = formatValue(
                            Decimal.parse(spot.y.toStringAsFixed(0)),
                            4,
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
                  )
                : const LineTouchData(enabled: false),
            titlesData: showAxisLabels
                ? FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        interval: yRange / leftTitleIntervalDivisor,
                        getTitlesWidget: (value, _) => Text(
                          formatValue(
                            Decimal.parse(value.toStringAsFixed(0)),
                            2,
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
                        interval: _calculateBottomInterval(
                          points.length,
                          bottomLabelCount,
                        ),
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index < 0 || index >= points.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              formatDate(points[index].date),
                              style: context.textTheme.bodySmall?.copyWith(
                                color: colors.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: (points.length - 1).toDouble(),
            minY: minY - yPadding,
            maxY: maxY + yPadding,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: lineColor,
                barWidth: barWidth,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      lineColor.withAlpha(gradientAlpha),
                      lineColor.withAlpha(0),
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

double _calculateBottomInterval(int pointCount, int targetLabelCount) {
  return (pointCount / targetLabelCount)
      .ceilToDouble()
      .clamp(1.0, pointCount.toDouble())
      .toDouble();
}
