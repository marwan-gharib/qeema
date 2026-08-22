# Prompt: Full App-Wide Theming Audit & Fix (Plan First, Then Implement)

You are performing a complete audit of theming across the entire app — specifically targeting light-theme color inconsistencies, text/icon colors that are invisible or low-contrast against their actual background (especially inside dialogs), every remaining hardcoded color, and correct semantic color usage across every widget in the app. **This is a two-phase task: produce a full written audit (Phase 1) before changing any code (Phase 2).** Do not start fixing anything until Phase 1's findings are complete and reported.

---

## Phase 1 — Full Audit (No Code Changes Yet)

### 1.0 — Pre-Work

1. Read `core/theme/app_colors_extension.dart` in full — record the **exact current hex value** of every color role, for both `AppColorsExtension.light` and `.dark`.
2. Read `core/theme/app_theme.dart` — record exactly which `ThemeData` sub-themes are explicitly configured (`colorScheme`, `textTheme`, `appBarTheme`, `dialogTheme`, `bottomSheetTheme`, `snackBarTheme`, `cardTheme`, `dividerTheme`, `iconTheme`, `elevatedButtonTheme`, etc.) versus which are left at Flutter's own Material defaults.
3. Read `core/theme/app_text_theme.dart` — record how text styles' colors are set (should be color-agnostic at this layer, with color applied at the call site via `context.colors.*` — confirm this is actually the case, not colors baked into the text theme itself in a way that conflicts with per-widget `context.colors` usage).

### 1.1 — Category A: Missing `ThemeData` Sub-Theme Configuration (Likely Root Cause of the Dialog Issue)

This is the most likely explanation for "colors not showing up on dialog/screen backgrounds" specifically. Flutter's `Dialog`, `BottomSheet`, `SnackBar`, and other component widgets each have their **own** theme slot in `ThemeData` (`dialogTheme`, `bottomSheetTheme`, `snackBarTheme`, etc.). If `AppTheme.light()`/`.dark()` only configured the base `ColorScheme` and `textTheme` but never explicitly set these component-specific sub-themes, then any `Dialog`/`showModalBottomSheet`/`SnackBar` in the app falls back to **Flutter's own Material default colors** for its background — which may not match (and may actively clash with) whatever text/icon colors were manually set inside that dialog's content assuming the app's own `surfaceAlt`/`background` role was the actual backdrop. This exact mismatch — content colored for one background, but the container defaulting to a different actual background — produces precisely the "invisible/low-contrast in dialogs" symptom described.

**Audit:** for every `ThemeData` sub-theme relevant to a widget actually used in this app (check §1.3's inventory for which component types are actually used — `Dialog`, `BottomSheet`, `SnackBar` at minimum, per prior features' bottom sheets and dialogs), confirm whether it's explicitly configured with `context.colors`-derived values or left at Flutter's default. **Record every gap found — do not fix yet.**

### 1.2 — Category B: Hardcoded Colors — Exhaustive Grep

``
grep -rn "Color(0x" lib/
grep -rn "Colors\." lib/ | grep -v "Colors.transparent"
``

For every match outside `core/theme/app_colors_extension.dart` itself, record the file, line, and what color/value it hardcodes. Include colors hardcoded with alpha/opacity modifications (e.g. `colors.primary.withValues(alpha: ...)` is fine — that's a legitimate derived use of a theme color; `Color(0xFFFFFFFF)` or `Colors.white` used directly is not). Pay specific attention to:

- Any icon `color:` parameter across every widget.
- Shadow/glow colors (`BoxShadow.color`).
- Gradient stop colors.
- Any color literal inside a `CustomPainter`'s `paint()` method (a category prone to being overlooked since it's not a standard widget property).

### 1.3 — Category C: Wrong Semantic Role Usage

A color can correctly come from `context.colors.*` and still be **wrong** — e.g. using `textSecondary` where `textPrimary` was needed, or a text/icon color chosen that happens to render correctly in dark mode (where it was likely designed/tested) but has poor contrast against its actual background in light mode, because the two modes' values for that role aren't symmetric in how they'd interact with that specific usage. **This category requires reading each widget's actual rendered context, not just checking "is a `context.colors.*` call present."**

**Audit every widget in `core/widgets/` and every feature's `presentation/widgets/`/`presentation/screens/`**, for every `Text`/`Icon`/decorative color usage, confirm:

1. Which color role is used.
2. What it's rendered against (background/surface/surfaceAlt/primary-filled area/etc.).
3. Whether that specific role-on-role combination is genuinely legible in **both** light and dark theme — reason through the actual hex values recorded in §1.0.1, don't just trust that "using the theme system" automatically means correct contrast; the theme system prevents *hardcoding*, it doesn't automatically guarantee *good pairing choices* by whoever wrote each widget.

Build a table: `Widget → Color role used → Rendered against → Light-mode legible? → Dark-mode legible?` — flag every "no" or "questionable" entry.

### 1.4 — Category D: Validate the Palette Itself, Not Just Its Usage

