# Splash

> Last verified: 2026-10-26
> Path: `lib/features/splash/`

## 1. Purpose

Animated brand intro on cold start (the initial route): 3D logo flip, energy ring, pulse glow and a
breathing background, then auto-navigation to onboarding. Skips straight to navigation when the OS
reduced-motion setting is on.

## 2. Screens & routes

| Screen | Route (constant) | Params | Notes |
|---|---|---|---|
| `presentation/screens/splash_screen.dart` | `RouteNames.splash` / `RoutePaths.splash` | none | Registered in `AppRouterRoutes.buildRoutes` as a plain const builder — no BlocProvider |

## 3. File map

| Layer | Key files | Responsibility |
|---|---|---|
| presentation screens | `presentation/screens/splash_screen.dart` | Stateful host: sequence controllers, timed navigation, reduced-motion branch |
| presentation widgets | `presentation/widgets/splash_background.dart` | Breathing radial gradient with parallax driven by the logo rotation |
|  | `presentation/widgets/logo_3d_flip.dart` | Perspective Y-rotation + scale/opacity/shadow over `AppAssets.qeemaLogo` |
|  | `presentation/widgets/logo_energy_ring.dart` | Rotating sweep-gradient ring |
|  | `presentation/widgets/logo_pulse_glow.dart` | Pulsing halo |
|  | `presentation/widgets/splash_brand_text.dart` | App name + tagline animations |

## 4. Entities & models

none

## 5. Use cases

none

## 6. API & storage

none — only the `AppAssets.qeemaLogo` image asset.

## 7. State

- No Cubit: internal `SplashScreenState` with four AnimationControllers and a `_hasNavigated` guard.
- Transition: the sequence completes → `context.goNamed(RouteNames.onboarding)` (exactly once).

## 8. Dependencies

- Depends on (core): AppMotion, AppSpacing, AppColorsExtension (context.colors), AppAssets,
  RouteNames, t (slang), Responsive.
- Depends on (features): none. Used by (features): none — only the router.
- DI: none (the screen is const).

## 9. Localization

- Namespace: the shared `app` namespace only — `context.t.app.name`, `context.t.app.tagline`.

## 10. Business rules & edge cases

- Navigation fires exactly once (`_hasNavigated`).
- `MediaQuery.disableAnimations` short-circuits straight to navigation.
- `RouteGuards.redirectUnauthenticated` always lets splash through.

## 11. Tests

| Area | Test files | Covered behaviors |
|---|---|---|
| none | — | No tests exist yet (see Known issues) |

## 12. Known issues

- FILE-1: `presentation/screens/splash_screen.dart` is over the 300-line limit — split the
  sequence by concern.
- ANIM-2/ANIM-3: four raw AnimationControllers with manual reduced-motion handling instead of core
  facade pieces.
- RESP-2: the 200.0 hero container size bypasses `Responsive`/tokens.
- UI-1: raw `Colors.black.withValues(...)` in `presentation/widgets/logo_3d_flip.dart`.
- Bug: the ring widget always receives `isReducedMotion: false`, so the energy ring never disables
  under reduced motion.
- TEST-1: no widget tests.

## 13. Changelog

- 2026-10-26 — Initial doc created from code (doc-sync).
