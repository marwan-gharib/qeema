class ChartConstants {
  const ChartConstants._();

  /// The app's one UI exception: charts never mirror with the locale.
  ///
  /// A chart plots time from oldest (left) to newest (right), and every part
  /// of it — axis, grid, gradient, tooltip — has to agree on that order.
  /// Flipping the whole chart for Arabic would read as reversed data.
  /// Widgets that render a chart reach this through
  /// `AppChartDirectionality`; nothing else may read it directly.
  static bool alwaysChartsLtr = true;
}
