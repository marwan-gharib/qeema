# Features Index

One row per feature. For any feature task: read this index, then the feature's `FEATURE.md`, then
only the source files you need (DOC-1).

> Last verified: 2026-10-26

| Feature | Purpose | Doc | Routes | Depends on |
|---|---|---|---|---|
| splash | Animated brand intro on cold start; auto-navigates to onboarding | lib/features/splash/FEATURE.md | RoutePaths.splash | none |
| onboarding | Four-slide first-launch intro; persists the seen flag the router guard enforces | lib/features/onboarding/FEATURE.md | RoutePaths.onboarding | none |
| auth | Google or guest (anonymous) sign-in on the welcome screen | lib/features/auth/FEATURE.md | RoutePaths.welcome | none |
| app_lock | Optional device-credential lock shielding the whole app | lib/features/app_lock/FEATURE.md | RoutePaths.lock | none |
| home | Dashboard: nominal/real totals, erosion ring, per-type day change, 30-day trend | lib/features/home/FEATURE.md | RoutePaths.home | assets (domain) |
| assets | Holdings CRUD: list/filter/sort, add, detail + history, edit, soft delete | lib/features/assets/FEATURE.md | RoutePaths.assets (+ add/detail/edit children) | none — foundation for home and market_prices |
| market_prices | Read-only USD/gold market rates with sparklines and range charts | lib/features/market_prices/FEATURE.md | RoutePaths.marketPrices (+ detail child) | assets (domain, via repository contract and usecases); shared widgets come from core/widgets |
| settings | Profile, app-lock toggle, language/theme, logout, delete account | lib/features/settings/FEATURE.md | RoutePaths.settings | auth, app_lock |

Notes:

- Cross-feature use is allowed only through domain usecases or core (ARCH-1). Known violations are
  recorded in the offending features' docs (market_prices → assets presentation; home data layer →
  assets usecases).
- `core/utils/asset_type_parsing.dart` imports the assets feature's entity — the only core→feature
  import (see docs/CORE_MAP.md, Known exceptions).
