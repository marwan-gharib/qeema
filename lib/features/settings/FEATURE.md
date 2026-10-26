# Settings

> Last verified: 2026-10-26
> Path: `lib/features/settings/`

## 1. Purpose

Fourth tab: account header (photo/name/email or guest badge), app-lock toggle, language and theme
pickers, app version + data-methodology note, and the destructive actions — Log Out and Delete
Account (Danger Zone with a typed-DELETE confirmation). Guest logout is explained as a permanent
account deletion.

## 2. Screens & routes

| Screen | Route (constant) | Params | Notes |
|---|---|---|---|
| `presentation/screens/settings_screen.dart` | `RouteNames.settings` / `RoutePaths.settings` | none | Shell branch 3; MultiBlocProvider with DeleteAccountCubit, LogoutCubit, ProfileHeaderCubit, AppLockSettingsCubit |

## 3. File map

| Layer | Key files | Responsibility |
|---|---|---|
| screens | `presentation/screens/settings_screen.dart` | Sections (Security / Preferences / About / Danger Zone); wires ThemeCubit + LocaleCubit + the app version |
| widgets | `presentation/widgets/profile_header_card.dart`, `presentation/widgets/profile_header_avatar.dart` | Display-only account header (shimmer, guest badge, initials fallback) |
|  | `presentation/widgets/settings_tile.dart`, `presentation/widgets/settings_section_header.dart` | Reusable row + section label |
|  | `presentation/widgets/theme_selector_sheet.dart`, `presentation/widgets/language_selector_sheet.dart`, `presentation/widgets/selector_option_row.dart` | Preference bottom sheets + shared option row |
|  | `presentation/widgets/logout_dialog.dart`, `presentation/widgets/delete_account_dialog.dart` | Destructive-action dialogs (guest copy; typed DELETE phrase) |
| mappers | `presentation/mappers/profile_header_mapper.dart`, `presentation/mappers/app_lock_prompt_mapper.dart` | AuthUserEntity → header data; AppLockStatus → prompt outcome |
| cubits | `presentation/cubits/` — profile_header_cubit, logout_cubit, delete_account_cubit, app_lock_settings_cubit (cubit + state each) | 4 cubits |
| domain | `domain/repositories/account_repository.dart`, `domain/usecases/logout_usecase.dart`, `domain/usecases/delete_account_usecase.dart` | Contract + 2 usecases (no entities — the display model lives in the profile header state) |
| data | `data/datasources/remote/account_remote_datasource.dart`, `data/repositories/account_repository_impl.dart` | Supabase auth + edge function + local wipe |

## 4. Entities & models

| Entity | Key fields | Model (data) | Notes |
|---|---|---|---|
| `ProfileHeaderData` | kind (ProfileHeaderKind: user/guest), displayName?, email?, avatarUrl? | none | Hand-written == / hashCode; built from the auth feature's `AuthUserEntity` |

## 5. Use cases

| UseCase | Input | Output | Business rule (if any) |
|---|---|---|---|
| `LogoutUseCase` | none | ApiResult(void) | Anonymous → server-side delete first, then sign-out + local wipe; failure aborts all three |
| `DeleteAccountUseCase` | none | ApiResult(void) | Sends userConfirmed: true (Danger Zone path) so the server accepts deleting a permanent account |

## 6. API & storage

| Key (constant) | Used by | Cache policy |
|---|---|---|
| Supabase edge function delete-account | `AccountRemoteDataSource.deleteAccount` | Always HTTP 200; success:false + partial:true → AccountDeletionPartialException (⚠ the name is currently a private literal, ARCH-10) |
| Supabase auth signOut (local scope) + GoogleSignIn signOut/disconnect | `AccountRepositoryImpl` | Sign-out is always local scope — a deleted user breaks global sign-out |
| `AppDatabase.clearAll()`, `SecureStorageService.deleteAll()`, `CacheService.clear()` | `AccountRepositoryImpl._clearLocalData` | Ends by re-marking `AppConstants.onboardingCompletedKey` = true |

## 7. State

