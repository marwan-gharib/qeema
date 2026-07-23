import 'package:flutter/material.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';

class AssetFilterTabs extends StatelessWidget {
  const AssetFilterTabs({
    super.key,
    required this.assetTypes,
    this.selectedCode,
    this.onSelected,
  });
  final List<AssetTypeEntity> assetTypes;
  final String? selectedCode;
  final ValueChanged<String?>? onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildChip(context, 'All', null, selectedCode == null),
          ...assetTypes.map(
            (type) => _buildChip(
              context,
              type.name,
              type.code,
              selectedCode == type.code,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    String label,
    String? code,
    bool isSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected?.call(code),
        selectedColor: context.colors.primary.withValues(alpha: 0.15),
        checkmarkColor: context.colors.primary,
        labelStyle: TextStyle(
          color: isSelected ? context.colors.primary : null,
          fontWeight: isSelected ? FontWeight.w600 : null,
        ),
      ),
    );
  }
}
