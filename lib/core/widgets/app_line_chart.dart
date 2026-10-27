import 'dart:math' as math;

import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/helpers/currency_formatter.dart';
import 'package:qeema/core/helpers/date_formatter.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/theme/app_borders.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_chart_directionality.dart';
import 'package:qeema/core/widgets/app_line_chart_axis.dart';
import 'package:qeema/core/widgets/app_line_chart_data.dart';

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
///
/// The chart itself is always painted LTR, whatever the locale — the policy
/// lives in core and is read only by the shared chart wrapper.
/// [semanticsTitle] is what the screen-reader summary opens with, so callers
/// pass an already-localized name for what the chart shows.
///
/// The widget owns layout and assembly; axis measurement lives in
/// `app_line_chart_axis.dart` and the fl_chart data pieces in
/// `app_line_chart_data.dart` (FILE-1).
class AppLineChart extends StatelessWidget {
  const AppLineChart({
    super.key,
    required this.points,
    required this.lineColor,
    required this.semanticsTitle,
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

  /// Localized name of what this chart shows; the seed of its screen-reader
  /// summary.
  final String semanticsTitle;
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
    if (points.isEmpty) {
      return SizedBox(
        width: width == null ? null : Responsive.width(width!),
        height: Responsive.height(height),
      );
    }

    final colors = context.colors;
    final formatDate = dateFormatter ?? DateFormatter.formatShort;
    final formatValue =
        valueFormatter ??
        (Decimal value, int decimalPlaces) => CurrencyFormatter.formatCompact(
          value,
          decimalPlaces: decimalPlaces,
        );
    final chartDirection = appChartTextDirection(context);
    final textScaler = MediaQuery.textScalerOf(context);
    final labelStyle = context.textStyles.chartAxisLabel.copyWith(
      color: colors.textSecondary,
    );
    final labelGap = AppSpacing.xs;

    final spots = <FlSpot>[
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].value.toDouble()),
    ];

    var minY = spots.map((s) => s.y).reduce(math.min);
    var maxY = spots.map((s) => s.y).reduce(math.max);
    if (maxY == minY) {
      minY -= 1;
      maxY += 1;
    }
    final yRange = maxY - minY;
    final yPadding = yRange * yPaddingFactor;
    final axisMinY = minY - yPadding;
    final axisMaxY = maxY + yPadding;
    final leftTitleInterval = yRange / leftTitleIntervalDivisor;

    // The axis label text is built by ONE function, used both to measure the
    // label strip and to draw the labels, so they can never disagree.
    final tickFractionDigits = AppLineChartAxis.tickFractionDigits(
      leftTitleInterval,
    );
    String formatTick(double value) => formatValue(
      Decimal.parse(value.toStringAsFixed(tickFractionDigits)),
      2,
    );

    final leftTitleReservedSize = showAxisLabels
        ? AppLineChartAxis.leftTitleReservedSize(
            tickValues: AppLineChartAxis.leftTickValues(
              axisMinY: axisMinY,
              axisMaxY: axisMaxY,
              interval: leftTitleInterval,
            ),
            formatTick: formatTick,
            labelStyle: labelStyle,
            textScaler: textScaler,
            direction: chartDirection,
            labelGap: labelGap,
          )
        : 0.0;
    final bottomTitleReservedSize = showAxisLabels
        ? AppLineChartAxis.bottomTitleReservedSize(
            sampleLabel: formatDate(points.first.date),
            labelStyle: labelStyle,
            textScaler: textScaler,
            direction: chartDirection,
            labelGap: labelGap,
          )
        : 0.0;
    final semanticsLabel = chartSemanticsLabel(
      context: context,
      points: points,
      semanticsTitle: semanticsTitle,
      formatValue: formatValue,
    );

    return RepaintBoundary(
      child: SizedBox(
        width: width == null ? null : Responsive.width(width!),
        height: Responsive.height(height),
        child: AppChartDirectionality(
          semanticsLabel: semanticsLabel,
          child: LineChart(
            LineChartData(
              gridData: showAxisLabels
                  ? FlGridData(
                      show: true,
                      horizontalInterval: yRange / gridIntervalDivisor,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: colors.divider.withAlpha(50),
                        strokeWidth: AppBorders.hairline,
                      ),
                      drawVerticalLine: false,
                    )
                  : const FlGridData(show: false),
              lineTouchData: showTooltip
                  ? chartTouchData(
                      context: context,
                      points: points,
                      tooltipColor: colors.surfaceAlt,
                      formatDate: formatDate,
                      formatValue: formatValue,
                    )
                  : const LineTouchData(enabled: false),
              titlesData: showAxisLabels
                  ? chartTitlesData(
                      points: points,
                      bottomLabelCount: bottomLabelCount,
                      leftTitleInterval: leftTitleInterval,
                      leftTitleReservedSize: leftTitleReservedSize,
                      bottomTitleReservedSize: bottomTitleReservedSize,
                      formatTick: formatTick,
                      formatDate: formatDate,
                      labelStyle: labelStyle,
                      labelGap: labelGap,
                    )
                  : const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              minX: 0,
              // A single point would make minX == maxX, which the chart
              // cannot map to a width.
              maxX: math.max(points.length - 1, 1).toDouble(),
              minY: axisMinY,
              maxY: axisMaxY,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  // A smoothed curve can overshoot the real highs and lows,
                  // which misreports prices.
                  preventCurveOverShooting: true,
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
      ),
    );
  }
}
