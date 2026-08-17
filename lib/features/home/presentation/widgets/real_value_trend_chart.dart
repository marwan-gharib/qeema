import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_empty_state.dart';
import 'package:qeema/core/widgets/app_line_chart.dart';
import 'package:qeema/features/home/domain/entities/portfolio_snapshot_entity.dart';

class RealValueTrendChart extends StatelessWidget {
  const RealValueTrendChart({super.key, required this.trendData});

  final List<PortfolioSnapshotEntity> trendData;

  @override
  Widget build(BuildContext context) {
    if (trendData.length < 2) {
      final t = context.t.assets.chart;
      return AppEmptyState(
        icon: Icons.show_chart,
        title: t.noDataTitle,
        subtitle: t.noDataSubtitle,
        container: true,
        height: 250,
        padding: const EdgeInsets.all(AppSpacing.md),
      );
    }

    return AppLineChart(
      points: [
        for (final snapshot in trendData)
          (date: snapshot.date, value: snapshot.realTotal),
      ],
      lineColor: context.colors.secondaryVariant,
      height: 250,
    );
  }
}
