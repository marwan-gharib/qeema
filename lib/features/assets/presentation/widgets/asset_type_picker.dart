import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/app_motion.dart';
import 'package:qeema/core/animations/micro_interactions/tap_scale.dart';
import 'package:qeema/core/animations/staggered_list_animator.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/presentation/cubits/add_asset_cubit/add_asset_cubit.dart';
import 'package:qeema/features/assets/presentation/cubits/add_asset_cubit/add_asset_state.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_type_tile.dart';

class AssetTypePicker extends StatelessWidget {
  const AssetTypePicker({super.key, required this.assetTypes});

  final List<AssetTypeEntity> assetTypes;

  @override
  Widget build(BuildContext context) {
    final t = context.t.assets.add;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.selectType,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: context.colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.md),
        BlocBuilder<AddAssetCubit, AddAssetState>(
          buildWhen: (previous, current) =>
              previous.selectedType != current.selectedType,
          builder: (context, state) {
            return TapScale(
              onTap: () => _showTypeSheet(context, state.selectedType),
              child: _buildClosedField(context, state.selectedType),
            );
          },
        ),
      ],
    );
  }

  Widget _buildClosedField(
    BuildContext context,
    AssetTypeEntity? selectedType,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.divider),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: AppMotion.fast,
            child: selectedType != null
                ? _buildTypeBadge(context, selectedType)
                : const SizedBox(width: 28, height: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          AnimatedSwitcher(
            duration: AppMotion.fast,
            child: Text(
              selectedType?.name ?? '',
              key: ValueKey(selectedType?.id ?? 'none'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const Expanded(child: SizedBox.shrink()),
          Icon(Icons.keyboard_arrow_down, color: context.colors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(BuildContext context, AssetTypeEntity type) {
    final colors = context.colors;

    return Stack(
      clipBehavior: Clip.none,
      key: ValueKey(type.id),
      children: [
        Icon(
          AssetTypeTile.iconForType(type.code),
          size: 28,
          color: colors.textPrimary,
        ),
        if (type.code.startsWith('gold_'))
          Positioned(
            right: -10,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                type.code == 'gold_21' ? '21K' : '24K',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showTypeSheet(BuildContext context, AssetTypeEntity? currentSelection) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: StaggeredListAnimator(
              children: [
                for (final type in assetTypes)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: TapScale(
                      onTap: () {
                        context.read<AddAssetCubit>().selectAssetType(type);
                        Navigator.pop(sheetContext);
                      },
                      child: AssetTypeTile(
                        type: type,
                        isSelected: currentSelection?.id == type.id,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
