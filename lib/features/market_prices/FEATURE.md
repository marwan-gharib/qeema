# Market Prices

> Last verified: 2026-10-27
> Path: `lib/features/market_prices/`

## 1. Purpose

Read-only market data for the market-based asset types (USD rate, gold 21K/24K): a summary list
with today's price, weekly change badge, 7-point sparkline and staleness indicator; tapping opens a
detail chart with 1W/1M/3M range chips. Prices come from a backend cron — there is no user input.

## 2. Screens & routes

| Screen | Route (constant) | Params | Notes |
|---|---|---|---|
| `presentation/screens/market_prices_list_screen.dart` | `RouteNames.marketPrices` / `RoutePaths.marketPrices` | none | Shell branch 2; route creates `MarketPricesListCubit..load()` |
| `presentation/screens/market_price_detail_screen.dart` | `RouteNames.marketPriceDetail` (RouteSegments.typeId) | typeId (path param) | `MarketPriceDetailCubit` is a factory param on typeId |

## 3. File map

| Layer | Key files | Responsibility |
|---|---|---|
| screens | `presentation/screens/market_prices_list_screen.dart`, `presentation/screens/market_price_detail_screen.dart` | State switches + disclosure; detail reuses two assets widgets |
| widgets | `presentation/widgets/market_price_card.dart` | Tappable card navigating to detail |
|  | `presentation/widgets/price_sparkline.dart` | Axis-less mini chart, glance-only |
|  | `presentation/widgets/stale_data_indicator.dart` | "Updated Xh ago", warning styling when stale |
|  | `presentation/widgets/range_selector_chips.dart` | 1W / 1M / 3M selection |
|  | `presentation/widgets/market_prices_skeleton.dart` | Geometry-matched shimmer |
|  | `presentation/widgets/data_source_disclosure.dart` | "Spot rates, not local goldsmith prices" disclaimer |
| cubits | `presentation/cubits/market_prices_list_cubit/` and `market_price_detail_cubit/` (cubit + state each) | List + detail state |
| domain | `domain/entities/market_price_summary_entity.dart`, `domain/entities/market_price_point_entity.dart`, `domain/repositories/market_prices_repository.dart` | Entities + contract |
| usecases | `domain/usecases/get_market_price_summaries_usecase.dart`, `domain/usecases/get_market_price_range_usecase.dart`, `domain/params/get_market_price_range_params.dart` | 2 usecases + params |
| data | `data/repositories/market_prices_repository_impl.dart` (no datasource of its own) | Composes assets usecases; adapts price rows via `MarketPricePointEntity.fromMarketPrice`; owns an in-memory TTL cache + request de-duplication per type code |

## 4. Entities & models

| Entity | Key fields | Model (data) | Notes |
|---|---|---|---|
| `MarketPriceSummaryEntity` | assetType, todayPrice?, todayPriceDate?, fetchedAt?, weeklyChangePercent?, sparklinePoints | none | Getters: hasHistory, isGain, isStale (over 36h) |
| `MarketPricePointEntity` | date, price | — |  |
| `GetMarketPriceRangeParams` | assetTypeCode, from, to | — |  |

## 5. Use cases

| UseCase | Input | Output | Business rule (if any) |
|---|---|---|---|
| `GetMarketPriceSummariesUseCase` | `forceRefresh` (named, default false) | ApiResult(List of MarketPriceSummaryEntity) | One summary per market-based type; per-type failures are tolerated, only all-fail propagates |
| `GetMarketPriceRangeUseCase` | `GetMarketPriceRangeParams` | ApiResult(List of MarketPricePointEntity) | Repo filters inclusive from..to; shares the cached history read |

## 6. API & storage

| Key (constant) | Used by | Cache policy |
|---|---|---|
| (via assets) `SupabaseTables.assetTypes`, `SupabaseTables.marketPrices` | consumed through `GetAssetTypesUseCase` and `GetMarketPriceHistoryUseCase` | none of its own |

No datasource: the feature is a pure read model over the assets feature's data layer.
`AppConstants.marketPriceCacheDuration` (12h) bounds the repository's in-memory per-type history
cache: reads inside the window are served locally, list/detail/range share one fetch per type, a
failed refetch serves the stale entry, and pull-to-refresh bypasses the cache (`forceRefresh`).

## 7. State

