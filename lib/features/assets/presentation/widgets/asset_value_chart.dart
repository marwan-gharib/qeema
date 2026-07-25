import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';

class AssetValueChart extends StatelessWidget {
  const AssetValueChart({super.key, required this.asset, this.priceHistory});

  final AssetEntity asset;
  final List<double>? priceHistory;

  @override
  Widget build(BuildContext context) {
    final t = context.t.assets;
    final colors = context.colors;

    if (asset.assetType == AssetType.egpCash) {
      return _CashFlatChart(asset: asset);
    }

    if (priceHistory == null || priceHistory!.length < 2) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              Icons.show_chart,
              size: 48,
              color: colors.textSecondary.withAlpha(100),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              t.chart.noDataTitle,
              style: context.textTheme.titleSmall?.copyWith(
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              t.chart.noDataSubtitle,
              style: context.textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return _LineChart(priceHistory: priceHistory!);
  }
}

class _CashFlatChart extends StatelessWidget {
  const _CashFlatChart({required this.asset});

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t.assets;

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
          SizedBox(
            height: 100,
            child: CustomPaint(
              size: const Size(double.infinity, 100),
              painter: _FlatLinePainter(lineColor: colors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            t.chart.cashPlaceholder,
            style: context.textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlatLinePainter extends CustomPainter {
  const _FlatLinePainter({required this.lineColor});
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_FlatLinePainter old) => old.lineColor != lineColor;
}

class _LineChart extends StatelessWidget {
  const _LineChart({required this.priceHistory});
  final List<double> priceHistory;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t.assets;

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
          SizedBox(
            height: 120,
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: _LineChartPainter(
                data: priceHistory,
                lineColor: colors.secondaryVariant,
                fillColor: colors.secondaryVariant.withAlpha(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter({
    required this.data,
    required this.lineColor,
    required this.fillColor,
  });

  final List<double> data;
  final Color lineColor;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final min = data.reduce(math.min);
    final max = data.reduce(math.max);
    final range = (max - min).clamp(0.001, double.infinity);
    final padding = size.height * 0.1;
    final chartH = size.height - 2 * padding;

    final points = <Offset>[];
    for (var i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = padding + chartH - ((data[i] - min) / range) * chartH;
      points.add(Offset(x, y));
    }

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, padding + chartH)
      ..lineTo(points.first.dx, padding + chartH)
      ..close();

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(_LineChartPainter old) =>
      old.data != data ||
      old.lineColor != lineColor ||
      old.fillColor != fillColor;
}
