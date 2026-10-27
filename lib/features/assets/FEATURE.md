# Assets

> Last verified: 2026-10-27
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
| screens | `presentation/screens/` — assets_list, add_asset, asset_detail, edit_asset | The four screens | `AppAnimatedSwitcher` for state transitions (core/animations) |
| cubits | `presentation/cubits/` — assets_list_cubit, asset_detail_cubit, add_asset_cubit, edit_asset_cubit (cubit + state each) | One cubit per flow |
| widgets | `presentation/widgets/` — AssetListItem, AssetTypeTabBar, SortFilterBottomSheet, AssetsLoadingSkeleton, AssetsErrorState, AssetTypePicker, DynamicAssetFields, AddAssetSkeleton, EditAssetHeader, AssetDetailContent, AssetDetailSkeleton, AssetValueChartBody, CashFlatChart, AssetHistoryTimeline, AssetHistoryEntryTile, DeleteAssetConfirmationDialog | 16 feature-only widgets (WIDGET-2); AssetTypeTile + MarketPriceChart were promoted to core/widgets (WIDGET-3, 2026-10-26); SortFilterBottomSheet uses `AppBottomSheet` and DeleteAssetConfirmationDialog uses `AppDialog` from core/widgets |
| domain entities | `domain/entities/asset_entity.dart` (enum `AssetType` lives in `core/domain/asset_type.dart`), `domain/entities/asset_type_entity.dart`, `domain/entities/asset_history_entry_entity.dart`, `domain/entities/market_price_entity.dart` | 4 entities |
| domain repo | `domain/repositories/assets_repository.dart` | Abstract contract, 8 methods |
| usecases | `domain/usecases/` — get_assets, refresh_assets, get_asset_types, add_asset, update_asset, soft_delete_asset, get_asset_history, get_market_price_history | 8 usecases |
| params | `domain/params/add_asset_params.dart`, `domain/params/update_asset_params.dart` | 2 params |
| datasources | `data/datasources/assets_remote_datasource.dart` | Supabase network only (no cache) |
| models | `data/models/asset_model_from_server.dart`, `data/models/asset_history_model.dart`, `data/models/market_price_model.dart`, `data/models/cached_asset_model.dart` (drift row ↔ entity, DATA-3), `data/models/row_parsing.dart` (defensive row readers) | fromJson/fromRow + toEntity each |
| repo impl | `data/repositories/assets_repository_impl.dart` + `data/repositories/assets_repository_impl_support.dart` | Cache-first reads, network-first refresh, server-mirror writes |

## 4. Entities & models

| Entity | Key fields | Model (data) | Notes |
|---|---|---|---|
| `AssetEntity` (enum `AssetType` → `core/domain/asset_type.dart`) | id, assetType, amount, priceAtEntry, entryDate, note?, currentPrice? | `AssetModelFromServer` | Getters: entryValue, currentValue, gainLossAmount/Percent, isGain |
| `AssetTypeEntity` | id, code, name, isMarketBased, baseUnit | parsed inline |  |
| `AssetHistoryEntryEntity` | id, assetId, changeType, oldValue?, newValue?, changedAt | `AssetHistoryModel` |  |
| `MarketPriceEntity` | priceDate, price, fetchedAt? | `MarketPriceModel` | fetchedAt drives staleness |
| `AddAssetParams` / `UpdateAssetParams` | amount, priceAtEntry?, entryDate, note? (assetId for update) | — |  |

## 5. Use cases

| UseCase | Input | Output | Business rule (if any) |
|---|---|---|---|
| `GetAssetsUseCase` | none | ApiResult(List of AssetEntity) | Cache-first: the mirror answers instantly, the network is the empty-cache fallback |
| `RefreshAssetsUseCase` | none | ApiResult(List of AssetEntity) | Network-first; success rewrites the mirror, failure serves the stale mirror |
| `GetAssetTypesUseCase` | none | ApiResult(List of AssetTypeEntity) | active types only |
| `AddAssetUseCase` | `AddAssetParams` | ApiResult(AssetEntity) | Rejects amount ≤ 0 and market-based without price; cash priceAtEntry defaults to 1 |
| `UpdateAssetUseCase` | `UpdateAssetParams` | ApiResult(AssetEntity) | Same validation; mirrors the updated server row to the cache |
| `SoftDeleteAssetUseCase` | assetId | ApiResult(void) | Remote is_deleted flag; the cache row is dropped only after success |
| `GetAssetHistoryUseCase` | assetId | ApiResult(List of AssetHistoryEntryEntity) | pass-through |
| `GetMarketPriceHistoryUseCase` | assetTypeCode | ApiResult(List of MarketPriceEntity) | pass-through |

## 6. API & storage

