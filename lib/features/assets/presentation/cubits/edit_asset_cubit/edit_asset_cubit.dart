import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/features/assets/domain/params/update_asset_params.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/update_asset_usecase.dart';
import 'package:qeema/features/assets/presentation/cubits/edit_asset_cubit/edit_asset_state.dart';

class EditAssetCubit extends Cubit<EditAssetState> {
  EditAssetCubit({
    required this.assetId,
    required this._getAssets,
    required this._updateAsset,
  }) : super(const EditAssetState()) {
    loadAsset();
  }

  final String assetId;
  final GetAssetsUseCase _getAssets;
  final UpdateAssetUseCase _updateAsset;

  Future<void> loadAsset() async {
    final result = await _getAssets();
    if (isClosed) return;
    result.fold(
      onSuccess: (assets) {
        final match = assets.where((a) => a.id == assetId).firstOrNull;
        if (match == null) {
          emit(
            const EditAssetState(
              isLoading: false,
              loadFailure: AssetNotFoundFailure(),
            ),
          );
        } else {
          emit(EditAssetState.fromAsset(match));
        }
      },
      onFailure: (failure) =>
          emit(EditAssetState(isLoading: false, loadFailure: failure)),
    );
  }

  void updateAmount(Decimal? value) {
    emit(state.copyWith(amount: value));
  }

  void updatePriceAtEntry(Decimal? value) {
    emit(state.copyWith(priceAtEntry: value));
  }

  void updateEntryDate(DateTime value) {
    emit(state.copyWith(entryDate: value));
  }

  void updateNote(String? value) {
    emit(state.copyWith(note: value));
  }

  void updateFormValidity(bool valid) {
    emit(state.copyWith(isFormValid: valid));
  }

  Future<void> submit(UpdateAssetParams params) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, clearSubmitFailure: true));
    final result = await _updateAsset(params);
    if (isClosed) return;
    result.fold(
      onSuccess: (entity) => emit(
        state.copyWith(
          isSubmitting: false,
          submitSucceeded: true,
          updatedEntity: entity,
        ),
      ),
      onFailure: (failure) =>
          emit(state.copyWith(isSubmitting: false, submitFailure: failure)),
    );
  }
}
