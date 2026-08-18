# Qeema

**Track what your money is actually worth — not just what it says.**

[![Flutter](https://img.shields.io/badge/Flutter-3.47.0-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12.2-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Built with Supabase](https://img.shields.io/badge/Supabase-Built%20with-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)

---

## Table of Contents

- [Screenshots](#screenshots)
- [Overview](#overview)
- [Key Features](#key-features)
- [Why This Project Is Technically Interesting](#why-this-project-is-technically-interesting)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Database Schema](#database-schema)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Testing](#testing)
- [Design System](#design-system)
- [Scope and Deliberate Simplifications](#scope-and-deliberate-simplifications)
- [Roadmap](#roadmap)
- [Author](#author)
- [License](#license)

---

## Screenshots

<!-- TODO: add screenshots when assets are ready.
     Suggested grid: 3 columns via <table> with captions:
     - "Home Dashboard — nominal total vs. real total, erosion ring"
     - "Asset Detail — value trend & audit timeline"
     - "Market Prices — daily rates with 1W/1M/3M range chart"
     Images should be committed under docs/screenshots/ (or similar). -->

Screenshots coming soon. The app ships with light and dark themes, full Arabic (RTL) and English localization, and a warm Amber/Gold + Green palette — see the [Design System](#design-system) section for the color reference.

---

## Overview

Qeema is a personal finance tracker built for the Egyptian market — where a bank balance in EGP says one thing, and what that balance can actually *buy* says another. Since 2022 the EGP has been devalued repeatedly and inflation has run in the double digits; in that context, an account statement that ignores inflation is telling you almost nothing.

The app's core idea is simple: track your savings in **nominal** terms, and also in **real** terms — adjusted month-by-month for actual inflation — so you can see your purchasing power erode, hold, or grow over time. It's designed for the savings mix that is common in Egypt but awkward in most finance apps: EGP cash, US dollars, and physical gold (21k and 24k). Market-based holdings are valued at the latest fetched price and converted to EGP; EGP cash is valued at face value.

Qeema deliberately does **not** move money. There is no payment processing, no bank connection, no buying or selling — it is purely a tracking and insight tool. That boundary is a scope decision, not a limitation: the entire product surface is valuation, inflation-adjusted reporting, and honest numbers about what your savings are doing.

---

## Key Features

- **Asset tracking** — EGP cash, USD, and gold (21k/24k) holdings with add/edit/soft-delete, per-type filtering and sorting, and a full audit timeline of every create/update/delete.
- **Gain/loss on every holding** — market-based assets are valued at the latest fetched price; the detail screen shows the gain/loss amount and percentage against the entry price, computed with `decimal` (exact) arithmetic.
- **Inflation-adjusted dashboard** — the home screen shows nominal and real portfolio totals, an erosion ring with the percent gap between them, per-type cards with day change, and a 30-day trend of real value.
- **Market prices** — daily EGP/USD exchange rate and gold prices (EGP/gram) ingested by a scheduled server-side Edge Function (pg_cron), with a list of today's prices, weekly change, sparklines, and a 1W/1M/3M range chart per asset type.
- **Anonymous sign-in** — zero-friction Supabase Auth sign-in, no email or password; every session is a fresh identity with its own data.
- **Biometric app lock** — optional device-level fingerprint/FaceID lock (via `local_auth`) with a toggle in Settings.
- **Bilingual** — complete Arabic (RTL) and English localization via `slang`, switchable at runtime in Settings.
- **Secure account deletion** — a server-side erasure flow through a JWT-verified Edge Function that deletes all user rows in FK-safe order, then clears local data — not just a local reset.

---

## Why This Project Is Technically Interesting

**An isolated, independently testable financial engine.** `lib/core/financial/` contains zero Flutter, Bloc, or Supabase imports — it is pure Dart: inflation calculation, currency conversion, asset valuation, and insight-rule classes. Money-handling logic lives in exactly one place and depends on nothing, which matters because correctness in financial math is non-negotiable and is the hardest thing to test when it's smeared across widgets and repositories.

**Correct compound inflation math.** Real value is computed by compounding each monthly rate over the holding period:

```text
RealValue = NominalValue / Π(1 + monthly_rate_i)   for each month i in [entry, today]
```

The naive alternative — dividing once by a single accumulated rate — is wrong for multi-month periods, because each month's inflation compounds on the previous month's result. The implementation also validates that no month in the range is missing inflation data, and reports a typed failure if it is, rather than silently returning a wrong number.

**Row-driven asset types.** Asset types are catalog rows in Postgres — `code`, `name`, `is_market_based`, `base_unit` — and valuation behavior keys off those columns, not off code branches. The client maps the four known codes (`cash_egp`, `usd`, `gold_21`, `gold_24`) onto a small enum, so the source of truth is the database row.

**Row-Level Security as the actual security boundary.** Data isolation between users is enforced in Postgres itself — every user-data table's policies are scoped to `auth.uid() = user_id` (14 policies across 8 tables). Even on anonymous auth sessions, a client can only ever read or write its own rows; the application layer is not the trust boundary.

**Two real, deployed Edge Functions, not mocked backend behavior.**

- `fetch-daily-prices` — scheduled via two active pg_cron jobs (every 3 and 6 hours): fetches the USD→EGP rate (free API) and gold prices (GoldAPI), converts gold to EGP/gram, and upserts into `market_prices`. Each data source fails independently: a GoldAPI outage records per-asset errors and still writes the USD rate.
- `delete-account` — JWT-verified deletion. The function derives the caller's identity from their own JWT via `getUser()` (never trusting a `user_id` from the request body), deletes user rows in FK-safe order, then removes the auth user. It returns a distinct partial-failure response if the rows were deleted but the auth record could not be.

**A real Drift cache layer, used honestly.** The app has a full local schema (`core/local/cache/` — 7 tables + DAOs mirroring the remote schema), but the cache is **write-through only**: asset mutations are mirrored into it with `pendingSync` flags, and reads are network-backed. It is wired infrastructure with a documented, narrower role than "offline-first" — the offline read path does not exist yet, and this is stated plainly in [Scope](#scope-and-deliberate-simplifications) rather than glossed over.

---

## Architecture

Qeema follows **feature-first Clean Architecture** with a strictly one-directional dependency flow: Presentation → Domain ← Data.

```text
Presentation (Cubits, screens, widgets)
        ↓  depends on
Domain (entities, usecases, repository contracts)   ← zero Flutter imports
        ↓  depends on
Data (datasources, models, repository implementations)
```

The presentation layer holds no business logic — a Cubit calls a usecase and maps the result to a sealed state; the UI exhaustively switches on that state. The domain layer defines repository *contracts* and usecases and imports no Flutter code. The data layer implements the contracts, talks to Supabase through a `BaseApiClient` (dio-based, with interceptors owning auth, logging, and error mapping) and to Drift through DAOs, and converts DTOs to entities via dedicated mappers. `ApiResult<T>` — with typed `Failure` subtypes — is the only result type that crosses layer boundaries.

Taking one feature as a concrete walkthrough:

```mermaid
flowchart LR
    subgraph Presentation
        Screen[AssetsListScreen] --> Cubit[AssetsListCubit]
    end
    subgraph Domain
        Cubit --> UC[GetAssetsUseCase]
        UC --> Repo[AssetsRepository<br/>(abstract contract)]
    end
    subgraph Data
        Repo --> Impl[AssetsRepositoryImpl]
        Impl --> Remote[AssetsRemoteDataSource]
        Impl --> Local[AssetsLocalDataSource]
        Remote --> PG[(Supabase Postgres<br/>guarded by RLS)]
        Local --> Drift[(Drift / SQLite cache)]
    end
```

**State management.** All 13 state classes in the app are Cubits. This is not a default-vs-exception rule — every flow in Qeema today is a straightforward "call a usecase → emit a state" cycle with no debouncing, throttling, event merging, or restartable/sequential processing requirements.

The rule being followed: *Cubit unless a flow genuinely needs event-stream transformation (debounce, concurrency control, multi-stream merging), in which case Bloc*. The codebase currently has no such flow, so there is no Bloc — and that is the decision, not an accident.

**Other cross-cutting choices:** `go_router` with a `StatefulShellRoute.indexedStack` shell and bottom navigation; route arguments are primitives/IDs, never entities; `get_it` for DI (Cubits registered as factories, usecases/repositories as lazy singletons); `slang` for i18n; `decimal` everywhere money is represented.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.47.0 (Dart 3.12.2) |
| State Management | flutter_bloc 9.1.1 (Cubit) |
| DI | get_it 9.2.1 |
| Navigation | go_router 17.3.0 (`StatefulShellRoute.indexedStack`) |
| Local Database | Drift 2.34.2 (SQLite, write-through cache) |
| Secure Storage | flutter_secure_storage 11.0.0 |
| Biometrics / App Lock | local_auth 3.0.2 |
| Backend | Supabase — Postgres 17, Auth, Edge Functions, pg_cron |
| HTTP | dio 5.10.0 |
| Charts | fl_chart 1.2.0 |
| Localization | slang 4.18.0 (Arabic + English, RTL-aware) |
| Precision Arithmetic | decimal 3.2.4 |
| Connectivity | connectivity_plus 7.3.0 |

---

## Database Schema

Eight tables in the `public` schema. The SQL lives in the hosted Supabase project; there is no in-repo schema file.

| Table | Purpose |
|---|---|
| `asset_types` | Catalog of asset kinds (`cash_egp`, `usd`, `gold_21`, `gold_24`) with `is_market_based` and `base_unit` |
| `assets` | User holdings (amount, entry price/date, note), soft-delete via `is_deleted` |
| `asset_history` | Audit trail — `created` / `updated` / `deleted` events with `jsonb` old/new snapshots |
| `market_prices` | Daily prices per asset type, upserted on `(asset_type_id, price_date)` |
| `inflation_rates` | Monthly inflation rates, one row per month (primary key) |
| `portfolio_snapshots` | Daily nominal/real portfolio totals per user, feeding the 30-day trend chart |
| `savings_goals` | Schema present; the feature is not built in the app |
| `user_devices` | Schema present; no push-notification pipeline exists |

**Security:** 14 RLS policies across the user-data tables, all scoped to `auth.uid() = user_id`. Reference tables (`asset_types`, `market_prices`, `inflation_rates`) are readable by any authenticated session via dedicated SELECT policies. The deletion Edge Function bypasses RLS with a service-role client — which is exactly why a server-side function is required for that flow.

---

## Project Structure

```text
lib/
├── core/
│   ├── constants/          # env config, shared constants
│   ├── error/              # Failure hierarchy
│   ├── financial/          # Pure-Dart financial engine (no Flutter imports)
│   │   ├── inflation_calculator.dart
│   │   ├── asset_valuator.dart
│   │   ├── currency_converter.dart
│   │   ├── financial_insight_engine.dart
│   │   └── insight_rules/  # inflation_loss, concentration_risk, ...
│   ├── network/            # BaseApiClient + interceptors
│   ├── local/              # secure/ (tokens) + cache/ (Drift tables & DAOs)
│   ├── di/                 # get_it registrations
│   ├── router/             # go_router routes, guards, names
│   ├── theme/              # AppColors extension, light/dark schemes
│   ├── widgets/            # AppButton, AppTextField, AppLoader, ...
│   └── utils/ helpers/ extensions/ cubits/ navigation/ animations/
└── features/
    ├── auth/               # anonymous sign-in, welcome screen
    ├── onboarding/
    ├── splash/
    ├── app_lock/           # biometric gate
    ├── assets/             # list / add / detail / edit
    ├── home/               # dashboard
    ├── market_prices/      # daily rates list + 1W/1M/3M range detail
    └── settings/           # theme, locale, app lock, delete account
        └── <feature>/
            ├── presentation/  # screens, widgets, cubits/
            ├── domain/        # entities, usecases, repositories (contracts)
            └── data/          # datasources, models, repositories/, mappers/
```

Every feature follows the same `presentation / domain / data` split; `core/` holds anything used by two or more features.

---

## Getting Started

**Prerequisites:** Flutter 3.47+ (Dart 3.12+).

1. Clone the repository:

   ```bash
   git clone https://github.com/marwan-gharib/qeema.git
   cd qeema
   ```

2. Create a Supabase project and apply the schema (the 8 tables + RLS policies from [Database Schema](#database-schema)). Deploy the two Edge Functions (`fetch-daily-prices`, `delete-account`) and set the `GOLDAPI_KEY` secret for `fetch-daily-prices`. The schema and functions live in the hosted project — a fully functional clone requires recreating them there.

3. Configure the environment. Copy the example file and fill in your Supabase URL and publishable key (modern `sb_publishable_...` format):

   ```bash
   cp env.example.json env.json
   # edit env.json: SUPABASE_URL + SUPABASE_PUBLISHABLE_KEY
   ```

4. Install dependencies:

   ```bash
   flutter pub get
   ```

5. Run:

   ```bash
   flutter run --dart-define-from-file=env.json
   ```

**VS Code convenience:** the repo's `.vscode/launch.json` already defines a `Qeema (dev)` configuration that passes `--dart-define-from-file=env.json` — just select it and press F5.

---

## Testing

```bash
flutter test
```

The suite has 50 test files (15 in `core/`, 35 across features), with the heaviest coverage on Cubits, presentation widgets, repository implementations, and core services/helpers. One behavior per test. There are deliberately no integration tests — the app's risk surface is the logic and state handling, which unit and widget tests cover far more cheaply.

Two honest gaps, both stated rather than hidden: `core/financial/` has no direct unit tests yet (it is exercised indirectly, through mocks, by the home repository tests), and the financial engine's rule classes are not surfaced in any screen.

---

## Design System

A warm **Amber/Gold + Green** palette designed to feel optimistic rather than like a sterile banking app — gold echoing the app's actual subject matter, green reading as growth. Light and dark variants; all colors are consumed in widgets exclusively through `Theme.of(context)` and a `ThemeExtension`, never raw constants.

| Role | Light | Dark |
|---|---|---|
| Primary (Amber) | `#F5A623` | `#F0B84D` |
| Secondary (Green) | `#A8CD3A` | `#B5D66B` |
| Positive / growth | `#6FBF73` | `#7FCB83` |
| Error / loss (Terracotta) | `#D96C4B` | `#E38468` |
| Background | `#FFFBF2` | `#17160F` |
| Surface | `#FFFFFF` | `#221F17` |

Chart semantics: green lines carry value data — the home screen's 30-day real-value trend and the market-price charts. Amber is reserved for primary actions and key numbers; green/terracotta encode positive/negative movement (gain/loss banners, day-change badges).

---

## Scope and Deliberate Simplifications

These are decisions, made deliberately for a portfolio-scoped build, and each has a documented upgrade path:

- **No notifications feature at all.** A local-notification service is registered in DI but no flow triggers it; the FCM pipeline (webhook → Edge Function → push) is out of scope. The `user_devices` table exists in the schema, ready for it.
- **Not offline-first (yet).** The Drift cache is write-through only: asset mutations are mirrored locally with `pendingSync` flags, but reads are network-backed and there is no sync-on-reconnect. Full offline reads and a pending-sync flush are the natural next step and are on the [Roadmap](#roadmap).
- **Manual/periodic inflation data curation.** There is no free automated source of Egyptian monthly inflation rates, so the rates are curated and inserted periodically. The ingestion mechanism (`inflation_rates` + the compound calculator) is real; only the upstream is manual.
- **EGP as fixed base currency.** Everything is denominated in EGP by design — the market being served is an EGP-denominated one.
- **Scheduled, not live, prices.** `fetch-daily-prices` runs on pg_cron; there is no real-time price stream. For a personal tracker, daily granularity is the honest requirement.
- **No money movement.** No payments, no bank connections, no brokerage — the app's entire surface is tracking and insight, which is a legitimate product boundary, not a gap.
- **No integration tests.** Unit and widget tests cover the real risk surface; integration scaffolding would spend effort on infrastructure this project deliberately doesn't run.

---

## Roadmap

- **Savings Goals** — the schema already exists; build the feature (track progress against an inflation-adjusted target).
- **Insights engine UI** — the engine and four rule classes (inflation loss, concentration risk, asset performance, goal feasibility) already live in `core/financial/`; no screen consumes them yet.
- **Offline reads + pending-sync flush** — the cache layer and `pendingSync` flags are in place; wire the read fallback and reconnect sync to make the offline story real.
- **Dedicated unit tests for `core/financial/`** — the engine's correctness deserves direct coverage.
- **Live price feeds / automated inflation ingestion** — swap the scheduled jobs for streaming sources when one exists.

---

## Author

**Marwan Gharib**

- GitHub: [marwan-gharib](https://github.com/marwan-gharib)
- LinkedIn: [marwan-gharib](https://www.linkedin.com/in/marwan-gharib)
- Email: [marwanghareeb146@gmail.com](mailto:marwanghareeb146@gmail.com)

---

## License

Released under the [MIT License](LICENSE).