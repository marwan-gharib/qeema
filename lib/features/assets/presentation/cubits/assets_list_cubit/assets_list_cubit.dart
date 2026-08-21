import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/assets/presentation/cubits/assets_list_cubit/assets_list_state.dart';

class AssetsListCubit extends Cubit<AssetsListState> {
  AssetsListCubit(this.getAssetsUseCase) : super(const AssetsListInitial());

  final GetAssetsUseCase getAssetsUseCase;

  Future<void> loadAssets() async {
    emit(const AssetsListLoading());
    final result = await getAssetsUseCase();
    if (isClosed) return;

    result.fold(
      onSuccess: (assets) => emit(AssetsListLoaded(allAssets: assets)),
      onFailure: (failure) => emit(AssetsListError(failure)),
    );
  }

  Future<void> refresh() => loadAssets();

  void changeFilter(AssetType? type) {
    final current = state;
    if (current is! AssetsListLoaded) return;
    emit(current.copyWith(activeFilter: type, clearFilter: type == null));
  }

  void changeSort(AssetsSortBy sortBy) {
    final current = state;
    if (current is! AssetsListLoaded) return;
    emit(current.copyWith(sortBy: sortBy));
  }
}
