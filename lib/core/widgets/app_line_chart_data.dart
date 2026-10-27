import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/widgets/app_chart_directionality.dart';
import 'package:qeema/core/widgets/app_line_chart.dart';
import 'package:qeema/core/widgets/app_line_chart_axis.dart';

/// The `fl_chart` data pieces of `AppLineChart`, split out of the widget file
/// for FILE-1. `AppLineChart` assembles them; nothing here builds layout.

/// Axis labels: y-axis values via [formatTick], x-axis dates via [formatDate].
/// The reserved strips come from `AppLineChartAxis`, measured from the same
/// text drawn here.
FlTitlesData chartTitlesData({
  required List<AppChartPoint> points,
  required int bottomLabelCount,
  required double leftTitleInterval,
  required double leftTitleReservedSize,
  required double bottomTitleReservedSize,
  required String Function(double value) formatTick,
  required String Function(DateTime date) formatDate,
  required TextStyle labelStyle,
  required double labelGap,
}) {
  return FlTitlesData(
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: leftTitleReservedSize,
        interval: leftTitleInterval,
        getTitlesWidget: (value, _) => Padding(
          // Inside the forced-LTR chart, `end` is the side facing the plot.
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
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: bottomTitleReservedSize,
        interval: AppLineChartAxis.bottomInterval(
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
  );
}

/// The touch tooltip: the date in the muted label style, the exact decimal
/// value (not the plotted double rounded to a whole number) beneath it.
///
/// The painter clips to the chart rect, so an unclamped tooltip read off an
/// edge point would be unreadable — hence fitting inside both axes.
///
/// The tooltip text direction comes from the same policy function the shared
/// wrapper uses, so it can never disagree with the chart.
LineTouchData chartTouchData({
  required BuildContext context,
  required List<AppChartPoint> points,
  required Color tooltipColor,
  required String Function(DateTime date) formatDate,
  required String Function(Decimal value, int decimalPlaces) formatValue,
}) {
  final colors = context.colors;
  final direction = appChartTextDirection(context);
  return LineTouchData(
    touchTooltipData: LineTouchTooltipData(
      getTooltipColor: (touchedSpot) => tooltipColor,
      fitInsideHorizontally: true,
      fitInsideVertically: true,
      getTooltipItems: (touchedSpots) {
        return touchedSpots.map((spot) {
          final index = spot.x.round();
          if (index < 0 || index >= points.length) {
            return null;
          }

          final date = formatDate(points[index].date);
          final value = formatValue(points[index].value, 4);

          return LineTooltipItem(
            '$date\n',
            context.textStyles.chartAxisLabel.copyWith(
              color: colors.textSecondary,
            ),
            textDirection: direction,
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
  );
}

/// What the chart means to a screen reader: its localized name, the period it
/// covers as a day count, and its latest/lowest/highest values — formatted
/// with the very formatters the axis and tooltip use, so the spoken summary
/// never disagrees with the drawn one. The period is a day count rather than a
/// date range so this never needs `DateFormat` locale data: charts without
/// axis labels (the sparkline) must not start requiring it.
String chartSemanticsLabel({
  required BuildContext context,
  required List<AppChartPoint> points,
  required String semanticsTitle,
  required String Function(Decimal value, int decimalPlaces) formatValue,
}) {
  var lowest = points.first.value;
  var highest = points.first.value;
  for (final point in points) {
    if (point.value.compareTo(lowest) < 0) lowest = point.value;
    if (point.value.compareTo(highest) > 0) highest = point.value;
  }
  return context.t.charts.semantics.summary(
    n: AppLineChartAxis.spanInDays(points.first.date, points.last.date),
    title: semanticsTitle,
    latest: formatValue(points.last.value, 2),
    lowest: formatValue(lowest, 2),
    highest: formatValue(highest, 2),
  );
}
