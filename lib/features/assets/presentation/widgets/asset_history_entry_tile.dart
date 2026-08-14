import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/helpers/date_formatter.dart';
import 'package:qeema/features/assets/data/mappers/asset_history_mapper.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';

class AssetHistoryEntryTile extends StatelessWidget {
  const AssetHistoryEntryTile({super.key, required this.entry});

  final AssetHistoryEntryEntity entry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final (IconData icon, Color iconColor) = switch (entry.changeType) {
      'created' => (Icons.add_circle_outline, colors.secondaryVariant),
      'updated' => (Icons.edit_outlined, colors.primary),
      'deleted' => (Icons.delete_outline, colors.error),
      _ => (Icons.info_outline, colors.textSecondary),
    };

    final summary = AssetHistoryMapper.summarizeChange(entry);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _relativeTime(entry.changedAt),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _relativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormatter.format(date);
  }
}
