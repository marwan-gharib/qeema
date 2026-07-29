import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_history_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/soft_delete_asset_usecase.dart';
import 'package:qeema/features/assets/presentation/cubits/asset_detail_cubit/asset_detail_state.dart';

class AssetDetailCubit extends Cubit<AssetDetailState> {
  AssetDetailCubit({
    required this.assetId,
    required this._getAssets,
    required this._getHistory,
    required this._softDelete,
  }) : super(const AssetDetailInitial()) {
    _load();
  }

  final String assetId;
  final GetAssetsUseCase _getAssets;
  final GetAssetHistoryUseCase _getHistory;
  final SoftDeleteAssetUseCase _softDelete;

  Future<void> _load() async {
    emit(const AssetDetailLoading());
    final assetResult = await _getAssets();
    if (isClosed) return;

    assetResult.fold(
      onSuccess: (assets) {
        final match = assets.where((a) => a.id == assetId).firstOrNull;
        if (match == null) {
          emit(const AssetDetailNotFound());
          return;
        }
        _loadHistoryWithAsset(match);
      },
      onFailure: (failure) => emit(AssetDetailError(failure)),
    );
  }

  Future<void> _loadHistoryWithAsset(AssetEntity asset) async {
    emit(AssetDetailHistoryLoading(asset: asset, history: const []));
    final historyResult = await _getHistory(assetId);
    if (isClosed) return;

    historyResult.fold(
      onSuccess: (history) =>
          emit(AssetDetailLoaded(asset: asset, history: history)),
      onFailure: (_) =>
          emit(AssetDetailLoaded(asset: asset, history: const [])),
    );
  }

  Future<ApiResult<void>> softDeleteAsset(String id) async {
    return _softDelete(id);
  }

  void refresh() {
    _load();
  }

  void applyUpdate(double amount, double priceAtEntry) {
    final s = state;
    if (s case AssetDetailLoaded(:final asset, :final history)) {
      emit(
        AssetDetailLoaded(
          asset: AssetEntity(
            id: asset.id,
            assetType: asset.assetType,
            amount: amount,
            priceAtEntry: priceAtEntry,
            entryDate: asset.entryDate,
            note: asset.note,
            currentPrice: asset.currentPrice,
          ),
          history: history,
        ),
      );
    } else {
      refresh();
    }
  }
}
