import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/helpers/currency_formatter.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/core/theme/app_radius.dart';
import 'package:qeema/core/theme/app_sizes.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_surface_card.dart';
import 'package:qeema/core/widgets/percent_change_badge.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_type_tile.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_summary_entity.dart';
import 'package:qeema/features/market_prices/presentation/widgets/price_sparkline.dart';
import 'package:qeema/features/market_prices/presentation/widgets/stale_data_indicator.dart';

class MarketPriceCard extends StatelessWidget {
  const MarketPriceCard({super.key, required this.summary});

  final MarketPriceSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t.marketPrices;
    final type = summary.assetType;

    return AppSurfaceCard(
      padding: EdgeInsets.all(AppSpacing.md),
      borderRadius: AppRadius.md,
      onTap: () => context.pushNamed(
        RouteNames.marketPriceDetail,
        pathParameters: {'typeId': type.id},
      ),
      child: Row(
        children: [
          _TypeIcon(code: type.code),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.assetTypeName(type.code),
                  style: context.textTheme.labelLarge?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.xxxs),
                Text(
                  summary.todayPrice == null
                      ? '—'
                      : CurrencyFormatter.format(
                          summary.todayPrice!,
                          decimalPlaces: 2,
                        ),
                  style: context.textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.xxxs),
                summary.hasHistory
                    ? StaleDataIndicator(
                        fetchedAt: summary.fetchedAt!,
                        isStale: summary.isStale,
                      )
                    : Text(
                        t.notEnoughHistory,
                        style: context.textStyles.footnote.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (summary.hasHistory)
                PriceSparkline(
                  points: [
                    for (final p in summary.sparklinePoints) (p.date, p.price),
                  ],
                  isGain: summary.isGain,
                ),
              SizedBox(height: AppSpacing.tight),
              PercentChangeBadge(percent: summary.weeklyChangePercent),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          AssetTypeTile.iconForType(code),
          size: AppSizes.iconXl,
          color: colors.textPrimary,
        ),
        if (code.startsWith('gold_'))
          Positioned(
            right: Responsive.width(-10),
            top: Responsive.height(-6),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xxs,
                vertical: Responsive.adapt(1),
              ),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(AppRadius.xxs),
              ),
              child: Text(
                code == 'gold_21'
                    ? context.t.assets.carat.k21
                    : context.t.assets.carat.k24,
                style: context.textStyles.caratBadge.copyWith(
                  color: colors.onPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
