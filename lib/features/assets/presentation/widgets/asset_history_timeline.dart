import 'package:flutter/material.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';

class AssetHistoryTimeline extends StatelessWidget {
  const AssetHistoryTimeline({super.key, required this.entries});
  final List<AssetHistoryEntryEntity> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No edit history yet',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return ListTile(
          leading: Icon(
            _iconForChange(entry.changeType),
            color: context.colors.textSecondary,
          ),
          title: Text(
            entry.changeType == 'created'
                ? 'Created'
                : entry.changeType == 'deleted'
                ? 'Deleted'
                : 'Updated',
          ),
          subtitle: Text(_formatDate(entry.changedAt)),
        );
      },
    );
  }

  IconData _iconForChange(String changeType) {
    return switch (changeType) {
      'created' => Icons.add_circle_outline,
      'deleted' => Icons.remove_circle_outline,
      _ => Icons.edit_outlined,
    };
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
