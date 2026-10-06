import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/app_motion.dart';
import 'package:qeema/core/animations/micro_interactions/tap_scale.dart';
import 'package:qeema/core/animations/staggered_list_animator.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/theme/app_radius.dart';
import 'package:qeema/core/theme/app_sizes.dart';
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
        SizedBox(height: AppSpacing.md),
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
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: context.colors.divider),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: AppMotion.fast,
            child: selectedType != null
                ? _buildTypeBadge(context, selectedType)
                : SizedBox(
                    width: AppSizes.iconLarge,
                    height: AppSizes.iconLarge,
                  ),
          ),
          SizedBox(width: AppSpacing.md),
          AnimatedSwitcher(
            duration: AppMotion.fast,
            child: Text(
              selectedType == null
                  ? ''
                  : context.assetTypeName(selectedType.code),
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
          size: AppSizes.iconLarge,
          color: colors.textPrimary,
        ),
        if (type.code.startsWith('gold_'))
          Positioned(
            right: Responsive.width(-10),
            top: Responsive.height(-6),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xxs,
                vertical: Responsive.adapt(1),
              ),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(AppRadius.xxs),
              ),
              child: Text(
                type.code == 'gold_21' ? '21K' : '24K',
                style: context.textStyles.caratBadge.copyWith(
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.md),
            child: StaggeredListAnimator(
              children: [
                for (final type in assetTypes)
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.xs),
                    child: TapScale(
                      onTap: () {
                        context.read<AddAssetCubit>().selectAssetType(type);
                        context.pop(sheetContext);
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
