# Assets

> Last verified: 2026-10-26
> Path: `lib/features/assets/`

## 1. Purpose

Core CRUD for the user's holdings (EGP cash, USD, gold 21K, gold 24K): list with filter/sort, add
form, detail screen with value chart + edit history, edit form, and soft delete. Its domain layer
(entities, `AssetsRepository`, usecases) is the shared foundation consumed by home and
market_prices.

## 2. Screens & routes

| Screen | Route (constant) | Params | Notes |
|---|---|---|---|
| `presentation/screens/assets_list_screen.dart` | `RouteNames.assets` / `RoutePaths.assets` | none | Shell branch; the child routes nest under it |
| `presentation/screens/add_asset_screen.dart` | `RouteNames.addAsset` (RouteSegments.add) | none | Route creates `AddAssetCubit..loadAssetTypes()` |
| `presentation/screens/asset_detail_screen.dart` | `RouteNames.assetDetail` (RouteSegments.assetId) | assetId (path param) | `AssetDetailCubit` is a factory param on assetId |
| `presentation/screens/edit_asset_screen.dart` | `RouteNames.editAsset` (RouteSegments.edit) | assetId (path param) | Nested under detail |

## 3. File map

| Layer | Key files | Responsibility |
|---|---|---|
| screens | `presentation/screens/` — assets_list, add_asset, asset_detail, edit_asset | The four screens |
| cubits | `presentation/cubits/` — assets_list_cubit, asset_detail_cubit, add_asset_cubit, edit_asset_cubit (cubit + state each) | One cubit per flow |
| widgets | `presentation/widgets/` — AssetListItem, AssetTypeTabBar, SortFilterBottomSheet, AssetsLoadingSkeleton, AssetsErrorState, AssetTypePicker, AssetTypeTile, DynamicAssetFields, AddAssetSkeleton, EditAssetHeader, AssetDetailContent, AssetDetailSkeleton, AssetValueChartBody, CashFlatChart, MarketPriceChart, AssetHistoryTimeline, AssetHistoryEntryTile, DeleteAssetConfirmationDialog | 18 feature-only widgets (WIDGET-2); AssetTypeTile + MarketPriceChart are also used by market_prices (pending WIDGET-3 promotion) |
| domain entities | `domain/entities/asset_entity.dart` (with the AssetType enum), `domain/entities/asset_type_entity.dart`, `domain/entities/asset_history_entry_entity.dart`, `domain/entities/market_price_entity.dart` | 4 entities |
| domain repo | `domain/repositories/assets_repository.dart` | Abstract contract, 7 methods |
| usecases | `domain/usecases/` — get_assets, get_asset_types, add_asset, update_asset, soft_delete_asset, get_asset_history, get_market_price_history | 7 usecases |
| params | `domain/params/add_asset_params.dart`, `domain/params/update_asset_params.dart` | 2 params |
| datasources | `data/datasources/assets_remote_datasource.dart` | Supabase + Drift cache |
| models | `data/models/asset_model_from_server.dart`, `data/models/asset_history_model.dart`, `data/models/market_price_model.dart` | fromJson/fromRow + toEntity each |
| repo impl | `data/repositories/assets_repository_impl.dart` + `data/repositories/assets_repository_impl_support.dart` | Remote + write-through cache |

## 4. Entities & models

| Entity | Key fields | Model (data) | Notes |
|---|---|---|---|
| `AssetEntity` + enum `AssetType` | id, assetType, amount, priceAtEntry, entryDate, note?, currentPrice? | `AssetModelFromServer` | Getters: entryValue, currentValue, gainLossAmount/Percent, isGain |
| `AssetTypeEntity` | id, code, name, isMarketBased, baseUnit | parsed inline |  |
| `AssetHistoryEntryEntity` | id, assetId, changeType, oldValue?, newValue?, changedAt | `AssetHistoryModel` |  |
| `MarketPriceEntity` | priceDate, price, fetchedAt? | `MarketPriceModel` | fetchedAt drives staleness |
| `AddAssetParams` / `UpdateAssetParams` | amount, priceAtEntry?, entryDate, note? (assetId for update) | — |  |

## 5. Use cases

| UseCase | Input | Output | Business rule (if any) |
|---|---|---|---|
| `GetAssetsUseCase` | none | ApiResult(List of AssetEntity) | pass-through |
| `GetAssetTypesUseCase` | none | ApiResult(List of AssetTypeEntity) | active types only |
| `AddAssetUseCase` | `AddAssetParams` | ApiResult(AssetEntity) | Rejects amount ≤ 0 and market-based without price; cash priceAtEntry defaults to 1 |
| `UpdateAssetUseCase` | `UpdateAssetParams` | ApiResult(AssetEntity) | Same validation; cache-first write-through |
| `SoftDeleteAssetUseCase` | assetId | ApiResult(void) | Local delete + remote is_deleted flag |
| `GetAssetHistoryUseCase` | assetId | ApiResult(List of AssetHistoryEntryEntity) | pass-through |
| `GetMarketPriceHistoryUseCase` | assetTypeCode | ApiResult(List of MarketPriceEntity) | pass-through |

