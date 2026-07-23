import 'package:qeema/core/error/failures.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';

sealed class AssetsState {
  const AssetsState();
}

final class AssetsLoading extends AssetsState {
  const AssetsLoading();
}

final class AssetsLoadSuccess extends AssetsState {
  const AssetsLoadSuccess({
    required this.assets,
    required this.assetTypes,
    this.filterType,
    this.sortBy = 'date',
  });
  final List<AssetEntity> assets;
  final List<AssetTypeEntity> assetTypes;
  final String? filterType;
  final String sortBy;

  List<AssetEntity> get filteredAssets {
    var result = assets;
    if (filterType != null) {
      result = result.where((a) => a.assetTypeCode == filterType).toList();
    }
    switch (sortBy) {
      case 'value':
        result = List.from(result)
          ..sort((a, b) => b.priceAtEntry.compareTo(a.priceAtEntry));
      case 'type':
        result = List.from(result)
          ..sort((a, b) => a.assetTypeCode.compareTo(b.assetTypeCode));
      case 'date':
      default:
        result = List.from(result)
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }
    return result;
  }
}

final class AssetsLoadFailure extends AssetsState {
  const AssetsLoadFailure(this.failure);
  final Failure failure;
}
