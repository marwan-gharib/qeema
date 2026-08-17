import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/app_animated_entry.dart';
import 'package:qeema/core/animations/entry_animation_type.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_empty_state.dart';
import 'package:qeema/core/widgets/app_error_state.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_prices_list_cubit/market_prices_list_cubit.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_prices_list_cubit/market_prices_list_state.dart';
import 'package:qeema/features/market_prices/presentation/widgets/data_source_disclosure.dart';
import 'package:qeema/features/market_prices/presentation/widgets/market_price_card.dart';
import 'package:qeema/features/market_prices/presentation/widgets/market_prices_skeleton.dart';

class MarketPricesListScreen extends StatelessWidget {
  const MarketPricesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.marketPrices;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(t.title)),
      body: BlocBuilder<MarketPricesListCubit, MarketPricesListState>(
        builder: (context, state) {
          return switch (state) {
            MarketPricesListLoading() => const MarketPricesSkeleton(),
            MarketPricesListError(:final failure) => AppErrorState(
              message: failure.message,
              onRetry: () => context.read<MarketPricesListCubit>().refresh(),
            ),
            MarketPricesListLoaded(:final summaries) => Column(
              children: [
                const DataSourceDisclosure(),
                Expanded(
                  child: summaries.isEmpty
                      ? AppEmptyState(
                          icon: Icons.show_chart,
                          title: t.emptyTitle,
                          subtitle: t.emptyBody,
                        )
                      : RefreshIndicator(
                          onRefresh: context
                              .read<MarketPricesListCubit>()
                              .refresh,
                          child: ListView.separated(
                            padding: EdgeInsets.fromLTRB(
                              AppSpacing.md,
                              AppSpacing.xs,
                              AppSpacing.md,
                              80 + MediaQuery.paddingOf(context).bottom,
                            ),
                            itemCount: summaries.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: AppSpacing.sm),
                            itemBuilder: (context, index) => AppAnimatedEntry(
                              type: EntryAnimationType.fadeSlideUp,
                              delay: Duration(milliseconds: index * 60),
                              child: MarketPriceCard(summary: summaries[index]),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          };
        },
      ),
    );
  }
}