## 6. API & storage

| Key (constant) | Used by | Cache policy |
|---|---|---|
| `SupabaseTables.assets` | getAssets / add / update / softDelete | `AssetsDao.insertOrUpdate` write-through; reads are network-only |
| `SupabaseTables.marketPrices` | latest-price scan, getPriceHistory | none |
| `SupabaseTables.assetTypes` | getAssetTypes | none |
| `SupabaseTables.assetHistory` | getAssetHistory | none |
| `AssetsDao` (drift cachedAssetsTable) | add / update / softDelete | pendingSync placeholder row with a local_ id before the remote call |

The datasource currently writes table/column names as string literals even though the
`SupabaseTables` constants exist (ARCH-10, see Known issues).

## 7. State

- `AssetsListCubit`: Initial / Loading / Loaded(allAssets, filter, sortBy, visibleAssets getter) /
  Error; methods loadAssets, refresh, changeFilter, changeSort (`AssetsSortBy` enum).
- `AssetDetailCubit` (assetId param): Loading → Loaded(asset, history, priceHistory); history/price
  failures degrade to empty lists; applyUpdate applies an optimistic patch; NotFound / Error.
- `AddAssetCubit`: one state class (types loading, selectedType, isSubmitting, submit result);
  preselects USD on load.
- `EditAssetCubit` (assetId param): one state class; hasChanges normalizes a blank note to null and
  compares dates by Y/M/D only.
- Pagination: none.

## 8. Dependencies

- Depends on (core): AppButton, AppTextField, AppContentBox, AppEmptyState, AppErrorState,
  AppSurfaceCard, PercentChangeBadge, AppLineChart, AppSnackBar, animations (AppAnimatedEntry,
  TapScale, SuccessPulse, StaggeredListAnimator, shimmer), theme tokens, Responsive,
  CurrencyFormatter / DateFormatter / Validators, ApiResult, Failures, AssetsDao + AppDatabase,
  SupabaseClientProvider, AssetTypeCodes, route constants.
- Depends on (features): none — assets is the foundation.
- Used by (features): home (domain usecases + entities); market_prices (domain + two presentation
  widgets pending promotion).
- Used by (core): `core/utils/asset_type_parsing.dart` imports the entity (core→feature exception).
- DI: `core/di/assets_module.dart` — datasource, repo, 7 usecases, 4 cubit factories (2 of them
  factory params).

## 9. Localization

- Namespace: `assets` — groups: list, add, edit, detail, sort, filter, carat, chart, history,
  delete, failure.

## 10. Business rules & edge cases

- Soft delete only: is_deleted + deleted_at; every query scopes by user id and filters deleted rows.
- Market-based types (USD/gold) require priceAtEntry; cash defaults to 1 (value = amount).
- Entry date is serialized as a zero-padded yyyy-MM-dd string.
- The detail screen filters price history to points on/after the asset's entry date.
- An unknown asset-type code throws FormatException inside fromJson.
- PostgrestException code PGRST301 or a JWT message → SessionExpiredFailure; otherwise
  AssetOperationFailure(operation).

## 11. Tests

| Area | Test files | Covered behaviors |
|---|---|---|
| data | test/features/assets/data/repositories/assets_repository_impl_test.dart (+ mocks) | repo flows |
| domain | test/features/assets/domain/usecases/add_asset_usecase_test.dart | add validation |
| cubits | test/features/assets/presentation/cubits/asset_detail_cubit_test.dart, add_asset_cubit_test.dart | transitions |
| widgets | test/features/assets/presentation/widgets/market_price_chart_test.dart, asset_value_chart_content_test.dart | chart bodies |

## 12. Known issues

- ARCH-10: RESOLVED 2026-10-26 for datasource/repo/models/history tile ('usd' in add_asset_cubit
  and the type display names remain until the UI-4 step).
- DATA-3: non-defensive casts (as num / as String / DateTime.parse) — malformed data crashes
  instead of mapping to a Failure.
- DATA-4/5: RESOLVED 2026-10-26 — models live in data/models/ with toEntity(); the unused
  `AssetModel` (which extended the entity) was deleted; data/mappers was dissolved.
- ERR-2: a private error mapper duplicates core `mapExceptionToFailure`.
- STATE-3 / ANIM-2 / BASE-3 / UI-4: `state is` checks, raw AnimatedSwitcher, raw dialogs /
  snackbars / loaders, the hardcoded '0.00' hint, hardcoded type display names.
- Offline-first unfinished: getAssets never reads the cache; the placeholder row is never removed;
  three AssetsDao methods are unused; every cache write is wrapped in a silent catch.
- TEST-1: no screen tests; missing usecase/model tests for get/update/delete/history.

## 13. Changelog

- 2026-10-26 — Initial doc created from code (doc-sync).
- 2026-10-26 — Refactor (DATA-4/5): models in data/models/ with toEntity(); data/mappers dissolved;
  unused AssetModel removed; row keys moved to SupabaseColumns constants.