| Key (constant) | Used by | Cache policy |
|---|---|---|
| `SupabaseTables.assets` | getAssets / refreshAssets / add / update / softDelete | network read + full mirror rewrite (`AssetsDao.replaceAll`); writes mirror the returned server row |
| `SupabaseTables.marketPrices` | latest-price scan, getPriceHistory | none |
| `SupabaseTables.assetTypes` | getAssetTypes | none |
| `SupabaseTables.assetHistory` | getAssetHistory | none |
| `AssetsDao` (drift `cachedAssetsTable`) | getAssets / refreshAssets / add / update / softDelete | cache-first reads; corrupt rows skipped with a logged warning; row removed only after a successful remote delete |

## 7. State

- `AssetsListCubit`: Initial / Loading / Loaded(allAssets, filter, sortBy, visibleAssets getter) /
  Error; methods loadAssets (cache-first), refresh (network-first, no Loading emission so the
  RefreshIndicator owns the spinner), changeFilter, changeSort (`AssetsSortBy` enum).
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
  AppAnimatedSwitcher, TapScale, SuccessPulse, StaggeredListAnimator, shimmer), widgets
  (AppBottomSheet, AppDialog), theme tokens, Responsive,
  CurrencyFormatter / DateFormatter / Validators, ApiResult, Failures, AssetsDao + AppDatabase,
  SupabaseClientProvider, AssetTypeCodes, route constants.
- Depends on (features): none — assets is the foundation.
- Used by (features): home (the `AssetsRepository` contract + domain entities); market_prices
  (domain entities + usecases via its repository).
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
| data | test/features/assets/data/models/*_test.dart, data/repositories/assets_repository_impl_test.dart + assets_repository_impl_cache_test.dart (+ mocks) | row parsing/toEntity incl. corrupt rows; validation, cache-first and refresh fallbacks, write mirroring |
| domain | test/features/assets/domain/usecases/*_test.dart (8 files) | every usecase delegates to the repository |
| cubits | test/features/assets/presentation/cubits/asset_detail_cubit_test.dart, add_asset_cubit_test.dart, assets_list_cubit/assets_list_cubit_test.dart + assets_list_state_test.dart, edit_asset_cubit/edit_asset_cubit_test.dart | transitions; visibleAssets sorting/filtering (regression: never sorts an unmodifiable list) |
| widgets/screens | test/features/assets/presentation/widgets/asset_value_chart_content_test.dart, presentation/screens/{assets_list,add_asset,asset_detail,edit_asset}_screen_test.dart | chart bodies + screen states (skeleton, content, empty, error) |

## 12. Known issues

- None. All ANIM-2 items resolved (2026-10-27): raw `AnimatedSwitcher`, `showDialog`, and
  `showModalBottomSheet` replaced with `AppAnimatedSwitcher`, `AppDialog`, and `AppBottomSheet`
  from core.

## 13. Changelog

- 2026-10-26 — Initial doc created from code (doc-sync).
- 2026-10-26 — Refactor (DATA-4/5 + ERR-2/DATA-3): models in data/models/ with toEntity(),
  data/mappers dissolved, unused AssetModel removed, row keys in SupabaseColumns constants;
  mapSupabaseError folded into core mapExceptionToFailure (assetOperation param); defensive row
  parsing via data/models/row_parsing.dart — emitted Failure types unchanged.
- 2026-10-26 — Refactor (WIDGET-3): AssetTypeTile and MarketPriceChart promoted to core/widgets
  (generalized: code/title/points params); chart test moved to test/core/widgets/.
- 2026-10-26 — Refactor (STATE-3/BASE-3/UI-4): exhaustive state switches; AppLoader + AppSnackBar
  swaps; edit-screen type names and amount hints localized (new core.hints.amount key).
- 2026-10-26 — Refactor (core): AssetType enum moved to core/domain/asset_type.dart — core no
  longer imports this feature; consumers import the core enum directly.
- 2026-10-26 — Fix: AssetsListLoaded.visibleAssets copied allAssets before sorting (sorting the
  unmodifiable const list threw); regression tests added in assets_list_state_test.dart.
- 2026-10-27 — Offline-first: cache-first getAssets + network-first refreshAssets (stale-mirror
  fallback), server-mirror writes via `replaceAll`, pendingSync placeholder removed, dead DAO
  methods removed, silent cache catches replaced by logged warnings.
- 2026-10-27 — TEST-1: added 4 screen tests, all missing usecase/model tests, repo cache tests;
  repo test file split at 300 lines.
- 2026-10-27 — ANIM-2: replaced raw `AnimatedSwitcher`, `showDialog`, `showModalBottomSheet` with
  `AppAnimatedSwitcher`, `AppDialog`, `AppBottomSheet` from core across add/edit/detail screens
  and sort-filter/delete widgets.
