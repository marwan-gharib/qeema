# Core Map

Index of every reusable piece in `lib/core/`. Read this before writing any code (BASE-1), then open
the files you will use — start from the barrels. When code and this file disagree, the code wins and
this file is fixed in the same task (DOC-1, DOC-6).

> Last verified: 2026-10-26

## Shared widgets — `core/widgets/`, import via `widgets.dart`

| Piece | Purpose |
|---|---|
| `AppButton` | Filled button; `isOutline` / `isText` variants, `isLoading` spinner, `prefixWidget`. |
| `AppTextField` | Themed text field; password toggle, validator, keyboard/action params. |
| `AppLoader` | Centered spinner + optional message. |
| `AppSnackBar` | Static `show` / `showError` snackbars (error tints with `colorScheme.error`). |
| `AppErrorState` | Error glyph + message (defaults to `context.t.core.error.body`) + retry `AppButton`. |
| `AppEmptyState` | Empty state: icon/title/subtitle + optional action; `container` embedded mode. |
| `AppContentBox` | Caps content width to the reading measure (672) and centers it. |
| `AppSurfaceCard` | Rounded `surfaceAlt` card shell, optional tap via `TapScale`. |
| `AppLineChart` | `fl_chart` line chart: themed axes, tooltip, gradient, semantics; always LTR. |
| `AppChartDirectionality` | Forces a chart subtree LTR + attaches a localized semantics summary. |
| `InsightCard` | Accent-bar card for a financial `Insight` (color by severity). |
| `PercentChangeBadge` | Signed-percentage pill: green gain / error loss / dash when null. |
| `AssetTypeTile` | Selectable asset-type tile from a type code: localized name, icon, carat badge; `iconForType(code)`. |
| `MarketPriceChart` | Value-trend chart card: caller-localized `title` + `List<AppChartPoint>`; fixed 250 height. |

## Animations — `core/animations/`, import via `animations.dart`

Cheat sheet with the full API: `lib/core/animations/README.md`.

| Piece | Purpose |
|---|---|
| `AppMotion` | All motion tokens: durations (fast/normal/slow, staggerStep, hero*, splashSequence) and curves (entrance/exit/emphasized/standard). |
| `EntryAnimationType` | fadeIn, fadeSlideUp/Down/Right, scaleIn, popIn, none. |
| `AppAnimatedEntry` | Plays one entrance on mount; honours reduced motion. |
| `StaggeredListAnimator` | Wraps list children in `AppAnimatedEntry` with a capped per-item delay. |
| `TapScale` | Press-down scale feedback. |
| `SuccessPulse` | One-shot pulse + checkmark when a trigger flips. |
| `AnimatedCounter` | Counts between `Decimal` values with a formatter. |
| `ShimmerBox` / `ShimmerLine` / `ShimmerCard` / `ShimmerListPlaceholder` | Skeleton placeholders. |
| `fadeThroughPage` / `slideUpPage` / `sharedAxisPage` | go_router page transitions (used by core/router only). |

## Theme — `core/theme/`

- `AppTheme.light()` / `AppTheme.dark()` register two `ThemeExtension`s, read back via
  `context.colors` / `context.textStyles`.
- `AppColors` (12 fields, `light`/`dark` presets) + `AppColorsExtension`; `AppTextStylesExtension`.
- Tokens: `AppSpacing` (xxxs..xxl), `AppRadius` (xxs..xl), `AppSizes` (icons, minTouchTarget,
  avatar, loader), `AppBorders` (hairline/emphasis), `AppElevation` (none/card), `AppTextTheme`,
  `appColorScheme()`.

## Responsive — `core/responsive/`

- `Responsive` — static facade: `width`/`height`/`radius`/`font`/`adapt`, `configure`,
  `bind`/`unbind`; design size 375x812.
- `ResponsiveScope` wraps the app in `main.dart` and feeds MediaQuery in.
- `ResponsiveScaler` + `ScreenUtilScaler` (the only file allowed to import flutter_screenutil).

## Router — `core/router/`

- Constants: `RouteNames`, `RoutePaths`, `RouteSegments` (path-param names such as `:assetId`).
- `AppRouter.router` — GoRouter with a `refreshListenable` (auth + lock) and
  `redirectUnauthenticated`.
- `AppRouterRoutes.buildRoutes` / `buildShellRoute` — every route; screens wrapped in `BlocProvider`
  created from `getIt`; transitions via the animation folder's page functions.
- `AppProviders` — the app-scoped `BlocProvider`s above the router (locale, theme, app lock); the
  only `getIt` zone outside `core/di/` besides the route builders.
- `RouteGuards` — auth + onboarding redirect logic; `AppLockGate` interface implemented by
  `AppLockCubit`.

## DI — `core/di/`

- `injection_container.dart`: `final getIt = GetIt.instance;` and `initDependencies()` calling the
  modules in order (core → onboarding → auth → assets → home → marketPrices → settings → appLock →
  google-sign-in), then `RouteGuards` last (breaks a documented onboarding circular dependency).
- `core_module.dart` registers network, storage, the drift database + 7 DAOs, connectivity, the
  financial engine + 4 `InsightRule`s, `LocaleCubit`/`ThemeCubit`; one module file per feature.
- Conventions: `lib/core/di/feature_module_registry.md`.

## Network — `core/network/` (Supabase-based; there is no dio / BaseApiClient)

- `SupabaseClientProvider.client` — the single Supabase entry point.
- `SupabaseQueryExecutor.run` — the error seam: every query is wrapped, exceptions map through
  `mapExceptionToFailure` into `ResultFailure`.
