import 'package:decimal/decimal.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/helpers/currency_formatter.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_paths.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';
import 'package:qeema/core/widgets/percent_change_badge.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';

class AssetListItem extends StatelessWidget {
  const AssetListItem({super.key, required this.asset});

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final currencyFormat = NumberFormat.currency(
      locale: locale,
      symbol: '${CurrencyFormatter.currencyName('EGP')} ',
      decimalDigits: 2,
    );
    final dateFormat = DateFormat.yMMMd(locale);

    return InkWell(
      onTap: () => context.push('${RoutePaths.assets}/${asset.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              _iconForType(asset.assetType),
              size: 24,
              color: colors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _labelForType(context, asset.assetType),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateFormat.format(asset.entryDate),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormat.format(asset.currentValue ?? asset.entryValue),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                PercentChangeBadge(
                  percent: asset.gainLossPercent == null
                      ? null
                      : Decimal.parse(asset.gainLossPercent.toString()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(AssetType type) {
    switch (type) {
      case AssetType.egpCash:
        return Icons.monetization_on_outlined;
      case AssetType.usdCash:
        return Icons.attach_money_outlined;
      case AssetType.gold21:
      case AssetType.gold24:
        return Icons.circle_outlined;
    }
  }

  String _labelForType(BuildContext context, AssetType type) {
    switch (type) {
      case AssetType.egpCash:
        return context.t.assets.list.tabEgp;
      case AssetType.usdCash:
        return context.t.assets.list.tabUsd;
      case AssetType.gold21:
        return context.t.assets.list.tabGold21;
      case AssetType.gold24:
        return context.t.assets.list.tabGold24;
    }
  }
}