Separately from usage bugs, check whether **the actual defined hex values** in `AppColorsExtension.light` are internally sound. Using a standard WCAG-style contrast ratio approach (4.5:1 minimum for normal text, 3:1 minimum for large text/icons/UI components), compute or carefully reason about the contrast for every color pairing that's actually used somewhere in the app per §1.3's table (e.g. `textSecondary` on `surfaceAlt`, `textPrimary` on `background`, icon color on `primary`-filled circular badges, badge text on `secondaryVariant`/`error` pill backgrounds). **If the light theme's own defined values are genuinely low-contrast for a pairing that's used in multiple places, the fix belongs in the palette definition itself (§1.0.1's recorded values), not scattered per-widget** — flag this distinctly from Category C (a Category C issue is "the wrong role was picked"; a Category D issue is "the right role was picked, but that role's actual color value is itself the problem").

### 1.5 — Category E: Dark-Mode-Only-Verified Widgets

Given this app's development process, some widgets were very plausibly built and visually checked primarily in dark mode (the app's default/most-used mode during earlier development), with light mode never actually re-checked after. Cross-reference §1.3's table for any widget where the flag pattern suggests "clearly fine in dark, questionable in light" — this is a strong signal the widget was simply never re-verified in light mode at all, rather than a deliberate design choice. List these explicitly as a distinct finding category, since the fix (going back and actually looking at the widget in light mode) is procedural, not just a color-value swap.

### 1.6 — Phase 1 Report

Produce a single structured audit document (can be the response itself, well-organized) covering:

- Every Category A gap (missing sub-theme configs) with the specific `ThemeData` property missing.
- Every Category B hardcoded color instance (file:line, what it hardcodes, suggested replacement role).
- The full Category C table.
- Every Category D palette-level contrast problem, with the specific hex values and computed/reasoned contrast ratio.
- The Category E list.

**Stop here. Do not proceed to Phase 2 until this report is complete.**

---

## Phase 2 — Implement Fixes

Work through the Phase 1 findings in this order (highest-impact, most-likely-root-cause first):

### 2.1 — Fix Category A first

Add the missing `ThemeData` sub-theme configurations to `AppTheme.light()`/`.dark()`, each explicitly built from `AppColorsExtension`'s values (e.g. `dialogTheme: DialogTheme(backgroundColor: colors.surfaceAlt, ...)`, `bottomSheetTheme: BottomSheetThemeData(backgroundColor: colors.surface, ...)`, `snackBarTheme: SnackBarThemeData(backgroundColor: colors.surfaceAlt, contentTextStyle: ...)` — cover every component type actually used in the app, per what was inventoried in Phase 1). This single category of fix is likely to resolve a large share of the reported "colors not visible in dialogs" symptom immediately.

### 2.2 — Fix Category D (palette-level) before Category C (per-widget) usage

If any palette values themselves need adjusting (Category D), fix those in `AppColorsExtension.light`/`.dark` **first** — this may automatically resolve some Category C entries that were flagged as "correct role, but that role's actual color is the problem," without needing a separate per-widget change. Re-check the Category C table against the corrected palette before fixing remaining Category C entries individually.

### 2.3 — Fix remaining Category C (per-widget wrong-role usage)

For each entry still flagged after 2.2, correct the specific widget to use the right semantic role.

### 2.4 — Fix Category B (hardcoded colors)

Replace every hardcoded color with the correct `context.colors.*` role — if no existing role fits, this is a signal a new role may genuinely be needed in `AppColorsExtension` (add it there, with both light/dark values, rather than working around it with a new hardcoded value).

### 2.5 — Re-verify Category E widgets in light mode specifically

For every widget flagged in §1.5, explicitly build/render it in light mode (not just trust that the Category A–D fixes incidentally addressed it) and confirm it now looks correct and intentional, not just "no longer technically hardcoded."

---

## Verification

- Render every major screen and every dialog/bottom sheet in this app, in **both** light and dark theme, and confirm all text/icons are clearly legible against their actual background — this must be checked visually (or via golden tests if the project's testing setup supports them), not just inferred from code review alone.
- Re-run the Category B grep from §1.2 after fixes — confirm zero remaining hardcoded color matches outside `app_colors_extension.dart`.
- `flutter analyze`/`dart format` clean.
- Add or update widget/golden tests confirming key screens build without error under both `AppTheme.light()` and `AppTheme.dark()` (per this project's existing established "theme smoke test" pattern from every prior feature) — extend this pattern specifically to include every `Dialog`/`BottomSheet` now that Category A fixes touch those.

## Report Back

1. The complete Phase 1 audit report (as produced before Phase 2 began).
2. Exactly what was changed in Phase 2, mapped back to each Phase 1 finding (confirm nothing found in Phase 1 was left unaddressed, or explicitly justify why not if something was intentionally deferred).
3. Before/after hex values for any `AppColorsExtension` adjustments made in §2.2, with the contrast reasoning.
4. Confirmation of the full verification pass across both themes.

Do not merge Phase 1 and Phase 2 into a single pass with no visible audit output — the written Phase 1 report is a required deliverable, not an optional planning step, since it's what confirms the fixes in Phase 2 are addressing real, specifically-identified problems rather than incidental changes made while poking around the theme files.
