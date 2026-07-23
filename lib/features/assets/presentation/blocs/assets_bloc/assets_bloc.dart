import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';
import 'package:qeema/features/assets/domain/params/update_asset_params.dart';
import 'package:qeema/features/assets/domain/usecases/add_asset_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/soft_delete_asset_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/update_asset_usecase.dart';
import 'package:qeema/features/assets/presentation/blocs/assets_bloc/assets_event.dart';
import 'package:qeema/features/assets/presentation/blocs/assets_bloc/assets_state.dart';

class AssetsBloc extends Bloc<AssetsEvent, AssetsState> {
  AssetsBloc(
    this._getAssetsUseCase,
    this._getAssetTypesUseCase,
    this._addAssetUseCase,
    this._updateAssetUseCase,
    this._softDeleteAssetUseCase,
  ) : super(const AssetsLoading()) {
    on<AssetsSubscriptionRequested>(_onSubscriptionRequested);
    on<AssetFilterChanged>(_onFilterChanged);
    on<AssetSortChanged>(_onSortChanged);
    on<AssetDeleted>(_onDeleted);
    on<AssetAdded>(_onAdded);
    on<AssetUpdated>(_onUpdated);
  }

  final GetAssetsUseCase _getAssetsUseCase;
  final GetAssetTypesUseCase _getAssetTypesUseCase;
  final AddAssetUseCase _addAssetUseCase;
  final UpdateAssetUseCase _updateAssetUseCase;
  final SoftDeleteAssetUseCase _softDeleteAssetUseCase;

  Future<void> _onSubscriptionRequested(
    AssetsSubscriptionRequested event,
    Emitter<AssetsState> emit,
  ) async {
    final typesResult = await _getAssetTypesUseCase.call();
    List<AssetTypeEntity> assetTypes = [];
    typesResult.fold(
      onSuccess: (types) => assetTypes = types,
      onFailure: (_) {},
    );

    await emit.onEach(
      _getAssetsUseCase.call(),
      onData: (ApiResult<List<AssetEntity>> result) {
        final AssetsState next = result.fold(
          onSuccess: (assets) {
            final current = state;
            if (current is AssetsLoadSuccess) {
              return AssetsLoadSuccess(
                assets: assets,
                assetTypes: assetTypes,
                filterType: current.filterType,
                sortBy: current.sortBy,
              );
            }
            return AssetsLoadSuccess(assets: assets, assetTypes: assetTypes);
          },
          onFailure: (failure) => AssetsLoadFailure(failure),
        );
        emit(next);
      },
    );
  }

  void _onFilterChanged(AssetFilterChanged event, Emitter<AssetsState> emit) {
    final current = state;
    if (current is AssetsLoadSuccess) {
      emit(
        AssetsLoadSuccess(
          assets: current.assets,
          assetTypes: current.assetTypes,
          filterType: event.filterType,
          sortBy: current.sortBy,
        ),
      );
    }
  }

  void _onSortChanged(AssetSortChanged event, Emitter<AssetsState> emit) {
    final current = state;
    if (current is AssetsLoadSuccess) {
      emit(
        AssetsLoadSuccess(
          assets: current.assets,
          assetTypes: current.assetTypes,
          filterType: current.filterType,
          sortBy: event.sortBy,
        ),
      );
    }
  }

  Future<void> _onDeleted(AssetDeleted event, Emitter<AssetsState> emit) async {
    final result = await _softDeleteAssetUseCase.call(event.assetId);
    result.fold(
      onSuccess: (_) {},
      onFailure: (failure) {
        emit(AssetsLoadFailure(failure));
      },
    );
  }

  Future<void> _onAdded(AssetAdded event, Emitter<AssetsState> emit) async {
    final result = await _addAssetUseCase.call(
      AddAssetParams(
        assetTypeId: event.assetTypeId,
        assetTypeCode: event.assetTypeCode,
        amount: event.amount,
        priceAtEntry: event.priceAtEntry,
        entryDate: event.entryDate,
        note: event.note,
      ),
    );
    result.fold(
      onSuccess: (_) {},
      onFailure: (failure) {
        emit(AssetsLoadFailure(failure));
      },
    );
  }

  Future<void> _onUpdated(AssetUpdated event, Emitter<AssetsState> emit) async {
    final result = await _updateAssetUseCase.call(
      UpdateAssetParams(
        id: event.id,
        amount: event.amount,
        priceAtEntry: event.priceAtEntry,
        note: event.note,
      ),
    );
    result.fold(
      onSuccess: (_) {},
      onFailure: (failure) {
        emit(AssetsLoadFailure(failure));
      },
    );
  }
}
