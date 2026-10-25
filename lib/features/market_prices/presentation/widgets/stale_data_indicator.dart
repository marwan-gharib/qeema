import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/theme/app_sizes.dart';

/// "Updated Xh ago" caption built from the row's fetch time. When the data is
/// stale (past the threshold), it renders emphasized with a warning icon so
/// old prices are never presented as current without indication.
class StaleDataIndicator extends StatelessWidget {
  const StaleDataIndicator({
    super.key,
    required this.fetchedAt,
    this.isStale = false,
  });

  final DateTime fetchedAt;
  final bool isStale;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;
    final label = _updatedAgoLabel(t, fetchedAt);
    final color = isStale ? colors.error : colors.textSecondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isStale) ...[
          Icon(
            Icons.warning_amber_rounded,
            size: AppSizes.iconStatus,
            color: color,
          ),
          SizedBox(width: Responsive.adapt(3)),
        ],
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.footnote.copyWith(color: color),
          ),
        ),
      ],
    );
  }

  static String _updatedAgoLabel(Translations t, DateTime fetchedAt) {
    final diff = DateTime.now().difference(fetchedAt);
    final when = switch (diff) {
      < const Duration(minutes: 1) => t.core.dates.justNow,
      < const Duration(hours: 1) => t.core.dates.minutesAgo(n: diff.inMinutes),
      < const Duration(days: 1) => t.core.dates.hoursAgo(n: diff.inHours),
      _ => t.core.dates.daysAgo(n: diff.inDays),
    };
    return t.marketPrices.lastUpdated(when: when);
  }
}
