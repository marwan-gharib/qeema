# App Lock

> Last verified: 2026-10-26
> Path: `lib/features/app_lock/`

## 1. Purpose

Optional device-credential lock (biometric/PIN via local_auth) that shields the whole app on cold
start and after backgrounding, and hides app content in the Android recents preview. Enabled from
Settings; enforcement is global through an overlay, not per route.

## 2. Screens & routes

| Screen | Route (constant) | Params | Notes |
|---|---|---|---|
| `presentation/screens/lock_screen.dart` | `RouteNames.lock` / `RoutePaths.lock` | none | Registered but unreachable by navigation: guards redirect /lock to home; the visible lock UI is `AppLockOverlay` hosting this screen |

Non-route pieces: `presentation/widgets/app_lock_overlay.dart` (wraps the router child in
lib/app_root.dart) and `presentation/widgets/app_lock_lifecycle_observer.dart` (wraps the app root
in main.dart).

## 3. File map

| Layer | Key files | Responsibility |
|---|---|---|
| presentation screens | `presentation/screens/lock_screen.dart` | PopScope canPop:false; logo, title, reason message, loader/unlock button |
| presentation widgets | `presentation/widgets/app_lock_overlay.dart` | Cold-start gate + overlay (TickerMode/ExcludeSemantics/AbsorbPointer over a permanently mounted child) |
|  | `presentation/widgets/app_lock_lifecycle_observer.dart` | Lifecycle mapping + back consumption while locked |
| cubits | `presentation/cubits/app_lock_cubit/app_lock_cubit.dart` + `presentation/cubits/app_lock_cubit/app_lock_state.dart` | The gate state owner; implements core `AppLockGate` |
| domain | `domain/entities/app_lock_status.dart`, `domain/repositories/app_lock_repository.dart` | Status enum + contract |
| usecases | `domain/usecases/` — get_app_lock_enabled, set_app_lock_enabled, check_device_lock_available, authenticate_device, set_recents_preview_hidden | 5 usecases |
| data | `data/datasources/local/app_lock_local_datasource.dart`, `data/repositories/app_lock_repository_impl.dart` | Cache-backed flag + service calls |

## 4. Entities & models

| Entity | Key fields | Model (data) | Notes |
|---|---|---|---|
| `AppLockStatus` (enum) | notRequired, authenticated, failed, lockedOut | none | Cancelled/lockedOut arrive as Success results, not failures |

## 5. Use cases

| UseCase | Input | Output | Business rule (if any) |
|---|---|---|---|
| `GetAppLockEnabledUseCase` | none | ApiResult(bool) | Missing key defaults to true (fail-closed) |
| `SetAppLockEnabledUseCase` | bool | ApiResult(void) | Consumed by settings, not by this Cubit |
| `CheckDeviceLockAvailableUseCase` | none | ApiResult(bool) | local_auth device support |
| `AuthenticateDeviceUseCase` | reason string | ApiResult(AppLockStatus) | reason = t.app_lock.promptReason |
| `SetRecentsPreviewHiddenUseCase` | bool | ApiResult(void) | Best-effort; failures swallowed |

## 6. API & storage

| Key (constant) | Used by | Cache policy |
|---|---|---|
| `AppConstants.appLockEnabledKey` | `AppLockLocalDataSource.isEnabled` / `setEnabled` via `CacheService` | SharedPreferences; missing key → enabled |
| `WindowSecurityService.channelName` + `setRecentsPreviewHiddenMethod` | recents-preview platform call | MissingPlugin/PlatformException → UnknownFailure, never blocking |
| `DeviceAuthService` (core) | authenticate via local_auth, biometricOnly false | — |

## 7. State

- Cubit: `AppLockCubit` — lazy singleton provided at app root (main.dart); implements `AppLockGate`.
- States: AppLockInitial, AppLockChecking, AppLockLocked (reason: prompt / cancelled / lockedOut),
  AppLockUnlocked, AppLockDisabled, AppLockError(failure).
- Transitions: onAppResumed/unlock → Checking → Disabled, Unlocked, Locked(prompt) → auth result →
  Unlocked / Locked(cancelled) / Locked(lockedOut) / Error; onAppPaused → Locked(prompt) only when
  unlocked + required; refresh() re-evaluates without prompting; duringAuthentication brackets
  foreign OS prompts (used by settings).
- The gate is closed for every state except Unlocked/Disabled. Pagination: none.

## 8. Dependencies

- Depends on (core): LocalAuth* failures + CacheFailure + UnknownFailure, api_result extensions,
  context extensions, t, Responsive, AppSpacing, AppAssets.qeemaLogo, AppButton / AppContentBox /
  AppLoader, CacheService, DeviceAuthService, WindowSecurityService, ApiResult, AppLockGate.
- Depends on (features): none.
- Used by (features): settings (4 usecases, AppLockCubit, AppLockStatus; the settings
  `AppLockSettingsCubit` is registered by this feature's DI module).
- Used by (app): main.dart (cubit + lifecycle observer), lib/app_root.dart (overlay), the router.
- DI: `core/di/app_lock_module.dart`.

## 9. Localization

- Namespace: `app_lock` — promptReason, disableReason, title, hint, unlockButton,
  lockedOutMessage, unavailableMessage, errorMessage, cancelledMessage, noCredentialsMessage, and
  the settings* keys consumed by the settings feature.

## 10. Business rules & edge cases

- Enabled defaults to true when the key is missing (fail-closed).
- Device lock unavailable → gate opens with requiresLock false; the toggle hides in settings.
- Cancelled and lockedOut are Success results carrying `AppLockStatus`; only unexpected errors emit
  AppLockError.
- Only LocalAuthNoCredentialsFailure / LocalAuthUnavailableFailure open the gate; everything else
  fails closed.
- Cold start defers mounting the router child once; afterwards locking uses the overlay so the
  widget tree stays mounted (screen preservation).
- Resume re-evaluates only after a real background pause (prevents prompt pause/resume loops);
  inactive never re-locks.
- Back is consumed while locked (didPopRoute in both the observer and the overlay, plus PopScope).
- Recents-preview sync fires only when requiresLock changes.

## 11. Tests

| Area | Test files | Covered behaviors |
|---|---|---|
| cubits | test/features/app_lock/presentation/cubits/app_lock_cubit_test.dart, app_lock_settings_cubit_test.dart | gate + settings toggling |
| screen/widget | test/features/app_lock/presentation/screens/lock_screen_test.dart, presentation/widgets/app_lock_lifecycle_observer_test.dart | lock UI + lifecycle |
| usecases | test/features/app_lock/domain/usecases/app_lock_usecases_test.dart | the 5 usecases |
| repo | test/features/app_lock/data/repositories/app_lock_repository_impl_test.dart | datasource + cache |
| flows | test/features/app_lock/app_lock_flow_test.dart, app_lock_screen_preservation_test.dart | end-to-end lock flow |

## 12. Known issues

- FILE-1: several test files are over the 300-line limit (the cubit test is 518 lines, the
  screen-preservation test 620).
- `AppLockSettingsCubit` (a settings cubit) is registered in `core/di/app_lock_module.dart` and its
  test lives under test/features/app_lock/ — feature/DI boundary blur.
- The /lock route is dead as a navigation target (guards bounce it to home) yet still registered
  and imported.
- Back consumption (didPopRoute) is duplicated in the overlay and the lifecycle observer.

## 13. Changelog

- 2026-10-26 — Initial doc created from code (doc-sync).
