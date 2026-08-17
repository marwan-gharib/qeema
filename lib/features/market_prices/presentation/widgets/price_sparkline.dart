import 'package:decimal/decimal.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/widgets/app_line_chart.dart';

/// Tiny axis-less sparkline for a price card. Glanceable visual cue only:
/// no grid, no titles, no touch interaction — the interactive chart lives on
/// the detail screen.
class PriceSparkline extends StatelessWidget {
  const PriceSparkline({
    super.key,
    required this.points,
    required this.isGain,
    this.width = 40,
    this.height = 44,
  });

  final List<(DateTime, Decimal)> points;
  final bool isGain;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) return const SizedBox.shrink();

    return AppLineChart(
      points: [for (final point in points) (date: point.$1, value: point.$2)],
      lineColor: isGain
          ? context.colors.secondaryVariant
          : context.colors.error,
      showAxisLabels: false,
      showTooltip: false,
      width: width,
      height: height,
      barWidth: 1.6,
      yPaddingFactor: 0.15,
      gradientAlpha: 55,
    );
  }
}
