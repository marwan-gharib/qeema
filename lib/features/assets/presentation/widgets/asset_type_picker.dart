import 'package:flutter/material.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';

class AssetTypePicker extends StatelessWidget {
  const AssetTypePicker({
    super.key,
    required this.assetTypes,
    this.selectedId,
    this.onSelected,
  });
  final List<AssetTypeEntity> assetTypes;
  final String? selectedId;
  final ValueChanged<AssetTypeEntity>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: assetTypes.map((type) {
        final isSelected = type.id == selectedId;
        return GestureDetector(
          onTap: () => onSelected?.call(type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.colors.primary.withValues(alpha: 0.1)
                  : context.colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? context.colors.primary
                    : context.colors.divider,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              type.name,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? context.colors.primary
                    : context.colors.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
