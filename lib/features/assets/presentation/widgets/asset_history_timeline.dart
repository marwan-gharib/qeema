import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/staggered_list_animator.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_radius.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_history_entry_tile.dart';

class AssetHistoryTimeline extends StatelessWidget {
  const AssetHistoryTimeline({super.key, required this.history});

  final List<AssetHistoryEntryEntity> history;

  @override
  Widget build(BuildContext context) {
    final t = context.t.assets;
    final colors = context.colors;

    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.detail.editHistory,
            style: context.textTheme.labelLarge?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          StaggeredListAnimator(
            children: history.map((entry) {
              return AssetHistoryEntryTile(entry: entry);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
