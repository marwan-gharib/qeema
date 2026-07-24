---
description: >
  Engineering rules for a Flutter project using feature-first Clean
  Architecture — Cubit state management, get_it DI, go_router navigation,
  dio via BaseApiClient, slang localization, Dart 3+ native patterns (no
  Freezed/build_runner), and ApiResult<T> error handling. Style, naming,
  and formatting are enforced by `analysis_options.yaml` and are not
  repeated here — this file only covers decisions a linter cannot check.
---

# Flutter Project — AI Agent Rules

## 1. Working Agreement

- If a requirement is ambiguous, ask **one** focused question before writing code.
- Read the relevant files before modifying them; state what you found.
- Make the smallest change that solves the problem — no drive-by refactoring.
- Never guess a file path — search for it or ask.
- State assumptions explicitly at the top of your response.
- Never rename, move, or delete files without explicit instruction.
- Never modify `pubspec.yaml` or `analysis_options.yaml` without explicit approval.
- If a request conflicts with this file, say so and ask — don't silently override it.
- `flutter analyze` and `dart format` must pass clean before a change is done.

## 2. Architecture — Feature-First Clean Architecture

```
lib/
  core/
    constants/   # constants used across features, split to multiple files
    error/
    network/     # Based on AbstractApiClient, with interceptors for auth, logging, and error mapping
    di/
    local/
      secure/   # Based on Interfaces, for auth tokens and other sensitive data
      cache/    # Based on Interfaces, for non-sensitive data
    router/
    services/
    extensions/
    theme/
    utils/      # ApiResult(having fold() function instead of switch), mappers, UseCases, and other generic utilities
    helpers/    # Have helpers for common tasks, like formatting, validation, etc. 
  features/<feature_name>/
    presentation/
      screens/
      widgets/
      cubits/<cubit_or_bloc_name>/ # Cubit or Bloc + sealed state, per §3 below
    domain/
      entities/
      repositories/                # abstract contracts only
      usecases/
      params/                       # one *Params class per usecase with >1 input
    data/
      datasources/
        remote/                     # concrete classes, no interface
        local/                      # concrete classes, no interface
      models/
      repositories/                 # *RepositoryImpl
      mappers/
```

**Layer flow is one-directional and never bypassed: Presentation → Domain → Data.**

| Layer        | Allowed                                   | Forbidden                              |
|--------------|--------------------------------------------|-----------------------------------------|
| Presentation | Widgets, Cubit, UI state, view models     | Business logic, direct API/DB calls     |
| Domain       | Usecases, entities, params, repo contracts | Any `package:flutter/...` import        |
| Data         | API/DB calls, models, repo implementations | `BuildContext`, UI logic                |

- Business logic never lives in `initState`, `build()`, or a widget callback.
- Domain entities are never used directly in the UI — map to a view model first.
- Code used by 2+ features belongs in `core/` — check `core/` before writing
  anything that looks reusable.
- Datasources have **no abstract interface** — `RemoteDataSource`/
  `LocalDataSource` are plain concrete classes. The only abstraction boundary
  is the Repository contract (`domain/repositories/*.dart`); `RepositoryImpl`
  calls the datasources directly.
- all thing in `core/` must be based on abstractions like (api client, secure storage, cache storage, etc.) and never directly on a package like dio, shared_preferences, flutter_secure_storage, etc. This is to make it easier to swap out the implementation if needed in the future, and not forget error handling in implementation of all base clients.
- if there are any classes not abstract but mustn't used by instants, make constructor private.

## 3. State Management

- Choose Cubit or Bloc **based on what the flow actually needs** — this is not
  a "Cubit always, Bloc as an exception" rule. Use Bloc normally whenever a
  flow calls for event transformation, e.g.:
  - **Debounce/throttle** on user input (search-as-you-type, live filters)
  - Needing `restartable`/`sequential`/`droppable`/`concurrent` event
    processing (via `bloc_concurrency`)
  - A stream of discrete events that must be transformed/merged before
    producing state (e.g. combining two input streams)
  - Explicit event-sourcing/replay/audit-log requirements
  Use Cubit for straightforward "call a usecase → emit a state" flows with
  no event-stream transformation. If unsure which one fits, default to
  asking rather than guessing.
- A Cubit/Bloc depends **only** on usecases — never on a repository directly.
- States are `sealed class`; the UI uses an exhaustive `switch`, never `is` checks.
- No `FutureBuilder`/`StreamBuilder` wrapping a Cubit — the Cubit owns the async state.

## 4. UseCase & Params Pattern

```dart
abstract class UseCase<Output, Input> {
  Future<ApiResult<Output>> call(Input input);
}

// For usecases that take no input at all — don't force a dummy Params
// object (e.g. `NoParams()`) through the interface above.
abstract class UseCaseWithoutParams<Output> {
  Future<ApiResult<Output>> call();
}
```

- Every usecase file/class ends in `UseCase` (e.g. `login_usecase.dart` →
  `LoginUseCase`) — never a variant spelling like `UsseCase`.
