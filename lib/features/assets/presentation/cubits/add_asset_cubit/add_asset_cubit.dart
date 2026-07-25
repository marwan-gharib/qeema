import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';
import 'package:qeema/features/assets/domain/usecases/add_asset_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/assets/presentation/cubits/add_asset_cubit/add_asset_state.dart';

class AddAssetCubit extends Cubit<AddAssetState> {
  AddAssetCubit(this._getAssetTypes, this._addAsset)
    : super(const AddAssetState());

  final GetAssetTypesUseCase _getAssetTypes;
  final AddAssetUseCase _addAsset;

  Future<void> loadAssetTypes() async {
    final result = await _getAssetTypes();
    if (isClosed) return;
    result.fold(
      onSuccess: (types) => emit(state.copyWith(availableTypes: types)),
      onFailure: (failure) => emit(state.copyWith(submitFailure: failure)),
    );
  }

  void selectAssetType(AssetTypeEntity type) {
    emit(state.copyWith(selectedType: type));
  }

  Future<void> submit(AddAssetParams params) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, clearSubmitFailure: true));
    final result = await _addAsset(params);
    if (isClosed) return;
    result.fold(
      onSuccess: (_) =>
          emit(state.copyWith(isSubmitting: false, submitSucceeded: true)),
      onFailure: (failure) =>
          emit(state.copyWith(isSubmitting: false, submitFailure: failure)),
    );
  }
}
