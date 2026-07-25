# Qeema — Add Asset Screen Sub-Plan (Slice 2 of the Assets Feature)

> **Audience:** an AI coding agent implementing this from scratch, in one focused pass. **You are executing this plan as DeepSeek V4 Flash Free.** Because this model tier prioritizes speed and can take shortcuts under ambiguity, this plan is written to remove ambiguity wherever possible: exact code skeletons are given for every non-trivial piece, exact file paths are given, and explicit "do not do X" call-outs are included for every mistake class that has actually occurred earlier in this project. Follow this plan literally. Where a code skeleton is given, use it as the actual structure — do not "improve" it into something different unless it's factually wrong for this codebase (e.g. a method name doesn't match what's actually in `core/`), in which case fix it to match reality and say so, rather than silently redesigning it.
>
> **Scope — read this before writing anything:** this plan covers **only the Add Asset screen** and exactly the layers it needs. The Assets List screen (Slice 1) is already built and working — you are extending the existing `features/assets/` folder, not starting from scratch. Do not touch `assets_list_screen.dart`, `assets_bloc.dart`, or any Slice-1 file except where this plan explicitly says to extend one (§4.2). Do not build Edit Asset or Asset Detail — those are separate future slices.
>
> **Zero-error mandate:** this is the core data-entry point of the entire app — every asset a user will ever see anywhere in Qeema starts here. A bug in this screen (wrong decimal handling, a disconnected form field, a picker that doesn't actually record a selection) corrupts data for every other feature downstream. Treat every checklist item in this document as mandatory, not optional polish. If you are unsure whether something is correct, verify it explicitly (re-read the file, run the check) rather than assuming.

---

## 0. Mandatory Pre-Work — Do These Checks Before Writing Any Code

Perform each of these, in order, and report the result of each before proceeding to implementation.

### 0.1 — Verify the database via Supabase MCP Server
Use the Supabase MCP Server to run these exact checks:
1. Confirm the `assets` table exists with columns: `id, user_id, asset_type_id, amount, price_at_entry, entry_date, note, is_deleted, deleted_at, created_at, updated_at`.
2. Confirm `asset_types` has exactly these 4 rows (query `SELECT code, name, is_market_based, base_unit FROM asset_types;` and check the output matches):
   - `cash_egp` — `is_market_based = false`, `base_unit = 'EGP'`
   - `usd` — `is_market_based = true`, `base_unit = 'USD'`
   - `gold_21` — `is_market_based = true`, `base_unit = 'gram'`
   - `gold_24` — `is_market_based = true`, `base_unit = 'gram'`
3. Confirm RLS policies `insert_own_assets` and `update_own_assets` exist on `assets` (query `pg_policies` as shown in earlier setup).
4. **Run a real test INSERT via the MCP server** (using a test/dummy `user_id` if you can obtain one, or reasoning through the policy logic if you cannot authenticate as a real user from the SQL editor context) to confirm the `log_asset_changes` trigger fires correctly and writes a row into `asset_history` on insert. If you cannot fully simulate an authenticated insert from the MCP SQL context, at minimum confirm the trigger function `log_asset_changes()` and the trigger `trg_log_asset_changes` both exist and are attached to `assets` for `INSERT OR UPDATE`.
5. **`market_prices` table is currently empty** (confirmed separately, ingestion is deferred until after this demo build) — this means for `usd`/`gold_21`/`gold_24`, there is no cached price to auto-fill yet. This is expected and handled explicitly in §3.3 — do not treat this as a bug to fix in this slice.

### 0.2 — Re-read the existing Slice-1 code
Open and read, in full, before writing anything:
- `lib/features/assets/domain/entities/asset_entity.dart`
- `lib/features/assets/domain/entities/asset_type_entity.dart`
- `lib/features/assets/domain/repositories/assets_repository.dart`
- `lib/features/assets/data/repositories/assets_repository_impl.dart`
- `lib/features/assets/data/datasources/local/assets_local_datasource.dart`
- `lib/features/assets/data/datasources/remote/assets_remote_datasource.dart`
- `lib/features/assets/presentation/blocs/assets_bloc/*.dart`
- `lib/core/di/assets_module.dart`

Confirm the exact existing method signatures on `AssetsRepository` (`watchAssets()`, `getAssetTypes()`) so you extend it correctly in §4.2 rather than guessing its current shape.

### 0.3 — Confirm `core/` pieces this screen depends on
Confirm these exist and note their exact API (do not guess method names — open each file):
- `core/financial/currency_converter.dart` (`CurrencyConverter`) — not directly used for math display here, but confirm it exists since a later slice will need it; not a blocker for this slice.
- `core/animations/app_animated_entry.dart`, `entry_animation_type.dart`, `staggered_list_animator.dart`, `micro_interactions/tap_scale.dart`, `micro_interactions/success_pulse.dart`, `app_motion.dart`.
- `core/widgets/app_button.dart`, `app_text_field.dart` (confirm whether `AppTextField` supports a persistent/floating label and a leading icon parameter — this screen needs both; if either is missing, add it to the shared widget, do not build a local one-off).
- `core/helpers/validators.dart`, `core/helpers/date_formatter.dart`, `core/helpers/currency_formatter.dart`.
- `core/error/failures.dart` and `core/utils/api_result.dart` (`ApiResult`, `Success`, `ResultFailure`, `.fold()`).
- `core/local/cache/daos/market_prices_dao.dart` (`MarketPricesDao.latestForType` or equivalent — confirm the exact method name).

Report your findings for §0.1–§0.3 as a checklist before writing any implementation code.

---

## 1. What This Slice Delivers

One screen: **Add Asset**, reachable by tapping the "+" button on the Assets List screen (which currently does nothing per Slice 1's explicit scope boundary — this slice is what finally wires it up).

Flow:
1. User opens the screen and first sees an **asset type picker** — nothing else is visible yet.
2. User taps one of the type tiles (Cash EGP / USD / Gold 21k / Gold 24k, driven by the live `asset_types` table, not a hardcoded list).
3. **The form fields below the picker appear**, animated in, and **differ based on the selected type**:
   - `cash_egp` selected → only **Amount (EGP)**, **Entry Date**, **Note (optional)** are shown. No price-at-entry field at all for cash — it's meaningless (1 EGP is always worth 1 EGP in the base currency), so do not show it, do not silently default it to some value behind the scenes either — the repository/usecase layer handles this (§4.1) so the UI simply never asks for it.
   - `usd` / `gold_21` / `gold_24` selected → **Amount (in the correct unit — USD or grams)**, **Price at Entry (per unit, in EGP)**, **Entry Date**, **Note (optional)** are shown.
4. User fills the visible fields, submit button enables once everything visible and required is valid.
5. On submit: asset is saved (offline-first, per §4.4), a success animation plays, user is taken back to the Assets List, where the new asset appears automatically (because Slice 1's `AssetsBloc` is already subscribed to a live stream — no manual cross-Bloc signaling needed, see §4.5).

---

## 2. Folder Structure — Files to Create in This Slice

```
lib/features/assets/
├── presentation/
│   ├── screens/
│   │   └── add_asset_screen.dart                 [NEW]
│   ├── widgets/
│   │   ├── asset_type_picker.dart                 [NEW]
│   │   ├── asset_type_tile.dart                    [NEW]
│   │   └── dynamic_asset_fields.dart               [NEW]
│   └── cubits/
│       └── add_asset_cubit/
│           ├── add_asset_cubit.dart                [NEW]
│           └── add_asset_state.dart                [NEW]
├── domain/
│   ├── params/
│   │   └── add_asset_params.dart                   [NEW]
│   └── usecases/
│       └── add_asset_usecase.dart                  [NEW]
└── data/
    └── (extend existing files, see §4.2 — no new files here)
```

**Do not create** `edit_asset_screen.dart`, `asset_detail_screen.dart`, or anything history/chart-related — out of scope for this slice.

---

## 3. UI/UX Specification — Be Precise, This Screen Sets the Tone for the Whole App

### 3.1 Overall layout
- `Scaffold` with an `AppBar` (title: "Add Asset" via slang, back button to Assets List).
- Body: `SingleChildScrollView` (forms must never overflow on small devices) containing, top to bottom:
  1. `AssetTypePicker`
  2. `DynamicAssetFields` (conditionally rendered based on selection — empty/absent until a type is chosen)
  3. Submit button (`AppButton`, fixed weight/position — can either be pinned at the screen bottom via a `bottomNavigationBar`-style fixed slot, or simply the last item in the scrollable column; pick the fixed-bottom pattern if `AppButton`/other forms in this app already establish that convention, check Slice 1 or Auth screens for precedent first).

### 3.2 `AssetTypePicker` / `AssetTypeTile`
- A `GridView`/`Wrap` of tiles, one per row returned from `GetAssetTypesUseCase` (reuse the existing usecase from Slice 1 if it's already registered — check §0.2 — otherwise it needs to exist per Slice 1's scope; if missing, that's a Slice-1 gap to flag, not something to silently rebuild differently here).
- Each tile: icon + label, exactly per the earlier Add Asset audit's fix requirements (do not regress these, even though this is a rebuild):
  - `cash_egp` → a cash/banknote icon (e.g. `Icons.payments_outlined`)
  - `usd` → a dollar icon (e.g. `Icons.attach_money`)
  - `gold_21` → a coin/gold icon with a small "21K" text badge on the tile
  - `gold_24` → the same gold icon with a "24K" badge — the two gold tiles must be visually distinguishable from each other, not identical apart from label text.
- **Selected state must be visually unmistakable:** filled background using `context.colors.primary` (or a tinted variant), a visible border, icon/text color inverted for contrast. An unselected tile uses `context.colors.surfaceAlt` with a subtle border.
- Each tile wrapped in `TapScale`. The whole picker's tiles animate in via `StaggeredListAnimator` (or `AppAnimatedEntry` per-tile with incremental delay, whichever `core/animations/` actually exposes for a grid/row of items — check `staggered_list_animator.dart`'s actual API, it may be list-oriented; if it doesn't cleanly support a 2x2 grid, use individual `AppAnimatedEntry` widgets with `delay: AppMotion.staggerStep * index` instead, and note that you made this call).

**Critical — the exact bug class already found and fixed once in this project must not recur:**
```dart
// WRONG — do not do this. A local variable disconnected from the Cubit
// means the tile visually "selects" but the form never actually knows.
class _AssetTypePickerState extends State<AssetTypePicker> {
  String? _selectedTypeId; // ❌ disconnected local state
  ...
}
```
```dart
// CORRECT — the picker reads its selected value FROM the Cubit's state,
// and tapping a tile calls a Cubit method. There is exactly one source of
// truth for "which type is selected": AddAssetCubit's state.
class AssetTypePicker extends StatelessWidget {
  const AssetTypePicker({super.key, required this.assetTypes});
  final List<AssetTypeEntity> assetTypes;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddAssetCubit, AddAssetState>(
      buildWhen: (previous, current) => previous.selectedType != current.selectedType,
      builder: (context, state) {
        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: assetTypes.map((type) {
            final isSelected = state.selectedType?.id == type.id;
            return AssetTypeTile(
              type: type,
              isSelected: isSelected,
              onTap: () => context.read<AddAssetCubit>().selectAssetType(type),
            );
          }).toList(),
        );
      },
    );
  }
}
```
This exact pattern — read from Cubit state, write via a Cubit method, nothing else holds a competing copy of "what's selected" — is mandatory. Verify this explicitly before moving on: search your own implementation for any `StatefulWidget`/local `setState` holding the selected type, and remove it if found.

### 3.3 `DynamicAssetFields`
- Rendered only when `state.selectedType != null` — animate its appearance in as a whole block via `AppAnimatedEntry(type: EntryAnimationType.fadeSlideUp)` when it first appears (i.e. the moment a type is picked), not on every rebuild.
- **Field set depends on `state.selectedType!.isMarketBased`:**
  ```dart
  if (state.selectedType!.isMarketBased) ...[
    _buildAmountField(context, unit: state.selectedType!.baseUnit),
    _buildPriceAtEntryField(context, unit: 'EGP'),
  ] else ...[
    _buildAmountField(context, unit: state.selectedType!.baseUnit), // EGP for cash
  ],
  _buildEntryDateField(context),
  _buildNoteField(context),
  ```
- **Amount field:** label must include the unit explicitly and dynamically — e.g. `"Amount (${unit})"` where `unit` is `'EGP'`/`'USD'`/`'gram'` from `AssetTypeEntity.baseUnit`, not a hardcoded string per type. Leading icon: a numeric/amount-style icon. Persistent label (not just a hint that vanishes on typing — re-confirm `AppTextField` supports this per §0.3).
- **Price at entry field (market-based types only):**
  - Label: `"Price at Entry (EGP per ${unit})"`.
  - **Auto-fill attempt:** call the price-lookup (via `MarketPricesDao`/whatever the confirmed method is from §0.3) for the selected type's latest cached price. **Given `market_prices` is currently empty (§0.1.5), this will return nothing for every type right now** — handle this gracefully: the field starts empty (not stuck loading, not showing an error), with a placeholder/hint like "Enter the price at the time you acquired this" so the user isn't confused by an unfilled field. If a price *is* found (e.g. after ingestion is built later), pre-fill it and let the user edit it — same behavior as previously specced, just correctly handling the "no data yet" case explicitly rather than assuming data will always be there.
  - Leading icon: a price/currency-tag icon.
  - Field is enabled and editable at all times once a market-based type is selected (never `readOnly`/disabled — this exact bug was found and fixed once already in this project's history; do not reintroduce it).
- **Entry date field:** calendar icon, tapping opens a native date picker, displayed value formatted via `core/helpers/date_formatter.dart`, defaults to today.
- **Note field:** clearly labeled "Note (optional)", pencil/note icon, no validation required.
- **Validation, inline per field, live after first touch:** amount > 0 (required, always), price-at-entry > 0 (required only when visible, i.e. only for market-based types — do not validate a field the user never sees), entry date not in the future (reasonable sanity check — decide and note if you add this beyond what was explicitly specified, since it's a small, justified addition per §6).

### 3.4 Submit button & success feedback
- `AppButton`, disabled until the currently-visible required fields are all valid — recompute this from `AddAssetState`, not a separate local validity flag.
- Loading state during submission (`AppButton`'s existing loading pattern).
- On success: play the `success_pulse` micro-interaction (`core/animations/micro_interactions/success_pulse.dart`) briefly, then navigate back (`context.pop()`/`context.go()` back to Assets List, per whatever navigation pattern Slice 1 established for returning from a pushed route).
- On failure: show the mapped, localized error message (via a themed `SnackBar` or an inline banner — check whether Assets List/Auth already established a pattern for this and reuse it, don't invent a third error-display convention).

---

## 4. Domain & Data Layer

### 4.1 `AddAssetParams`
```dart
class AddAssetParams {
  final String assetTypeId;
  final Decimal amount;
  final Decimal? priceAtEntry; // null for cash_egp — see below
  final DateTime entryDate;
  final String? note;
  const AddAssetParams({
    required this.assetTypeId,
    required this.amount,
    this.priceAtEntry,
    required this.entryDate,
    this.note,
  });
}
```
**Handling `priceAtEntry` for `cash_egp`:** the UI never asks for it (§3.3), but the database column `price_at_entry` is `NOT NULL`. The repository/usecase layer must supply `Decimal.one` (1 EGP = 1 EGP, the base currency's price is always 1 relative to itself) when `priceAtEntry` is `null` and the asset type is `cash_egp` — implement this substitution in `AssetsRepositoryImpl.addAsset()` (§4.2), not in the UI, and not by silently defaulting for *any* null price (only specifically for the non-market-based case — if `priceAtEntry` is somehow null for a market-based type, that's a real validation failure, not a case to default away; the UI's own validation in §3.3 should already prevent this, but the repository should not trust the UI blindly — add a defensive check).

### 4.2 Extend the existing `AssetsRepository`
Per Slice 1's explicit note that write methods would be added "in the slice that needs them" — add exactly this one method now:
```dart
abstract class AssetsRepository {
  Stream<ApiResult<List<AssetEntity>>> watchAssets(); // existing, unchanged
  Future<ApiResult<List<AssetTypeEntity>>> getAssetTypes(); // existing, unchanged
  Future<ApiResult<AssetEntity>> addAsset(AddAssetParams params); // NEW
}
```
Implement in the existing `AssetsRepositoryImpl` — do not create a second repository or a parallel implementation. Follow the exact offline-first pattern already established in `core/`'s design (and already used for reads in Slice 1): write optimistically to Drift first (`pendingSync: true`), then attempt the Supabase insert in the background via the existing `SyncService`/datasource pattern (check exactly how Slice 1's read-side sync is wired and mirror it for this write, don't invent a different mechanism).

Add the corresponding method to `AssetsRemoteDataSource` (a real Supabase `insert` call) and `AssetsLocalDataSource` (a Drift insert via `AssetsDao`, using whatever insert method it already exposes — check its actual method name, don't assume `insertOrUpdate` is correct without verifying).

### 4.3 `AddAssetUseCase`
```dart
class AddAssetUseCase implements UseCase<AssetEntity, AddAssetParams> {
  final AssetsRepository _repository;
  const AddAssetUseCase(this._repository);

  @override
  Future<ApiResult<AssetEntity>> call(AddAssetParams params) => _repository.addAsset(params);
}
```

### 4.4 Offline-first — re-confirm before implementing
Re-read `core/` Sub-Plan §8's cache-first/optimistic-write description before implementing `addAsset()` — the exact pattern (write to Drift immediately with `pendingSync: true`, background push, retry on reconnect via the existing `SyncService`) must be followed precisely, not approximated. If any part of this mechanism doesn't actually exist yet in `core/` (only reads were exercised in Slice 1), you may need to add the write-side counterpart to `SyncService`/the local datasource — check first, and if it's missing, build the minimal necessary piece rather than skipping offline-support for writes and doing a network-only insert (which would violate the app's core offline-first design).

### 4.5 Why the Assets List updates automatically — do not build manual refresh logic
Once `addAsset()` successfully writes to the local Drift table, Slice 1's `AssetsBloc` — which is already subscribed to `AssetsDao.watchActiveAssets()` via `GetAssetsUseCase`'s stream — will **automatically** receive the new row and update its state. **Do not** add any code in `AddAssetCubit` or `AddAssetScreen` that reaches into `AssetsBloc` to manually trigger a refresh, call an event on it, or otherwise couple these two Blocs/Cubits together. This is a direct, concrete application of the rule already established in this project (Assets Sub-Plan §0.2.2): one feature's Cubit does not manually reach into another feature's state — they communicate only through the shared data layer (the Drift table both are watching), never directly.

---

## 5. Presentation — `AddAssetCubit`

Cubit, not Bloc — a straightforward "user picks a type, fills fields, taps submit → call a usecase → emit a state" flow with no independent concurrent event stream (this screen has no live external data source feeding it, unlike Assets List's Bloc) — consistent with this project's established Bloc-vs-Cubit rule.

```dart
class AddAssetState {
  final AssetTypeEntity? selectedType;
  final List<AssetTypeEntity> availableTypes;
  final bool isSubmitting;
  final Failure? submitFailure;
  final bool submitSucceeded;
  const AddAssetState({
    this.selectedType,
    this.availableTypes = const [],
    this.isSubmitting = false,
    this.submitFailure,
    this.submitSucceeded = false,
  });

  AddAssetState copyWith({...}) { ... }
}
```

```dart
class AddAssetCubit extends Cubit<AddAssetState> {
  final GetAssetTypesUseCase _getAssetTypes;
  final AddAssetUseCase _addAsset;

  AddAssetCubit(this._getAssetTypes, this._addAsset) : super(const AddAssetState());

  Future<void> loadAssetTypes() async {
    final result = await _getAssetTypes();
    result.fold(
      onSuccess: (types) => emit(state.copyWith(availableTypes: types)),
      onFailure: (failure) => emit(state.copyWith(submitFailure: failure)),
    );
  }

  void selectAssetType(AssetTypeEntity type) {
    emit(state.copyWith(selectedType: type));
  }

  Future<void> submit(AddAssetParams params) async {
    emit(state.copyWith(isSubmitting: true, submitFailure: null));
    final result = await _addAsset(params);
    result.fold(
      onSuccess: (_) => emit(state.copyWith(isSubmitting: false, submitSucceeded: true)),
      onFailure: (failure) => emit(state.copyWith(isSubmitting: false, submitFailure: failure)),
    );
  }
}
```
**Confirm every `.fold()` call above has its result actually used (assigned via `emit(...)` inside each branch) — this exact class of bug (a `.fold()` called with both branches doing nothing, its result discarded) broke routing once already in this project. Do not let it happen here.**

`AddAssetScreen` dispatches `loadAssetTypes()` once on entry (e.g. via `BlocProvider`'s `create` callback calling it immediately, or a single call in the screen's `initState`-equivalent — not re-called on every rebuild).

---

## 6. Additional Instructions Beyond What Was Explicitly Requested (Justify Each)

These are added because they materially reduce the risk of a real bug in this specific screen, given its "zero errors, this is the foundation" requirement:

1. **Defensive re-validation in the repository, not just the UI** (§4.1) — a UI validation bug should not be able to write bad data to the database; the repository layer re-checks amount > 0 before writing, returning a `Failure` rather than trusting the UI blindly.
2. **Entry date sanity check** (§3.3) — prevent a date far in the future from being entered by mistake (e.g. a date-picker misconfiguration or a typo), since a future-dated asset would produce nonsensical inflation/valuation calculations in later slices.
3. **Explicit handling of the empty `market_prices` table** (§3.3) — rather than letting the price-lookup silently fail or hang, this plan requires it to degrade gracefully to an empty, clearly-labeled field, since this is the actual current state of the database and must work correctly today, not just after ingestion exists.
4. **No manual cross-Bloc coupling** (§4.5) — explicitly forbidding a plausible-seeming shortcut (having `AddAssetCubit` poke `AssetsBloc` directly) that would work but violate the project's established architecture and create a maintenance hazard.

---

## 7. Testing Requirements (unit, Cubit, widget — no integration tests)

- **Unit — `AssetsRepositoryImpl.addAsset()`:** cash_egp submission correctly substitutes `Decimal.one` for price-at-entry; market-based submission with a null price-at-entry (simulating a UI bug) is rejected with a `Failure`, not silently written; successful write is optimistic (Drift write succeeds even if the mocked remote push fails, and `pendingSync` remains `true` in that case).
- **Unit — `AddAssetUseCase`:** delegates correctly to the repository, both success and failure paths.
- **Cubit — `AddAssetCubit`:** `selectAssetType` updates `selectedType` correctly; `submit` emits `isSubmitting: true` then the correct terminal state for both success and failure; **explicitly test that calling `submit` twice rapidly (double-tap) doesn't cause two concurrent submissions** — decide and implement a guard (e.g. ignore `submit` calls while `isSubmitting` is already `true`) if one isn't naturally already present, and test it.
- **Widget — `AssetTypePicker`:** tapping a tile updates both the visual selected state and `AddAssetCubit`'s actual `selectedType` — assert both together (the exact disconnection-bug regression test, per §3.2's explicit requirement).
- **Widget — `DynamicAssetFields`:** selecting `cash_egp` renders exactly Amount/Date/Note (no price field); selecting `usd` renders Amount/Price/Date/Note; field labels show the correct unit string per type.
- **Widget — price-at-entry field is genuinely editable:** simulate typing into it after auto-fill (or after it renders empty, per the current no-data state) and confirm the typed value persists and isn't overwritten on an unrelated rebuild (the exact "field not accessible" bug class found and fixed once already).
- **Widget — submit button disabled/enabled states** match validity correctly for both cash and market-based type flows.
- **Widget — Reduced motion & theme smoke tests**, consistent with every other screen in this app.

---

## 8. Dependency Injection

Extend `core/di/assets_module.dart`: register `AddAssetUseCase` (lazy singleton) and `AddAssetCubit` (factory). Do not create a second DI module file for this — it's the same feature, same module.

---

## 9. Router Integration

Wire the Assets List's "+" button (currently inert per Slice 1) to push the Add Asset route. Use `AppPageTransitions.slideUpPage` (per the original animation design intent for a modal-style add flow) if it exists in `core/animations/app_page_transitions.dart` — confirm its exact name before using it.

---

## 10. Definition of Done

- [ ] Phase 0 checks (§0.1–§0.3) completed and reported, including the actual database verification results via Supabase MCP Server.
- [ ] Asset type picker is fully data-driven, selected state has a single source of truth (`AddAssetCubit`), verified explicitly — no disconnected local state anywhere.
- [ ] Fields shown genuinely differ by selected type; price-at-entry is never shown for `cash_egp`.
- [ ] Price-at-entry field is always editable when visible, never accidentally read-only or overwritten by a rebuild.
- [ ] `cash_egp` submissions correctly get `Decimal.one` as price-at-entry at the repository layer, not the UI layer.
- [ ] Offline-first write pattern correctly implemented (optimistic Drift write, background Supabase push via existing `SyncService` pattern).
- [ ] No manual coupling between `AddAssetCubit` and `AssetsBloc` — the list updates purely through the shared Drift stream.
- [ ] Every `.fold()` call site has its result actually used.
- [ ] Zero hardcoded text/colors/spacing; one class/widget per file.
- [ ] Double-submit is guarded against.
- [ ] All tests in §7 pass; `flutter analyze` and `dart format` pass clean.
- [ ] Report back: Phase 0 findings in full (including the exact MCP verification results), confirmation of every checklist item above, and any place where this plan's assumptions about existing Slice-1 code turned out to be wrong (e.g. a method name that didn't match) and how you resolved it — don't paste full file contents already visible in the diff.
