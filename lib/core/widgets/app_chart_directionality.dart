import 'package:flutter/widgets.dart';
import 'package:qeema/core/constants/chart_constants.dart';

/// The direction a chart subtree must paint in — see [ChartConstants].
///
/// Exposed as a function because `fl_chart` also builds plain data objects
/// that carry their own direction (`LineTooltipItem`) and never see the
/// ambient [Directionality].
TextDirection appChartTextDirection(BuildContext context) =>
    ChartConstants.alwaysChartsLtr
    ? TextDirection.ltr
    : Directionality.of(context);

/// Places a chart in the app's single shared chart direction and gives it one
/// localized screen-reader summary.
///
/// The [Semantics] node sits *outside* the forced direction: the summary is
/// read out in the user's language, so it follows the locale while the chart
/// it describes does not. Widgets rendering a chart must go through this — it
/// is the only place in `lib/` allowed to pin a chart to [TextDirection.ltr].
class AppChartDirectionality extends StatelessWidget {
  const AppChartDirectionality({
    super.key,
    required this.semanticsLabel,
    required this.child,
  });

  /// What the chart shows, its period, and its latest/lowest/highest values,
  /// already localized and formatted for reading — never a raw data series.
  final String semanticsLabel;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final localeDirection = Directionality.of(context);
    return Semantics(
      container: true,
      label: semanticsLabel,
      textDirection: localeDirection,
      child: Directionality(
        textDirection: appChartTextDirection(context),
        child: child,
      ),
    );
  }
}
