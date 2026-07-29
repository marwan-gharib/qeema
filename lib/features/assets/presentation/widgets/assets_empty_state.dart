import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';

class AssetsEmptyState extends StatelessWidget {
  const AssetsEmptyState({super.key, required this.isFiltered});

  final bool isFiltered;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final t = context.t.assets.list;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.savings_outlined, size: 64, color: colors.divider),
            const SizedBox(height: 16),
            Text(
              isFiltered ? t.emptyNoFiltered : t.emptyNoAssets,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: colors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isFiltered ? t.emptyNoFilteredSubtitle : t.emptyNoAssetsSubtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (!isFiltered) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.pushNamed(RouteNames.addAsset),
                icon: const Icon(Icons.add),
                label: Text(t.addFirst),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
