import 'package:qeema/core/error/failures.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';

class AddAssetState {
  const AddAssetState({
    this.selectedType,
    this.availableTypes = const [],
    this.isSubmitting = false,
    this.submitFailure,
    this.submitSucceeded = false,
  });

  final AssetTypeEntity? selectedType;
  final List<AssetTypeEntity> availableTypes;
  final bool isSubmitting;
  final Failure? submitFailure;
  final bool submitSucceeded;

  AddAssetState copyWith({
    AssetTypeEntity? selectedType,
    List<AssetTypeEntity>? availableTypes,
    bool? isSubmitting,
    bool clearSubmitFailure = false,
    Failure? submitFailure,
    bool? submitSucceeded,
  }) {
    return AddAssetState(
      selectedType: selectedType ?? this.selectedType,
      availableTypes: availableTypes ?? this.availableTypes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitFailure: clearSubmitFailure
          ? null
          : (submitFailure ?? this.submitFailure),
      submitSucceeded: submitSucceeded ?? this.submitSucceeded,
    );
  }
}
