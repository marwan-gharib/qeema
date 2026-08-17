import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/app_motion.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_empty_state.dart';
import 'package:qeema/core/widgets/app_error_state.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_type_tile.dart';
import 'package:qeema/features/assets/presentation/widgets/market_price_chart.dart';
import 'package:qeema/features/market_prices/data/mappers/market_price_point_mapper.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_point_entity.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_price_detail_cubit/market_price_detail_cubit.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_price_detail_cubit/market_price_detail_state.dart';
import 'package:qeema/features/market_prices/presentation/widgets/data_source_disclosure.dart';
import 'package:qeema/features/market_prices/presentation/widgets/range_selector_chips.dart';

class MarketPriceDetailScreen extends StatelessWidget {
  const MarketPriceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocBuilder<MarketPriceDetailCubit, MarketPriceDetailState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: colors.background,
          appBar: AppBar(
            title: state is MarketPriceDetailLoaded
                ? _TypeTitle(
                    code: state.assetType.code,
                    name: state.assetType.name,
                  )
                : null,
          ),
          body: AnimatedSwitcher(
            duration: MediaQuery.of(context).disableAnimations
                ? Duration.zero
                : AppMotion.normal,
            child: switch (state) {
              MarketPriceDetailLoading() => const _DetailLoadingBody(),
              MarketPriceDetailError(:final failure) => AppErrorState(
                message: failure.message,
                onRetry: () => context.read<MarketPriceDetailCubit>().loadRange(
                  context.read<MarketPriceDetailCubit>().lastRange,
                ),
              ),
              MarketPriceDetailLoaded(:final points, :final selectedRange) =>
                _DetailContent(points: points, selectedRange: selectedRange),
            },
          ),
        );
      },
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.points, required this.selectedRange});

  final List<MarketPricePointEntity> points;
  final MarketPriceRangeOption selectedRange;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t.marketPrices;

    final chartHistory = points
        .map(MarketPricePointMapper.toMarketPrice)
        .toList();
    final daysCovered = points.length < 2
        ? null
        : points.last.date.difference(points.first.date).inDays + 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DataSourceDisclosure(),
          RangeSelectorChips(
            selected: selectedRange,
            onSelected: (range) =>
                context.read<MarketPriceDetailCubit>().loadRange(range),
          ),
          if (points.length < 2)
            AppEmptyState(
              icon: Icons.show_chart,
              title: context.t.assets.chart.noDataTitle,
              subtitle: context.t.assets.chart.noDataSubtitle,
              container: true,
              height: 250,
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.lg),
            )
          else ...[
            MarketPriceChart(priceHistory: chartHistory),
            if (daysCovered != null &&
                daysCovered < _expectedDays(selectedRange))
              Text(
                t.showingAvailableData.replaceAll('{days}', '$daysCovered'),
                style: context.textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ],
      ),
    );
  }

  int _expectedDays(MarketPriceRangeOption range) {
    return switch (range) {
      MarketPriceRangeOption.oneWeek => 7,
      MarketPriceRangeOption.oneMonth => 30,
      MarketPriceRangeOption.threeMonths => 90,
    };
  }
}

class _DetailLoadingBody extends StatelessWidget {
  const _DetailLoadingBody();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _TypeTitle extends StatelessWidget {
  const _TypeTitle({required this.code, required this.name});

  final String code;
  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(AssetTypeTile.iconForType(code), size: 22, color: colors.primary),
        const SizedBox(width: AppSpacing.xs),
        Text(name),
      ],
    );
  }
}
