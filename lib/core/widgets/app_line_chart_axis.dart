import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/responsive/responsive.dart';

/// Axis measurement and chart geometry helpers for `AppLineChart`, split out
/// of the widget file for FILE-1. Every value is measured with the very
/// formatter, style, text scale and gap the chart draws with, so labels and
/// their reserved strip can never disagree.
class AppLineChartAxis {
  const AppLineChartAxis._();

  /// Design-unit fallback and safety cap for the y-axis label strip. The strip
  /// itself is measured from the labels about to be drawn.
  static const double _fallbackLeftStrip = 44;
  static const double _maxLeftStrip = 120;

  /// Upper bound on how many ticks are measured (a guard against a degenerate
  /// interval, not a limit the chart normally reaches).
  static const int _maxMeasuredTicks = 200;

  /// Width of the y-axis label strip, measured from the real label text.
  ///
  /// The measurement uses the same formatter, style, text scale and gap as the
  /// labels that are drawn, so a label never wraps, clips or collides with the
  /// plot. Measured widths are already real pixels, so they are NOT passed
  /// through the responsive scaler again; only the design-unit fallback and cap
  /// are scaled.
  static double leftTitleReservedSize({
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
  static double bottomTitleReservedSize({
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
  static List<double> leftTickValues({
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
  static int tickFractionDigits(double interval) {
    if (!interval.isFinite || interval <= 0 || interval >= 1) return 0;
    return (-math.log(interval) / math.ln10).ceil().clamp(0, 4);
  }

  /// Calendar days covered, inclusive. Compared as UTC dates so a daylight
  /// saving change inside the range cannot shift the count by one.
  static int spanInDays(DateTime first, DateTime last) {
    final start = DateTime.utc(first.year, first.month, first.day);
    final end = DateTime.utc(last.year, last.month, last.day);
    return math.max(end.difference(start).inDays + 1, 1);
  }

  /// Interval between x-axis labels so at most [targetLabelCount] are drawn.
  static double bottomInterval(int pointCount, int targetLabelCount) {
    return (pointCount / targetLabelCount)
        .ceilToDouble()
        .clamp(1.0, pointCount.toDouble())
        .toDouble();
  }

  static Size _measureText(
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
}
