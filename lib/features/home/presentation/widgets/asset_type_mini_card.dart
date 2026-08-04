import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:qeema/core/animations/app_animated_entry.dart';
import 'package:qeema/core/animations/app_motion.dart';
import 'package:qeema/core/animations/entry_animation_type.dart';
import 'package:qeema/core/animations/micro_interactions/tap_scale.dart';
import 'package:qeema/core/constants/asset_type_codes.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/helpers/currency_formatter.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/home/domain/entities/asset_type_summary_entity.dart';

class AssetTypeMiniCardRow extends StatelessWidget {
  const AssetTypeMiniCardRow({super.key, required this.summaries});

  final List<AssetTypeSummaryEntity> summaries;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: summaries.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) => AppAnimatedEntry(
          type: EntryAnimationType.fadeSlideUp,
          delay: Duration(
            milliseconds: (index * AppMotion.staggerStep.inMilliseconds).clamp(
              0,
              AppMotion.maxStaggerTotal.inMilliseconds,
            ),
          ),
          child: AssetTypeMiniCard(summary: summaries[index]),
        ),
      ),
    );
  }
}

class AssetTypeMiniCard extends StatelessWidget {
  const AssetTypeMiniCard({super.key, required this.summary});

  final AssetTypeSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TapScale(
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _iconFor(summary.assetType),
                  size: 16,
                  color: colors.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _labelFor(context, summary.assetType),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              CurrencyFormatter.format(
                summary.currentValue,
                symbol: '',
                decimalPlaces: 0,
              ),
              style: context.textTheme.titleSmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xxs),
            _DayChangeIndicator(summary: summary),
          ],
        ),
      ),
    );
  }

  String _labelFor(BuildContext context, AssetTypeEntity type) {
    final t = context.t.assets.list;
    return switch (type.code) {
      AssetTypeCodes.cashEgp => t.tabEgp,
      AssetTypeCodes.usd => t.tabUsd,
      AssetTypeCodes.gold21 => t.tabGold21,
      AssetTypeCodes.gold24 => t.tabGold24,
      _ => type.name,
    };
  }

  IconData _iconFor(AssetTypeEntity type) {
    return switch (type.code) {
      AssetTypeCodes.cashEgp => Icons.monetization_on_outlined,
      AssetTypeCodes.usd => Icons.attach_money_outlined,
      AssetTypeCodes.gold21 => Icons.star_outline,
      AssetTypeCodes.gold24 => Icons.star,
      _ => Icons.category_outlined,
    };
  }
}

class _DayChangeIndicator extends StatelessWidget {
  const _DayChangeIndicator({required this.summary});

  final AssetTypeSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (summary.assetType.isMarketBased && !summary.hasSufficientPriceHistory) {
      return _pill(context, '—', colors.textSecondary, icon: null);
    }

    final isFlat = summary.dayChangePercent == Decimal.zero;
    final color = isFlat
        ? colors.textSecondary
        : summary.isDayGain
        ? colors.secondaryVariant
        : colors.error;
    final icon = isFlat
        ? null
        : summary.isDayGain
        ? Icons.arrow_upward
        : Icons.arrow_downward;

    return _pill(
      context,
      '${summary.dayChangePercent.abs().toStringAsFixed(1)}%',
      color,
      icon: icon,
    );
  }

  Widget _pill(
    BuildContext context,
    String text,
    Color color, {
    required IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(38),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 2),
          ],
          Text(
            text,
            style: context.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