- `ProfileHeaderCubit`: Loading / SignedOut / Loaded(headerData). Subscribes to
  `WatchAuthUserUseCase` in the constructor (cancelled in close()); a failed stream read never
  blanks on-screen data.
- `LogoutCubit`: Initial / Loading / Success / Failure(failure); also exposes the current
  account-anonymity check so the UI can pick the guest dialog (see Known issues).
- `DeleteAccountCubit`: Initial / Deleting / Success / Failure(failure).
- `AppLockSettingsCubit`: Loading / Loaded(isEnabled, deviceLockAvailable, isBusy) / Failure.
  Toggling off requires OS auth inside the lock gate's duringAuthentication window; failed
  persistence reverts the switch; emits are dropped after the route is torn down.
- Pagination: none.

## 8. Dependencies

- Depends on (core): AppButton, AppSnackBar, AppTextField, AppSurfaceCard, AppContentBox,
  AppAnimatedEntry/EntryAnimationType/AppMotion/TapScale/ShimmerBox, ThemeCubit + LocaleCubit
  (core/cubits), theme tokens, Responsive, context extensions, failure localization,
  api_result extensions, AppDatabase + CacheService + SecureStorageService, SupabaseClientProvider,
  AppConstants, failure_mapper + exceptions, ApiResult, Logger, RoutePaths.
- Depends on (features): auth (AuthUserEntity + WatchAuthUserUseCase); app_lock (4 usecases,
  AppLockCubit, AppLockStatus).
- Used by (features): none. DI: `core/di/settings_module.dart`; note `AppLockSettingsCubit` is
  registered by `core/di/app_lock_module.dart` (boundary blur, see Known issues).

## 9. Localization

- Namespace: `settings` — title, profile group, section headers, language/theme keys, appVersion,
  dataMethodology (+Note), deleteAccount group, logout group (including the guest dialog copy).
  The App Lock tile strings come from the separate `app_lock` namespace.

## 10. Business rules & edge cases

- Anonymous logout permanently deletes the guest account server-side; if deletion fails, neither
  sign-out nor the local wipe happens (prevents an orphaned account).
- userConfirmed is NOT set on the logout path, so the server refuses to delete a permanent account
  even if the client misclassifies it.
- Danger-Zone delete requires typing `AppConstants.deleteAccountConfirmationPhrase` (DELETE).
- Partial-deletion contract: data deleted but the auth user retained → a distinct failure and user
  message.
- Sign-out errors never block local cleanup; the local wipe always re-marks onboarding complete.
- An unavailable device-lock sensor can never count as consent for the toggle (prompt mapper).

## 11. Tests

| Area | Test files | Covered behaviors |
|---|---|---|
| repo | test/features/settings/data/repositories/account_repository_impl_test.dart | delete/logout/local wipe |
| usecase | test/features/settings/domain/usecases/delete_account_usecase_test.dart | pass-through |
| cubits | test/features/settings/presentation/cubits/profile_header_cubit_test.dart, delete_account_cubit_test.dart | transitions |
| mappers | test/features/settings/presentation/mappers/profile_header_mapper_test.dart, app_lock_prompt_mapper_test.dart | mapping rules |
| screen/widgets | test/features/settings/presentation/screens/settings_screen_test.dart, presentation/widgets/ (profile_header_card, delete_account_dialog, selector_sheets tests) | UI wiring |

## 12. Known issues

- ARCH-10: the delete-account edge-function name is a private string literal instead of a core
  constants entry.
- `AppLockSettingsCubit` depends directly on the concrete `AppLockCubit` (state owner) rather than
  a usecase — deliberate but notable layering exception; STATE-2: `LogoutCubit` calls
  `AccountRepository` directly.
- ANIM-2: raw showModalBottomSheet and showDialog in the sheets and dialogs (no core
  AppBottomSheet/AppDialog exists yet — core gap).
- FILE-1: `presentation/screens/settings_screen.dart` (378 lines) and its test file are over the
  limit.
- TEST-1: no dedicated `LogoutCubit` test; `AppLockSettingsCubit`'s test lives under the app_lock
  test folder.

## 13. Changelog

- 2026-10-26 — Initial doc created from code (doc-sync).
