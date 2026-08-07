import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qeema/core/animations/app_animated_entry.dart';
import 'package:qeema/core/animations/entry_animation_type.dart';
import 'package:qeema/core/animations/micro_interactions/tap_scale.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';
import 'package:qeema/features/assets/presentation/cubits/asset_detail_cubit/asset_detail_cubit.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_history_timeline.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_value_chart_content.dart';
import 'package:qeema/features/assets/presentation/widgets/delete_asset_confirmation_dialog.dart';

class AssetDetailContent extends StatelessWidget {
  const AssetDetailContent({
    super.key,
    required this.asset,
    required this.history,
    required this.priceHistory,
  });

  final AssetEntity asset;
  final List<AssetHistoryEntryEntity> history;
  final List<MarketPriceEntity> priceHistory;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final currencyFormat = NumberFormat.currency(
      locale: locale,
      symbol: 'EGP ',
      decimalDigits: 2,
    );
    final isGain = asset.isGain;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppAnimatedEntry(
            type: EntryAnimationType.scaleIn,
            child: _AssetDetailHeader(asset: asset),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppAnimatedEntry(
            type: EntryAnimationType.fadeSlideUp,
            delay: const Duration(milliseconds: 100),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: (isGain ? colors.secondaryVariant : colors.error)
                    .withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    isGain ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isGain ? colors.secondaryVariant : colors.error,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    currencyFormat.format(asset.gainLossAmount ?? 0),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isGain ? colors.secondaryVariant : colors.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: (isGain ? colors.secondaryVariant : colors.error)
                          .withAlpha(38),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${asset.gainLossPercent?.toStringAsFixed(1) ?? "—"}%',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isGain ? colors.secondaryVariant : colors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppAnimatedEntry(
            type: EntryAnimationType.fadeSlideUp,
            delay: const Duration(milliseconds: 200),
            child: AssetValueChartBody(
              asset: asset,
              priceHistory: priceHistory,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppAnimatedEntry(
            type: EntryAnimationType.fadeSlideUp,
            delay: const Duration(milliseconds: 300),
            child: AssetHistoryTimeline(history: history),
          ),
          if (asset.note != null && asset.note!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            AppAnimatedEntry(
              type: EntryAnimationType.fadeSlideUp,
              delay: const Duration(milliseconds: 350),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.surfaceAlt,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.assets.detail.note,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      asset.note!,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppAnimatedEntry(
            type: EntryAnimationType.fadeSlideUp,
            delay: const Duration(milliseconds: 400),
            child: Row(
              children: [
                Expanded(
                  child: TapScale(
                    onTap: () async {
                      final result = await context.pushNamed<(double, double)>(
                        RouteNames.editAsset,
                        pathParameters: {'assetId': asset.id},
                      );
                      if (result != null && context.mounted) {
                        context.read<AssetDetailCubit>().applyUpdate(
                          result.$1,
                          result.$2,
                        );
                      }
                    },
                    child: AppButton(
                      label: t.assets.detail.edit,
                      isOutline: true,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TapScale(
                    onTap: () async {
                      final confirmed =
                          await DeleteAssetConfirmationDialog.show(context);
                      if (confirmed == true && context.mounted) {
                        final cubit = context.read<AssetDetailCubit>();
                        final result = await cubit.softDeleteAsset(asset.id);
                        result.fold(
                          onSuccess: (_) => context.pop(),
                          onFailure: (failure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  failure.message ?? 'Delete failed',
                                ),
                                backgroundColor: colors.error,
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: AppButton(
                      label: t.core.actions.delete,
                      backgroundColor: colors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _AssetDetailHeader extends StatelessWidget {
  const _AssetDetailHeader({required this.asset});

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final currencyFormat = NumberFormat.currency(
      locale: locale,
      symbol: 'EGP ',
      decimalDigits: 2,
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(_iconForType(asset.assetType), size: 48, color: colors.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${asset.amount}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            _unitLabel(asset.assetType),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            currencyFormat.format(asset.currentValue ?? asset.entryValue),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(AssetType type) {
    switch (type) {
      case AssetType.egpCash:
        return Icons.payments_outlined;
      case AssetType.usdCash:
        return Icons.attach_money;
      case AssetType.gold21:
      case AssetType.gold24:
        return Icons.monetization_on_outlined;
    }
  }

  String _unitLabel(AssetType type) {
    switch (type) {
      case AssetType.egpCash:
        return 'EGP';
      case AssetType.usdCash:
        return 'USD';
      case AssetType.gold21:
      case AssetType.gold24:
        return 'grams';
    }
  }
}
