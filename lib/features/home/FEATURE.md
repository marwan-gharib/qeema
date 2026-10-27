# Home

> Last verified: 2026-10-26
> Path: `lib/features/home/`

## 1. Purpose

The app dashboard and first tab: total nominal savings (EGP-converted), inflation-adjusted real
total, an erosion ring (purchasing power lost), per-asset-type mini cards with day change, and a
30-day real-value trend line.

## 2. Screens & routes

| Screen | Route (constant) | Params | Notes |
|---|---|---|---|
| `presentation/screens/home_screen.dart` | `RouteNames.home` / `RoutePaths.home` | none | Shell branch 0; the route creates the HomeCubit from getIt and calls loadDashboard() |

## 3. File map

| Layer | Key files | Responsibility |
|---|---|---|
| screens | `presentation/screens/home_screen.dart` | State switch (Loading/Error/Empty/Loaded), RefreshIndicator, staggered entries |
| widgets | `presentation/widgets/dashboard_summary_card.dart` | Nominal + real totals card |
|  | `presentation/widgets/erosion_ring.dart` | Custom-paint ring with the erosion % |
|  | `presentation/widgets/asset_type_mini_card.dart` | Horizontal type cards with day change |
|  | `presentation/widgets/real_value_trend_chart.dart` | `AppLineChart` of snapshots |
|  | `presentation/widgets/dashboard_skeleton.dart` | Shimmer skeleton matching the loaded geometry |
| cubits | `presentation/cubits/home_cubit/home_cubit.dart` + `presentation/cubits/home_cubit/home_state.dart` | Dashboard state |
| domain | `domain/entities/dashboard_summary_entity.dart`, `domain/entities/portfolio_snapshot_entity.dart`, `domain/entities/asset_type_summary_entity.dart`, `domain/repositories/home_repository.dart` | Entities + contract |
| usecases | `domain/usecases/get_dashboard_summary_usecase.dart` | The single usecase |
| data | `data/datasources/home_remote_datasource.dart`, `data/models/market_price_row.dart`, `data/models/inflation_rate_row.dart`, `data/models/portfolio_snapshot_row.dart` (with `toEntity()`), `data/repositories/home_repository_impl.dart` + `data/repositories/home_repository_impl_support.dart` | Supabase reads + assembly |

## 4. Entities & models

| Entity | Key fields | Model (data) | Notes |
|---|---|---|---|
| `DashboardSummaryEntity` | nominalTotal, realTotal, assetTypeSummaries, trend30Days | none | `erosionPercent` getter (clamped 0-100), `hasAssets` |
| `AssetTypeSummaryEntity` | assetType, currentValue, dayChangePercent, hasSufficientPriceHistory | none | `isDayGain` getter |
| `PortfolioSnapshotEntity` | date, realTotal | `PortfolioSnapshotRow` |  |
| — | — | `MarketPriceRow`, `InflationRateRow` | Raw table rows |

## 5. Use cases

| UseCase | Input | Output | Business rule (if any) |
|---|---|---|---|
| `GetDashboardSummaryUseCase` | none | ApiResult(DashboardSummaryEntity) | Pass-through; assembly lives in the repo support |

## 6. API & storage

| Key (constant) | Used by | Cache policy |
|---|---|---|
| `SupabaseTables.marketPrices` | `HomeRemoteDataSource.getMarketPrices` | None (network only) |
| `SupabaseTables.inflationRates` | `getInflationRates` | None |
| `SupabaseTables.portfolioSnapshots` | `getPortfolioSnapshots` (scoped by user) | None; the table is manually seeded for this build |

## 7. State

- Cubit: `HomeCubit` — Cubit.
- States: HomeLoading, HomeLoaded(summary), HomeError(failure).
- Transitions: loadDashboard → Loading → Loaded/Error; refresh() == loadDashboard() (so
  pull-to-refresh replays the skeleton — see Known issues). Pagination: none.

## 8. Dependencies

- Depends on (core): AppContentBox, AppEmptyState, AppErrorState, AppSurfaceCard, AppLineChart,
  AppAnimatedEntry/EntryAnimationType/AppMotion/TapScale/shimmer, AppSpacing/AppRadius/AppSizes,
  Responsive, context extensions, failure localization, Decimal extensions, CurrencyFormatter, t,
  ApiResult, asset_type_parsing, CurrencyConverter, InflationCalculator, SupabaseQueryExecutor,
  RouteNames.
- Depends on (features): assets — domain entities + the `AssetsRepository` contract (home's data
  layer composes assets' repository directly; it no longer touches assets' usecases).
- Used by (features): none. DI: `core/di/home_module.dart`.

## 9. Localization

- Namespace: `home` — title, both totals, erosionCaption, trendSectionTitle, priceMoveBanner,
  errorTitle, retry, notEnoughTrendData. Also reads `assets.list.*` (empty state) and
  `charts.semantics.realValue` (chart semantics).

## 10. Business rules & edge cases

- erosionPercent = (nominal − real) / nominal × 100, clamped to 0-100; 0 when nominal is ≤ 0 —
  single source of truth, consumers must not re-derive it.
- Day change needs two distinct price dates and a non-zero previous price; otherwise
  hasSufficientPriceHistory is false (renders 0 but distinguishable from a flat day).
- Real value: inflation rows are filtered to entry-month → current month, then delegated to core
  `InflationCalculator`.
- Unknown asset-type codes are silently skipped; conversion failures contribute nothing to totals.

## 11. Tests

| Area | Test files | Covered behaviors |
|---|---|---|
| screen | test/features/home/presentation/screens/home_screen_test.dart | states + refresh |
| cubit | test/features/home/presentation/cubits/home_cubit_test.dart | transitions |
| widget | test/features/home/presentation/widgets/real_value_trend_chart_test.dart | chart empty/points |
| entity | test/features/home/domain/entities/dashboard_summary_entity_test.dart | erosion math |
| repo | test/features/home/data/repositories/home_repository_impl_test.dart (+ mocks) | assembly |

## 12. Known issues

- ARCH-1: RESOLVED 2026-10-26 — the data layer now depends on the injected `AssetsRepository`
  contract instead of assets' usecases (the usecases were pure pass-throughs, so behavior is
  unchanged).
- Dead code: the 2% significant-move threshold constant is never referenced; the i18n key
  home.priceMoveBanner is never rendered.
- refresh() re-emits Loading, so pull-to-refresh flashes the skeleton instead of keeping content.
- TEST-1: no tests for the usecase, the row models, or the datasource.

## 13. Changelog

- 2026-10-26 — Initial doc created from code (doc-sync).
- 2026-10-26 — Refactor (ARCH-1): HomeRepositoryImpl composes assets' `AssetsRepository` contract
  instead of its GetAssets/GetAssetTypes usecases (pure pass-throughs — no behavior change).

- 2026-10-26 — Initial doc created from code (doc-sync).
- 2026-10-26 — Refactor (DATA-4/5): PortfolioSnapshotMapper dissolved into the row's `toEntity()`;
  row JSON keys moved to SupabaseColumns constants.