- `MarketPricesListCubit`: MarketPricesListLoading / Loaded(summaries) / Error. load() emits
  Loading; refresh() deliberately does not (keeps the list mounted so entrance animations do not
  replay; the RefreshIndicator owns the spinner) and passes `forceRefresh: true` to skip the TTL
  cache.
- `MarketPriceDetailCubit` (typeId param): Loading / Loaded(assetType, points, selectedRange,
  daysCovered) / Error. Loads the default range (oneWeek) in the constructor; loadRange refetches;
  remembers the last range. `MarketPriceRangeOption`: oneWeek / oneMonth / threeMonths (7/30/90
  days).
- Pagination: none.

## 8. Dependencies

- Depends on (core): AppContentBox, AppEmptyState, AppErrorState, AppSurfaceCard, AppLineChart,
  PercentChangeBadge, AppAnimatedEntry/EntryAnimationType/AppMotion, AppSpacing/AppRadius/AppSizes,
  Responsive, CurrencyFormatter, context extensions, failure localization, Decimal extensions,
  failures, ApiResult, RouteNames.
- Depends on (features): assets — domain entities + 2 usecases (composed through the repository;
  the presentation widgets now come from core/widgets).
- Used by (features): none. DI: `core/di/market_prices_module.dart` — repo, 2 usecases, list cubit
  factory, detail cubit factory param.

## 9. Localization

- Namespace: `marketPrices` — title, dataSourceDisclosure, lastUpdated, notEnoughHistory,
  showingAvailableData (pluralized), emptyTitle, emptyBody, range (oneWeek/oneMonth/threeMonths).

## 10. Business rules & edge cases

- Summaries are built only for types with isMarketBased = true.
- Weekly change = the nearest row on or before (latest priceDate − 7 days) — explicitly not an
  exact 7-days-ago row (cron gaps); null when there is no baseline row or the baseline price is 0.
- Sparkline = the last 7 history rows (all rows when there are ≤ 7).
- Staleness: fetchedAt older than 36 hours → stale (covers the 6-hour cron cadence plus 1-2 missed
  runs).
- The detail range filter is inclusive on both ends; daysCovered feeds the "showing available data"
  message.

## 11. Tests

| Area | Test files | Covered behaviors |
|---|---|---|
| repo | test/features/market_prices/data/repositories/market_prices_repository_impl_test.dart + market_prices_repository_impl_cache_test.dart (+ fixtures) | summary + range assembly; TTL window, forceRefresh, stale fallback, cache sharing |
| domain | test/features/market_prices/domain/usecases/get_market_price_summaries_usecase_test.dart, get_market_price_range_usecase_test.dart | delegation to the repository |
| cubits | test/features/market_prices/presentation/cubits/market_prices_list_cubit_test.dart, market_price_detail_cubit_test.dart | transitions + ranges |
| widgets/screens | test/features/market_prices/presentation/widgets/{market_price_card,price_sparkline,stale_data_indicator,range_selector_chips,data_source_disclosure}_test.dart, presentation/screens/{market_prices_list,market_price_detail}_screen_test.dart | card, sparkline, staleness, chips, disclosure + both screens |

## 12. Known issues

- ANIM-2: raw `AnimatedSwitcher` in presentation widgets waits for the core primitive (needs a
  decision).
- The detail screen has no pull-to-refresh, and every range change re-emits full Loading (content
  flashes).

## 13. Changelog

- 2026-10-26 — Initial doc created from code (doc-sync).
- 2026-10-26 — Refactor (DATA-5): MarketPricePointMapper dissolved into
  `MarketPricePointEntity.fromMarketPrice` / `toMarketPrice()`.
- 2026-10-26 — Refactor (WIDGET-3): AssetTypeTile + MarketPriceChart now come from core/widgets;
  the detail screen no longer imports the assets feature's presentation (ARCH-1 resolved).
- 2026-10-26 — Refactor (STATE-3/BASE-3): exhaustive state switch for the app bar title; the
  loading body uses AppLoader.
- 2026-10-27 — Caching: in-memory TTL cache per type code (AppConstants.marketPriceCacheDuration,
  injectable clock), list/detail/range request de-duplication, stale-serve on refetch failure,
  forceRefresh for pull-to-refresh; repo test split into main + cache files.
- 2026-10-27 — TEST-1: added usecase, widget (sparkline, staleness, chips, disclosure) and detail
  screen tests.
