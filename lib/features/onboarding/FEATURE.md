# Onboarding

> Last verified: 2026-10-26
> Path: `lib/features/onboarding/`

## 1. Purpose

Four-slide introduction on first launch (money value, asset tracking, inflation chart, get
started). Skip / Next / Get Started persist a seen flag and land on the welcome screen. The router
forces every route to onboarding until the flag is set.

## 2. Screens & routes

| Screen | Route (constant) | Params | Notes |
|---|---|---|---|
| `presentation/screens/onboarding_screen.dart` | `RouteNames.onboarding` / `RoutePaths.onboarding` | none | BlocProvider from `getIt` (factory); listener navigates to welcome on completion |

## 3. File map

| Layer | Key files | Responsibility |
|---|---|---|
| presentation screens | `presentation/screens/onboarding_screen.dart` | Gradient scaffold + completed listener |
| presentation widgets | `presentation/widgets/onboarding_page_view.dart` | PageView + Skip/Next, swipe↔cubit loop guard |
|  | `presentation/widgets/onboarding_slide.dart` | One slide: illustration + headline + body in `AppContentBox` |
|  | `presentation/widgets/onboarding_page_indicator.dart` | Animated dots |
|  | `presentation/widgets/onboarding_illustration.dart` | Switch on the illustration type enum |
|  | `presentation/widgets/money_value_illustration.dart`, `presentation/widgets/asset_tracking_illustration.dart`, `presentation/widgets/inflation_chart_illustration.dart`, `presentation/widgets/get_started_illustration.dart` | The four illustrations |
|  | `presentation/widgets/diverging_lines_painter.dart`, `presentation/widgets/asset_icon.dart` | Custom painter + icon chip |
| cubits | `presentation/cubits/onboarding_cubit/onboarding_cubit.dart`, `presentation/cubits/onboarding_cubit/onboarding_state.dart` | Page state + completion |
| domain | `domain/repositories/onboarding_repository.dart`, `domain/usecases/get_onboarding_seen_usecase.dart`, `domain/usecases/complete_onboarding_usecase.dart` | Contract + 2 usecases |
| data | `data/repositories/onboarding_repository_impl.dart` | CacheService-backed flag |

## 4. Entities & models

none — the current page is a plain int.

## 5. Use cases

| UseCase | Input | Output | Business rule (if any) |
|---|---|---|---|
| `GetOnboardingSeenUseCase` | none | ApiResult(bool) | Consumed by `RouteGuards` (core), not by this Cubit |
| `CompleteOnboardingUseCase` | none | ApiResult(void) | Called on Skip and on Next from the last page |

## 6. API & storage

| Key (constant) | Used by | Cache policy |
|---|---|---|
| `AppConstants.onboardingCompletedKey` | `OnboardingRepositoryImpl.hasSeenOnboarding` / `markOnboardingSeen` via `CacheService` | SharedPreferences; read failure → ResultFailure(CacheFailure) |

## 7. State

- Cubit: `OnboardingCubit` — Cubit (small single-page-flow state).
- States: `OnboardingInitial` (declared, never emitted — see Known issues),
  `OnboardingInProgress(currentPage)`, `OnboardingCompleted`.
- Transitions: onPageChanged → InProgress; next() → InProgress(page+1) or finish; skip() → finish;
  finish awaits CompleteOnboardingUseCase → Completed.
- Pagination: none; `totalPages = 4`.

## 8. Dependencies

- Depends on (core): AppAnimatedEntry, AppMotion, EntryAnimationType, TapScale, AppButton,
  AppContentBox, AppSpacing/AppRadius/AppSizes, Responsive, context.colors/textStyles, t, ApiResult,
  failures, AppConstants, CacheService, RouteNames.
- Depends on (features): none. Used by (features): none.
- Used by (core): `RouteGuards` (GetOnboardingSeenUseCase), the router,
  `core/di/onboarding_module.dart`.
- DI: `core/di/onboarding_module.dart` — repo + 2 usecases (lazy singletons), cubit factory.

## 9. Localization

- Namespace: `onboarding` — skip, next, getStarted, slide1-4 headline/body, assetType group.

## 10. Business rules & edge cases

- Guard fail-open: if reading the seen flag fails, onboarding is treated as seen.
- While unseen, every route redirects to onboarding; once seen, onboarding redirects to home
  (logged in) or welcome.
- `RouteGuards` is registered after the onboarding DI module to break a documented circular
  dependency.

## 11. Tests

| Area | Test files | Covered behaviors |
|---|---|---|
| cubit | test/features/onboarding/presentation/cubits/onboarding_cubit_test.dart | page + completion transitions |
| widget | test/features/onboarding/presentation/widgets/onboarding_page_view_test.dart | pager interactions |
| usecases | test/features/onboarding/domain/usecases/get_onboarding_seen_usecase_test.dart, complete_onboarding_usecase_test.dart | flag read/write |
| repo | test/features/onboarding/data/repositories/onboarding_repository_impl_test.dart | cache read/write |

## 12. Known issues

- ANIM-2: raw AnimatedOpacity / AnimatedSwitcher and raw motion Durations in the page view; raw
  AnimatedContainer in the indicator.
- Dead state: `OnboardingInitial` is never emitted (the cubit starts at InProgress(0)).
- The Skip `AppButton` and its `TapScale` wrapper duplicate the same skip() call (harmless
  redundancy).
- TEST-8: no screen-level test covering the full four-slide flow.

## 13. Changelog

- 2026-10-26 — Initial doc created from code (doc-sync).