- `NetworkInfo` — connectivity stream/state (plus `ConnectivityService` in services).

## Local storage — `core/local/`

- `secure/` — `SecureStorageService` (abstract) + impl (flutter_secure_storage).
- `cache/` — `CacheService` (abstract) + `CacheServiceImpl` (SharedPreferences); `AppDatabase`
  (drift) with 7 cached tables + 7 DAOs (assets, asset history, market prices, inflation rates,
  portfolio snapshots, savings goals, asset types) and `clearAll()`.

## Errors — `core/error/` (folder name is `error`, not `errors`)

- `failures.dart` — sealed `Failure` hierarchy (cache/network/server/auth/local-auth/asset/...)
  plus the `FinancialFailure` subtree.
- `exceptions.dart` — app exceptions.
- `failure_mapper.dart` — `mapExceptionToFailure(...)`: the single exception → Failure mapper
  (Supabase Postgrest/Auth/Functions, socket, http).

## Utils — `core/utils/`

- `ApiResult` — sealed Success / ResultFailure with `fold` (helpers in
  `core/extensions/api_result_extensions.dart`).
- `Logger.info/warning/error`; `Validators.amount`.
- `asset_type_parsing.dart` — AssetType code mapping (currently imports the assets feature's
  entity — the one core→feature import, see Known exceptions).

## Extensions — `core/extensions/`

- `context.colors` / `context.textStyles` / `colorScheme` / `theme` / `textTheme` and
  `context.assetTypeName(code)` (slang provides `context.t`).
- `failure.localizedMessage(context)` — the single Failure → text switch.
- `Decimal`: `toCurrency`, `toPercentage`, `roundTo`, `divideBy`; `DateTime`: `toDisplayDate`,
  month start/end; `ApiResult`: `isSuccess`, `isFailure`, `failureOrNull`, `dataOrNull`.

## Helpers — `core/helpers/`

`CurrencyFormatter.format/formatCompact/currencyName` · `DateFormatter.format/monthYear/formatShort`
· `Validators.amount`.

## Services — `core/services/`

`DeviceAuthService` (local_auth → LocalAuth* failures) · `WindowSecurityService` (recents-preview
platform channel) · `LocalNotificationService` (price alerts) · `ConnectivityService`.

## Financial engine — `core/financial/`

- `CurrencyConverter.toBaseCurrency` (base = `AssetTypeCodes.cashEgp`) · `AssetValuator` (current
  value, unrealized gain/loss) · `InflationCalculator.calculateRealValue` (fails with
  `InflationDataMissingFailure` / `CalculationFailure`) · `FinancialInsightEngine` running injected
  `InsightRule`s (InflationLoss, AssetPerformance, ConcentrationRisk, GoalFeasibility).
- `models/` — Money, Insight (+ InsightType/InsightSeverity), AssetInBaseCurrency,
  PortfolioSnapshotData, MonthlyInflationRate.

## Constants — `core/constants/` (ARCH-10: every key/path/identifier lives here)

`SupabaseTables` (assets, assetTypes, assetHistory, marketPrices, inflationRates,
portfolioSnapshots, savingsGoals, userDevices) · `SupabaseBuckets.userAvatars` · `AssetTypeCodes`
(cashEgp, usd, gold21, gold24) · `AppAssets` (qeemaLogo, googleLogo) · `AppConstants` (timeouts,
pageSize, cache durations, storage keys, DELETE phrase) · `EnvConfig` (Supabase url/key from
--dart-define) · `ChartConstants.alwaysChartsLtr`.

## Navigation shell — `core/navigation/`

`AppShell` + `BottomNavBar` (floating dock) + `BottomNavItem` / `BottomNavItemConfig` (home,
assets, marketPrices, settings — order must match the shell branches) + `NavBarMotion` tokens.

## Core cubits — `core/cubits/`

`ThemeCubit` (AppThemeState; persists via `AppConstants.appThemeModeKey`) · `LocaleCubit`
(LocaleState; `AppConstants.appLocaleKey`) — app-wide lazy singletons provided in `main.dart`.

## i18n — `core/i18n/` (slang-generated, never edit by hand)

`strings.g.dart` exports `t`, `TranslationProvider`, `LocaleSettings`; locales en/ar; sources in
`assets/i18n/*.i18n.json`; access via `context.t`.

## App bootstrap

`main.dart`: Supabase.initialize → `initDependencies()` → locale + date-format init →
`Responsive.ensureInitialized()` → runApp(MultiBlocProvider(LocaleCubit, ThemeCubit, AppLockCubit)
→ TranslationProvider → AppLockLifecycleObserver → AppRoot; `AppLockOverlay` wraps the router
inside `lib/app_root.dart`).

## Known exceptions & gaps (audit 2026-10-26)

- Both barrels were just created; features still import core files directly — migrate
  opportunistically, never in a drive-by (CORE-8).
- Rules reference pieces that do not exist yet: AppAnimatedSwitcher, AnimatedVisibility,
  ExpandableSection, AppDialog/showAppDialog, AppBottomSheet, AppHaptics, AppLottie,
  AppRoute.create, AppHero, PagedResult, BaseApiClient. Build the core piece before a feature
  needs it (BASE-4, ANIM-3) — do not substitute the raw SDK.
- `core/utils/asset_type_parsing.dart` imports the assets feature's entity (core→feature, ARCH-1
  exception to resolve).
- drift + build_runner in `core/local/cache/app_database.dart` conflicts with ARCH-8 — pending
  decision (replace with hand-written persistence or approve an exception).
