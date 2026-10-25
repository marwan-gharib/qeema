import 'package:decimal/decimal.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/helpers/currency_formatter.dart';
import 'package:qeema/core/helpers/date_formatter.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_surface_card.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';

class CashFlatChart extends StatelessWidget {
  const CashFlatChart({super.key, required this.asset});

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t.assets;

    final today = DateTime.now();
    final startDate = asset.entryDate.isAfter(today) ? today : asset.entryDate;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: AppSurfaceCard(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.detail.valueTrend,
              style: context.textTheme.labelLarge?.copyWith(
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              CurrencyFormatter.format(
                Decimal.parse(asset.entryValue.toStringAsFixed(0)),
              ),
              style: context.textTheme.headlineSmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: Responsive.height(48),
              child: CustomPaint(
                size: Size(double.infinity, Responsive.height(48)),
                painter: _FlatLinePainter(
                  lineColor: colors.primary,
                  dotColor: colors.primary,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormatter.formatShort(startDate),
                  style: context.textStyles.chartAxisLabel.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                Text(
                  DateFormatter.formatShort(today),
                  style: context.textStyles.chartAxisLabel.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              t.chart.cashPlaceholder,
              style: context.textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlatLinePainter extends CustomPainter {
  const _FlatLinePainter({required this.lineColor, required this.dotColor});

  final Color lineColor;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final midY = size.height / 2;

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(0, midY), Offset(size.width, midY), linePaint);

    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(0, midY), 4, dotPaint);
    canvas.drawCircle(Offset(size.width, midY), 4, dotPaint);
  }

  @override
  bool shouldRepaint(_FlatLinePainter old) =>
      old.lineColor != lineColor || old.dotColor != dotColor;
}
