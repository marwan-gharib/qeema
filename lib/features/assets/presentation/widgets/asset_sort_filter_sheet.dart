import 'package:flutter/material.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';

class AssetSortFilterSheet extends StatelessWidget {
  const AssetSortFilterSheet({
    super.key,
    required this.currentSort,
    this.onSortChanged,
  });
  final String currentSort;
  final ValueChanged<String>? onSortChanged;

  static Future<String?> show(BuildContext context, String currentSort) {
    return showModalBottomSheet<String>(
      context: context,
      builder: (_) => AssetSortFilterSheet(currentSort: currentSort),
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = [('date', 'Date'), ('value', 'Value'), ('type', 'Type')];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort by',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...options.map(
              (opt) => ListTile(
                title: Text(opt.$2),
                trailing: currentSort == opt.$1
                    ? Icon(Icons.check, color: context.colors.primary)
                    : null,
                onTap: () {
                  onSortChanged?.call(opt.$1);
                  Navigator.pop(context, opt.$1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
