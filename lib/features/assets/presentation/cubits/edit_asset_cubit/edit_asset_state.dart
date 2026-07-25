import 'package:qeema/core/error/failures.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';

class EditAssetState {
  const EditAssetState({
    this.isLoading = true,
    this.asset,
    this.loadFailure,
    this.isSubmitting = false,
    this.submitFailure,
    this.submitSucceeded = false,
    this.updatedEntity,
  });

  factory EditAssetState.fromAsset(AssetEntity asset) {
    return EditAssetState(isLoading: false, asset: asset);
  }

  final bool isLoading;
  final AssetEntity? asset;
  final Failure? loadFailure;
  final bool isSubmitting;
  final Failure? submitFailure;
  final bool submitSucceeded;
  final AssetEntity? updatedEntity;

  EditAssetState copyWith({
    bool? isLoading,
    AssetEntity? asset,
    bool clearLoadFailure = false,
    Failure? loadFailure,
    bool? isSubmitting,
    bool clearSubmitFailure = false,
    Failure? submitFailure,
    bool? submitSucceeded,
    bool clearUpdatedEntity = false,
    AssetEntity? updatedEntity,
  }) {
    return EditAssetState(
      isLoading: isLoading ?? this.isLoading,
      asset: asset ?? this.asset,
      loadFailure: clearLoadFailure ? null : (loadFailure ?? this.loadFailure),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitFailure: clearSubmitFailure
          ? null
          : (submitFailure ?? this.submitFailure),
      submitSucceeded: submitSucceeded ?? this.submitSucceeded,
      updatedEntity: clearUpdatedEntity
          ? null
          : (updatedEntity ?? this.updatedEntity),
    );
  }
}
