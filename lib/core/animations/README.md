# core/animations — cheat sheet

All motion in the app lives here (ANIM-1). Import the barrel `core/animations/animations.dart`.
Every piece honours `MediaQuery.disableAnimations`: reduced motion renders statically or skips.

## Tokens — `AppMotion`

- Durations: `fast` 150ms · `normal` 300ms · `slow` 500ms · `staggerStep` 60ms ·
  `maxStaggerTotal` 1200ms · `heroDelay` 1000ms · `heroPulse` 1500ms · `hero` 2000ms ·
  `heroSlow` 3000ms · `heroSequence` 4000ms · `splashSequence` 5000ms.
- Curves: `entrance` (easeOutCubic) · `exit` (easeInCubic) · `emphasized` (easeOutBack) ·
  `standard` (easeInOut).

Never write a raw `Duration` or `Curves.*` for motion (ANIM-2) — use these tokens.

## Entrances

| Piece | Use |
|---|---|
| `AppAnimatedEntry` | Wraps any child; plays one entrance on mount. Params: `type`, `duration`, `delay`, `curve`. |
| `EntryAnimationType` | `fadeIn`, `fadeSlideUp`, `fadeSlideDown`, `fadeSlideRight`, `scaleIn`, `popIn`, `none`. |
| `StaggeredListAnimator` | Wraps each list child in `AppAnimatedEntry` with an `i * staggerStep` delay (capped). Use for animated lists and grids (ANIM-5). |

## Feedback / micro-interactions

| Piece | Use |
|---|---|
| `TapScale` | Press-down scale for tappable non-button areas. Params: `onTap`, `scaleDown` (0.96). |
| `SuccessPulse` | One-shot scale pulse + checkmark fade-in when `triggered` flips true. |
| `AnimatedCounter` | Counts from the previous to the new `Decimal` value; needs a `formatter`. |

## Loading placeholders

`ShimmerBox` · `ShimmerLine` · `ShimmerCard` · `ShimmerListPlaceholder` — animated gradient-sweep
skeletons; static boxes under reduced motion. Screens use geometry-matched skeletons (ANIM-4);
long lists use `ShimmerListPlaceholder`.

## Page transitions (go_router)

`fadeThroughPage` · `slideUpPage` · `sharedAxisPage(forward: ...)` — return `CustomTransitionPage`s
for use in `core/router/` route builders. No raw `PageRouteBuilder` / `CustomTransitionPage`
anywhere else (ANIM-2).

## Known gaps (do not hand-roll in features — ANIM-3)

Not built yet: a state-switch helper (`AppAnimatedSwitcher`), `AnimatedVisibility`,
`ExpandableSection`, dialog/bottom-sheet motion, a Lottie wrapper. Compose from the pieces above;
if they cannot express the motion, stop and ask instead of writing a custom animation.
