import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/helpers/date_formatter.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_sizes.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';

class AssetHistoryEntryTile extends StatelessWidget {
  const AssetHistoryEntryTile({super.key, required this.entry});

  final AssetHistoryEntryEntity entry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;

    final (IconData icon, Color iconColor) = switch (entry.changeType) {
      'created' => (Icons.add_circle_outline, colors.secondaryVariant),
      'updated' => (Icons.edit_outlined, colors.primary),
      'deleted' => (Icons.delete_outline, colors.error),
      _ => (Icons.info_outline, colors.textSecondary),
    };

    final summary = _summarizeChange(t);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.xxxs),
            child: Icon(icon, size: AppSizes.iconMedium, color: iconColor),
          ),
          SizedBox(width: AppSpacing.sm),
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
                SizedBox(height: AppSpacing.xxxs),
                Text(
                  _relativeTime(entry.changedAt, t),
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

  String _summarizeChange(Translations t) {
    final history = t.assets.history;
    switch (entry.changeType) {
      case 'created':
        return history.assetAdded;
      case 'deleted':
        return history.assetDeleted;
      case 'updated':
        return _summarizeUpdate(t);
      default:
        return history.updated;
    }
  }

  String _summarizeUpdate(Translations t) {
    final history = t.assets.history;
    final unavailable = t.core.value.unavailable;
    final oldValue = entry.oldValue ?? {};
    final newValue = entry.newValue ?? {};
    final changes = <String>[];
    final fieldLabels = {
      'amount': history.fieldAmount,
      'price_at_entry': history.fieldEntryPrice,
      'entry_date': history.fieldEntryDate,
      'note': history.fieldNote,
    };

    for (final key in fieldLabels.keys) {
      if (!newValue.containsKey(key) && !oldValue.containsKey(key)) continue;
      final oldFieldValue = oldValue[key];
      final newFieldValue = newValue[key];
      if (oldFieldValue?.toString() == newFieldValue?.toString()) continue;

      if (key == 'note') {
        changes.add(history.noteUpdated);
      } else if (key == 'entry_date') {
        changes.add(history.dateChanged);
      } else {
        changes.add(
          history.fieldChanged(
            field: fieldLabels[key] ?? key,
            oldValue: oldFieldValue?.toString() ?? unavailable,
            newValue: newFieldValue?.toString() ?? unavailable,
          ),
        );
      }
    }

    return changes.isEmpty
        ? history.updated
        : changes.join(t.core.listSeparator);
  }

  String _relativeTime(DateTime date, Translations t) {
    final dates = t.core.dates;
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return dates.justNow;
    if (diff.inMinutes < 60) return dates.minutesAgo(n: diff.inMinutes);
    if (diff.inHours < 24) return dates.hoursAgo(n: diff.inHours);
    if (diff.inDays < 7) return dates.daysAgo(n: diff.inDays);
    return DateFormatter.format(date);
  }
}
