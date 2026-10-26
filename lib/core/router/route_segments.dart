abstract final class RouteSegments {
  static const String add = 'add';
  static const String edit = 'edit';
  static const String settings = 'settings';

  /// Path-template segments (with the go_router `:` prefix).
  static const String assetId = ':assetId';
  static const String typeId = ':typeId';

  /// Raw `pathParameters` lookup keys (without the prefix).
  static const String assetIdParam = 'assetId';
  static const String typeIdParam = 'typeId';
}
