# Auth

> Last verified: 2026-10-26
> Path: `lib/features/auth/`

## 1. Purpose

Welcome screen after onboarding: sign in with Google or continue as guest (Supabase anonymous
auth). Either success lands on home. Also owns `AuthUserEntity` and the auth-state stream reused by
the settings profile header.

## 2. Screens & routes

| Screen | Route (constant) | Params | Notes |
|---|---|---|---|
| `presentation/screens/welcome_screen.dart` | `RouteNames.welcome` / `RoutePaths.welcome` | none | MultiBlocProvider: WelcomeCubit + GoogleSignInCubit, both getIt factories |

## 3. File map

| Layer | Key files | Responsibility |
|---|---|---|
| presentation screens | `presentation/screens/welcome_screen.dart` | Hero + two CTAs + snackbar/listener logic |
| presentation widgets | `presentation/widgets/welcome_hero_illustration.dart` | CustomPainter trend motif with coins |
| cubits | `presentation/cubits/welcome_cubit/welcome_cubit.dart` + `presentation/cubits/welcome_cubit/welcome_state.dart` | Guest flow |
|  | `presentation/cubits/google_sign_in_cubit/google_sign_in_cubit.dart` + `presentation/cubits/google_sign_in_cubit/google_sign_in_state.dart` | Google flow |
| domain | `domain/entities/auth_user_entity.dart`, `domain/repositories/auth_repository.dart` | Entity + contract |
| usecases | `domain/usecases/continue_as_guest_usecase.dart`, `domain/usecases/google_sign_in_usecase.dart`, `domain/usecases/watch_auth_user_usecase.dart` | 3 usecases |
| data | `data/datasources/remote/auth_remote_datasource.dart`, `data/models/auth_user_model.dart`, `data/repositories/auth_repository_impl.dart` | Supabase auth; the model parses the Supabase user |

## 4. Entities & models

| Entity | Key fields | Model (data) | Notes |
|---|---|---|---|
| `AuthUserEntity` | id, email, isAnonymous, displayName?, avatarUrl? | `AuthUserModel` with `toEntity()` | Model's `fromSupabaseUser` reads Supabase userMetadata |

## 5. Use cases

| UseCase | Input | Output | Business rule (if any) |
|---|---|---|---|
| `ContinueAsGuestUseCase` | none | ApiResult(AuthUserEntity) | Supabase anonymous sign-in |
| `GoogleSignInUseCase` | none | ApiResult(AuthUserEntity) | Native idToken on mobile; OAuth on web |
| `WatchAuthUserUseCase` | none | Stream of ApiResult(AuthUserEntity?) | Emits Success(null) when signed out; consumed by settings |

## 6. API & storage

| Key (constant) | Used by | Cache policy |
|---|---|---|
| Supabase auth API (no tables) | `AuthRemoteDataSource.signInAnonymously` / `googleSignIn` / `authStateChanges` | none |
| `AppAssets.googleLogo` | Google button | — |

## 7. State

- `WelcomeCubit`: WelcomeInitial / WelcomeGuestLoading / WelcomeGuestSuccess /
  WelcomeGuestFailure(failure) — via `continueAsGuest()`.
- `GoogleSignInCubit`: GoogleSignInInitialState / GoogleSignInLoadingState /
  GoogleSignInSuccessState / GoogleSignInFailureState(failure) — via `googleSignIn()`.
- Screen listeners: Success → goNamed(home); Failure → `AppSnackBar.showError` with
  `failure.localizedMessage(context)`.
- Pagination: none.

## 8. Dependencies

- Depends on (core): AppAnimatedEntry/AppMotion/EntryAnimationType, AppButton, AppContentBox,
  AppSnackBar, AppSpacing, context extensions, failure localization, t, AppAssets,
  SupabaseClientProvider, failures + failure_mapper, ApiResult, RouteNames.
- Depends on (features): none.
- Used by (features): settings (AuthUserEntity + WatchAuthUserUseCase + ProfileHeaderMapper).
- Used by (core): the router, `core/di/auth_module.dart`, `initGoogleSignInModule` in
  injection_container.dart.
- DI: `core/di/auth_module.dart` — datasource, repo, 3 usecases, 2 cubit factories.

## 9. Localization

- Namespace: `auth` — welcome group (headline, subtext, both CTAs, guestDisclosure) and error group
  (networkError, tooManyRequests, unknownError, anonymousSignInDisabled).

## 10. Business rules & edge cases

- Guest = Supabase anonymous session; a null user from anonymous sign-in raises AuthException.
- Google: native initialize/authenticate with idToken on Android/iOS (missing idToken →
  AuthException); web uses OAuth and currently returns a placeholder user.
- Display-name fallback is the email local part; a localized generic name is deferred to the UI.

## 11. Tests

| Area | Test files | Covered behaviors |
|---|---|---|
| screen | test/features/auth/presentation/screens/welcome_screen_test.dart | render + flows |
| cubits | test/features/auth/presentation/cubits/welcome_cubit_test.dart | guest transitions |
| usecases | test/features/auth/domain/usecases/watch_auth_user_usecase_test.dart, continue_as_guest_usecase_test.dart | stream + guest |
| data | test/features/auth/data/repositories/auth_repository_impl_test.dart, test/features/auth/data/models/auth_user_model_test.dart | repo + model parsing |

## 12. Known issues

- ARCH-10: the userMetadata keys (full_name, name, avatar_url, picture) and the Google OAuth client
  IDs are literals inside `data/datasources/remote/auth_remote_datasource.dart`.
- UI-1: raw `Colors.white.withValues(...)` in `presentation/widgets/welcome_hero_illustration.dart`.
- The DI-registered GoogleSignIn singleton is bypassed (GoogleSignIn.instance called statically).
- The i18n key auth.welcome.guestDisclosure is never rendered.
- The web branch returns a dummy AuthUserModel with empty id/email.
- TEST-1: no tests for GoogleSignInUseCase, GoogleSignInCubit, or the datasource.

## 13. Changelog

- 2026-10-26 — Initial doc created from code (doc-sync).
- 2026-10-26 — Refactor (DATA-4/5): AuthUserMapper dissolved into `AuthUserModel.fromSupabaseUser`;
  its test moved to test/features/auth/data/models/auth_user_model_test.dart.
