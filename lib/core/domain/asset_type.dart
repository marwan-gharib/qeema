/// The asset categories the app tracks. Shared pure-Dart domain type: the assets
/// feature uses it end to end (entity, models, presentation) and home's
/// portfolio aggregation maps codes through `core/utils/asset_type_parsing.dart`.
enum AssetType { egpCash, usdCash, gold21, gold24 }
