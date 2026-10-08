import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/helpers/currency_formatter.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_radius.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_surface_card.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';

class DashboardSummaryCard extends StatelessWidget {
  const DashboardSummaryCard({super.key, required this.summary});

  final DashboardSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;

    return AppSurfaceCard(
      padding: EdgeInsets.all(AppSpacing.lg),
      borderRadius: AppRadius.md,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.home.totalSavingsNominal.toUpperCase(),
            style: context.textTheme.titleLarge?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.xxs),
          Text(
            CurrencyFormatter.format(summary.nominalTotal),
            style: context.textTheme.headlineMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            t.home.totalSavingsReal,
            style: context.textTheme.titleLarge?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.xxs),
          Text(
            CurrencyFormatter.format(summary.realTotal),
            style: context.textTheme.titleLarge?.copyWith(
              color: colors.secondaryVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
