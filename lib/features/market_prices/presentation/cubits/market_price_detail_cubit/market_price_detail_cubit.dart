import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/market_prices/domain/params/get_market_price_range_params.dart';
import 'package:qeema/features/market_prices/domain/usecases/get_market_price_range_usecase.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_price_detail_cubit/market_price_detail_state.dart';

class MarketPriceDetailCubit extends Cubit<MarketPriceDetailState> {
  MarketPriceDetailCubit({
    required this.assetTypeId,
    required this._getAssetTypes,
    required this._getRange,
  }) : super(const MarketPriceDetailLoading()) {
    _load();
  }

  final String assetTypeId;
  final GetAssetTypesUseCase _getAssetTypes;
  final GetMarketPriceRangeUseCase _getRange;

  AssetTypeEntity? _assetType;
  MarketPriceRangeOption _selectedRange = MarketPriceRangeOption.oneWeek;

  MarketPriceRangeOption get lastRange => _selectedRange;

  Future<void> _load() async {
    emit(const MarketPriceDetailLoading());
    final typesResult = await _getAssetTypes();
    if (isClosed) return;

    final type = typesResult.fold<AssetTypeEntity?>(
      onSuccess: (types) => types.where((t) => t.id == assetTypeId).firstOrNull,
      onFailure: (_) => null,
    );
    if (type == null) {
      emit(const MarketPriceDetailError(UnknownFailure()));
      return;
    }
    _assetType = type;
    await _fetchRange(_selectedRange);
  }

  void loadRange(MarketPriceRangeOption range) {
    final type = _assetType;
    if (type == null) return;
    _selectedRange = range;
    _fetchRange(range);
  }

  Future<void> _fetchRange(MarketPriceRangeOption range) async {
    emit(const MarketPriceDetailLoading());
    final now = DateTime.now();
    final to = DateTime(now.year, now.month, now.day);
    final from = to.subtract(Duration(days: _daysFor(range)));
    final result = await _getRange(
      GetMarketPriceRangeParams(
        assetTypeCode: _assetType!.code,
        from: from,
        to: to,
      ),
    );
    if (isClosed) return;
    result.fold(
      onSuccess: (points) => emit(
        MarketPriceDetailLoaded(
          assetType: _assetType!,
          points: points,
          selectedRange: range,
          daysCovered: points.length,
        ),
      ),
      onFailure: (failure) => emit(MarketPriceDetailError(failure)),
    );
  }

  int _daysFor(MarketPriceRangeOption range) {
    return switch (range) {
      MarketPriceRangeOption.oneWeek => 7,
      MarketPriceRangeOption.oneMonth => 30,
      MarketPriceRangeOption.threeMonths => 90,
    };
  }
}