- A usecase taking more than one primitive input takes a single `Params`
  object from `domain/params/`, never multiple positional/named primitives.
  A usecase with exactly one primitive/id input may take it directly.
- A usecase with **no input** implements `UseCaseWithoutParams<Output>`
  instead of `UseCase<Output, Input>` — e.g. `GetSessionUseCase implements
  UseCaseWithoutParams<UserEntity>`. This keeps `call()` truly argument-free
  instead of calling it with an empty placeholder object, and keeps the
  `Params`-object rule meaningful (it only ever applies when there's
  something to pass).
- Usecases return `ApiResult<T>` only — no nullable returns, no raw exceptions.

## 5. Error Handling

- `ApiResult<T>` is the only result type crossing layer boundaries.
- Data layer: catch exceptions, map to a `Failure` subtype.
- Domain: propagate as `ApiResult`.
- Presentation: map the result to a Cubit state — never handle raw exceptions in the UI.
- Every list/detail screen has an explicit loading, success, empty, and error state.

## 6. Dependency Injection

- `get_it` only; all registrations live in `core/di/`.
- Cubits → `registerFactory`. Usecases and repositories → `registerLazySingleton`.
- No global service-locator access inside widgets — a widget gets everything
  through its injected Cubit.

## 7. Networking

- `dio` only, and only through `BaseApiClient` — no direct `dio` calls from
  a datasource.
- Interceptors own auth-token attachment, logging, and error mapping; don't
  duplicate that logic per-datasource.
- Validate request/response shape at the data-layer boundary, not later.

## 8. Navigation

- `go_router` only, routes declared in `core/router/`. No `Navigator.push`.
- Navigation is triggered from the Cubit/listener, never built inline in a widget.
- Pass IDs/primitives between routes — never a full entity/object.

## 9. Theming & Shared UI

- All styling comes from `Theme.of(context)` — colors from a
  `ThemeExtension` (e.g. `AppColorsExtension`), text from `theme.textTheme`.
  Never reference a raw `AppColors`/`AppTextStyles` constant from a widget.
- Reuse existing `core/widgets/` components (`AppButton`, `AppTextField`,
  `AppLoader`, `AppSnackBar`, ...) — never re-implement one.
- Wrap any `context` access used in 2+ places in a `BuildContext` extension.

## 10. Localization

- No hardcoded user-facing string, ever. Use `context.t.feature.key`.
- Add new keys to `assets/i18n/*.json`, then run `dart run slang`.

## 11. Data Mapping

- DTO ↔ Entity conversion happens only in a `Mapper` class — never inline
  inside a Cubit, a repository method, or a widget.

## 12. Pagination & Caching

- Pagination and caching logic live only in the repository layer — the UI
  requests a page and renders `hasMore`; it never computes offsets or caches
  data itself.

## 13. Dependencies

- No new package without explicit approval — check whether an SDK feature
  or something already in `core/` covers it first.

## 14. Comments Policy

- Don't comment obvious code — the code should read on its own.
- Write a comment only for: a non-obvious business rule, a deliberate
  workaround (with a one-line reason), or a decision someone would
  otherwise question in review.
- A comment explains **why**, never **what** — if it restates the line
  below it, delete it.

## 15. Testing

- No feature is done without tests: unit tests (domain + data), Cubit
  tests, and widget tests for its screens.
- A bug fix ships with a regression test.
- One behavior per test.

## 16. Workflow (per change)

1. Read the existing code touching this area.
2. State assumptions.
3. Apply the smallest correct fix.
4. Run `flutter analyze` and `dart format`.
5. Self-review the diff against this file before calling it done.

## 17. Staying Current

- Flag any deprecated API or outdated pattern you encounter, even if unrelated
  to the current task — don't fix it silently, mention it.
- Prefer an SDK/Dart 3 native feature over adding a package for the same job.

## 18. Style, Naming & Formatting

Everything mechanically checkable — naming conventions, `const`
constructors, `print()` usage, unawaited futures, file length, import
ordering, and so on — is enforced by `analysis_options.yaml`, not repeated
here as prose. If `flutter analyze` is clean, the code meets this project's
style bar. See `analysis_options.yaml` for the enforced rule set.

## 19. Agent Response Style

- Don't restate the task or the plan before doing it — just do it, then
  report what changed.
- No filler openers/closers ("Sure!", "Great question!", "Let me know if
  you need anything else!") — start with the substance, end when it's done.
- Summarize a change in a few bullet points; don't narrate every line you
  touched or re-paste a full file that's already visible in the diff/tool
  output.
- Answer exactly what was asked — don't append unrequested extra
  suggestions, alternatives, or "while I was at it" changes; mention them
  in one short line at most, and only if genuinely worth flagging.
- When something is ambiguous, ask the one question that unblocks you
  instead of generating a large speculative answer and hoping it matches.
- Prefer a short diff/patch-style description over pasting an entire file
  back into the response when only a few lines changed.