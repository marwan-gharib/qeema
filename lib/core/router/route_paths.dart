abstract final class RoutePaths {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String assets = '/assets';
  static const String marketPrices = '/market-prices';
  static const String settings = '/settings';
  static const String lock = '/lock';

  /// Detail route of one asset, built from the assets list path.
  static String assetDetail(String assetId) => '$assets/$assetId';
}
