import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/home/domain/entities/asset_type_summary_entity.dart';

class AssetTypeMiniCard extends StatelessWidget {
  const AssetTypeMiniCard({super.key, required this.summary});

  final AssetTypeSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final t = context.t;
    final currencyFormat = NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      symbol: '',
      decimalDigits: 0,
    );

    final label = switch (summary.assetType) {
      AssetType.egpCash => t.assets.list.tabEgp,
      AssetType.usdCash => t.assets.list.tabUsd,
      AssetType.gold21 => t.assets.list.tabGold21,
      AssetType.gold24 => t.assets.list.tabGold24,
    };

    final icon = switch (summary.assetType) {
      AssetType.egpCash => Icons.monetization_on_outlined,
      AssetType.usdCash => Icons.attach_money_outlined,
      AssetType.gold21 => Icons.star_outline,
      AssetType.gold24 => Icons.star,
    };

    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: colors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: colors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            currencyFormat.format(summary.currentValue),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          _DayChangeBadge(
            dayChangePercent: summary.dayChangePercent,
            isGain: summary.isDayGain,
          ),
        ],
      ),
    );
  }
}

class _DayChangeBadge extends StatelessWidget {
  const _DayChangeBadge({required this.dayChangePercent, required this.isGain});

  final double dayChangePercent;
  final bool isGain;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final bgColor = isGain ? colors.secondaryVariant : colors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor.withAlpha(38),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isGain ? Icons.arrow_upward : Icons.arrow_downward,
            size: 12,
            color: bgColor,
          ),
          const SizedBox(width: 2),
          Text(
            '${dayChangePercent.abs().toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: bgColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
