import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/animations/app_animated_entry.dart';
import 'package:qeema/core/animations/app_motion.dart';
import 'package:qeema/core/animations/entry_animation_type.dart';
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
            return Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: assetTypes.asMap().entries.map((entry) {
                final index = entry.key;
                final type = entry.value;
                final isSelected = state.selectedType?.id == type.id;
                return AppAnimatedEntry(
                  type: EntryAnimationType.fadeSlideUp,
                  delay: Duration(
                    milliseconds: (index * AppMotion.staggerStep.inMilliseconds)
                        .clamp(0, AppMotion.maxStaggerTotal.inMilliseconds),
                  ),
                  key: ValueKey('type_tile_${type.id}'),
                  child: AssetTypeTile(
                    type: type,
                    isSelected: isSelected,
                    onTap: () =>
                        context.read<AddAssetCubit>().selectAssetType(type),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
