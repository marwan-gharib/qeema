/// Border stroke widths in logical pixels.
///
/// Strokes are intentionally never scaled: a hairline must stay a hairline
/// on every screen (device pixel ratio already handles rendering), and a
/// focus ring that grows with the layout reads as a design bug.
class AppBorders {
  const AppBorders._();

  /// Default dividers and input outlines.
  static const double hairline = 1;

  /// Emphasis stroke: focused input outline, progress arcs.
  static const double emphasis = 2;
}
