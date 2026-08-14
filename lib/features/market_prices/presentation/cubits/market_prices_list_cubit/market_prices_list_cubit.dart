import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/features/market_prices/domain/usecases/get_market_price_summaries_usecase.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_prices_list_cubit/market_prices_list_state.dart';

class MarketPricesListCubit extends Cubit<MarketPricesListState> {
  MarketPricesListCubit(this._getSummaries)
    : super(const MarketPricesListLoading());

  final GetMarketPriceSummariesUseCase _getSummaries;

  Future<void> load() async {
    emit(const MarketPricesListLoading());
    await _fetch();
  }

  Future<void> refresh() async {
    // No Loading emission: keeps the loaded list mounted so entrance
    // animations don't replay and the RefreshIndicator owns the spinner.
    await _fetch();
  }

  Future<void> _fetch() async {
    final result = await _getSummaries();
    if (isClosed) return;
    result.fold(
      onSuccess: (summaries) => emit(MarketPricesListLoaded(summaries)),
      onFailure: (failure) => emit(MarketPricesListError(failure)),
    );
  }
}
