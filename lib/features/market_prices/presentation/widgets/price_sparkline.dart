import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';

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

    final colors = context.colors;
    final color = isGain ? colors.secondaryVariant : colors.error;
    final spots = [
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].$2.toDouble()),
    ];
    var minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    var maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    if (maxY == minY) {
      minY -= 1;
      maxY += 1;
    }
    final yPadding = (maxY - minY) * 0.15;

    return SizedBox(
      width: width,
      height: height,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          minX: 0,
          maxX: (points.length - 1).toDouble(),
          minY: minY - yPadding,
          maxY: maxY + yPadding,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: color,
              barWidth: 1.6,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.withAlpha(55), color.withAlpha(0)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
