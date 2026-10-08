import 'dart:math' as math;

import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/helpers/currency_formatter.dart';
import 'package:qeema/core/helpers/date_formatter.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/theme/app_borders.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_chart_directionality.dart';

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
    final tickFractionDigits = _tickFractionDigits(leftTitleInterval);
    String formatTick(double value) => formatValue(
      Decimal.parse(value.toStringAsFixed(tickFractionDigits)),
      2,
    );

    final leftTitleReservedSize = showAxisLabels
        ? _leftTitleReservedSize(
            tickValues: _leftTickValues(
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
        ? _bottomTitleReservedSize(
            sampleLabel: formatDate(points.first.date),
            labelStyle: labelStyle,
            textScaler: textScaler,
            direction: chartDirection,
            labelGap: labelGap,
          )
        : 0.0;
    final semanticsLabel = _semanticsLabel(
      context: context,
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
                  ? LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) => colors.surfaceAlt,
                        // The painter clips to the chart rect, so an unclamped
                        // tooltip read off an edge point would be unreadable.
                        fitInsideHorizontally: true,
                        fitInsideVertically: true,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final index = spot.x.round();
                            if (index < 0 || index >= points.length) {
                              return null;
                            }

                            final date = formatDate(points[index].date);
                            // The exact decimal, not the plotted double
                            // rounded to a whole number.
                            final value = formatValue(points[index].value, 4);

                            return LineTooltipItem(
                              '$date\n',
                              context.textStyles.chartAxisLabel.copyWith(
                                color: colors.textSecondary,
                              ),
                              textDirection: chartDirection,
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
                          reservedSize: leftTitleReservedSize,
                          interval: leftTitleInterval,
                          getTitlesWidget: (value, _) => Padding(
                            // Inside the forced-LTR chart, `end` is the side
                            // facing the plot.
                            padding: EdgeInsetsDirectional.only(end: labelGap),
                            child: Text(
                              formatTick(value),
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: labelStyle,
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
                          reservedSize: bottomTitleReservedSize,
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
                              padding: EdgeInsets.only(top: labelGap),
                              child: Text(
                                formatDate(points[index].date),
                                maxLines: 1,
                                softWrap: false,
                                style: labelStyle,
                              ),
                            );
                          },
                        ),
                      ),
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

  /// What this chart means to a screen reader: its localized name, the period
  /// it covers as a day count, and its latest/lowest/highest values — formatted
  /// with the very formatters the axis and tooltip use, so the spoken summary
  /// never disagrees with the drawn one. The period is a day count rather than a
  /// date range so this never needs `DateFormat` locale data: charts without
  /// axis labels (the sparkline) must not start requiring it.
  String _semanticsLabel({
    required BuildContext context,
    required String Function(Decimal value, int decimalPlaces) formatValue,
  }) {
    var lowest = points.first.value;
    var highest = points.first.value;
    for (final point in points) {
      if (point.value.compareTo(lowest) < 0) lowest = point.value;
      if (point.value.compareTo(highest) > 0) highest = point.value;
    }
    return context.t.charts.semantics.summary(
      n: _spanInDays(points.first.date, points.last.date),
      title: semanticsTitle,
      latest: formatValue(points.last.value, 2),
      lowest: formatValue(lowest, 2),
      highest: formatValue(highest, 2),
    );
  }
}

/// Design-unit fallback and safety cap for the y-axis label strip. The strip
/// itself is measured from the labels about to be drawn.
const double _fallbackLeftStrip = 44;
const double _maxLeftStrip = 120;

/// Upper bound on how many ticks are measured (a guard against a degenerate
/// interval, not a limit the chart normally reaches).
const int _maxMeasuredTicks = 200;

/// Width of the y-axis label strip, measured from the real label text.
///
/// The measurement uses the same formatter, style, text scale and gap as the
/// labels that are drawn, so a label never wraps, clips or collides with the
/// plot. Measured widths are already real pixels, so they are NOT passed
/// through the responsive scaler again; only the design-unit fallback and cap
/// are scaled.
double _leftTitleReservedSize({
  required List<double> tickValues,
  required String Function(double value) formatTick,
  required TextStyle labelStyle,
  required TextScaler textScaler,
  required TextDirection direction,
  required double labelGap,
}) {
  if (tickValues.isEmpty) return Responsive.adapt(_fallbackLeftStrip);

  var widest = 0.0;
  for (final value in tickValues) {
    final width = _measureText(
      formatTick(value),
      labelStyle,
      textScaler,
      direction,
    ).width;
    widest = math.max(widest, width);
  }
  return (widest + Responsive.width(15))
      .ceilToDouble()
      .clamp(labelGap, Responsive.adapt(_maxLeftStrip))
      .toDouble();
}

/// Height of the x-axis label strip: one measured text line plus its gap.
double _bottomTitleReservedSize({
  required String sampleLabel,
  required TextStyle labelStyle,
  required TextScaler textScaler,
  required TextDirection direction,
  required double labelGap,
}) {
  final height = _measureText(
    sampleLabel,
    labelStyle,
    textScaler,
    direction,
  ).height;
  return (height + labelGap).ceilToDouble();
}

/// Values the y-axis can label: the multiples of [interval] inside the range
/// plus both ends of the axis (measured conservatively, since the chart may
/// label them too).
List<double> _leftTickValues({
  required double axisMinY,
  required double axisMaxY,
  required double interval,
}) {
  if (!interval.isFinite || interval <= 0) return const <double>[];

  final values = <double>{axisMinY, axisMaxY};
  final first = (axisMinY / interval).ceil();
  final last = (axisMaxY / interval).floor();
  for (var i = first; i <= last && i - first < _maxMeasuredTicks; i++) {
    values.add(i * interval);
  }
  return values.toList();
}

/// How many fraction digits an axis label needs so neighbouring ticks stay
/// distinct. Whole numbers for intervals of 1 or more, as before.
int _tickFractionDigits(double interval) {
  if (!interval.isFinite || interval <= 0 || interval >= 1) return 0;
  return (-math.log(interval) / math.ln10).ceil().clamp(0, 4);
}

Size _measureText(
  String text,
  TextStyle style,
  TextScaler textScaler,
  TextDirection direction,
) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: direction,
    textScaler: textScaler,
    maxLines: 1,
  )..layout();
  final size = painter.size;
  painter.dispose();
  return size;
}

/// Calendar days covered, inclusive. Compared as UTC dates so a daylight-saving
/// change inside the range cannot shift the count by one.
int _spanInDays(DateTime first, DateTime last) {
  final start = DateTime.utc(first.year, first.month, first.day);
  final end = DateTime.utc(last.year, last.month, last.day);
  return math.max(end.difference(start).inDays + 1, 1);
}

double _calculateBottomInterval(int pointCount, int targetLabelCount) {
  return (pointCount / targetLabelCount)
      .ceilToDouble()
      .clamp(1.0, pointCount.toDouble())
      .toDouble();
}
