---
name: rocketx-screen-architecture
description: Build, refactor, or review RocketX SwiftUI feature screens using the project's screen architecture. Use for views, view models, view state, state mapping, assemblies, dependencies, inputs, or feature navigation.
---

# RocketX Screen Architecture

Use these rules as the source of truth for non-trivial RocketX feature screens. Preserve intentional screen-specific behavior instead of forcing textual uniformity.

Before changing a screen, inspect its module, related shared UI, service and navigation contracts, previews, and tests when present.

## Module shape

Create only the roles required by the feature:

```text
Feature/
├── FeatureAssembly.swift
├── FeatureDependencies.swift
├── FeatureInput.swift
├── FeatureStateMapper.swift
├── FeatureView.swift
├── FeatureViewModel.swift
└── FeatureViewState.swift
```

- Add an assembly input when a screen receives navigation parameters.
- An assembly receives input and dependencies, creates the view model, and returns the view. It must not reach into a global container.
- Dependencies contain external services and the feature-specific coordinator, not presentation state.
- Input is a `Sendable` enum of lifecycle events and user actions.
- ViewState contains render-ready data. Use a nested `Content` type for loading/content/error screens when appropriate.
- StateMapper owns localization, formatting, fallback text, and conversion from domain models to view state.
- ViewModel owns state transitions, async work, retry, cancellation, and coordinator calls.
- View renders state and sends inputs. It does not call services or coordinators directly.

Do not create empty files or artificial layers. A small local control or root composition view may remain focused when it has no domain loading or state orchestration.

## Data flow

Keep feature data flow unidirectional:

```text
View action
→ Input
→ ViewModel
→ Service or Coordinator
→ StateMapper
→ ViewState
→ View
```

Do not expose domain models directly to a feature view when the screen presents formatted or combined data. Navigation goes through the feature coordinator.

## View conventions

- Store `Store<State, Input>` in `@State` and initialize its backing storage explicitly.
- Switch over loading, error, and content in the outer view.
- Reuse existing shared components, icons, semantic colors, typography, spacing, and navigation-title conventions.
- Extract substantial loaded UI into a nested `Content: View` with narrowly scoped action closures.
- Keep the `send(_:)` bridge private and use it for store inputs.
- Keep UI-only transient state in the view only when it is not feature state.

Lists may use list-specific rows, filters, empty states, and pagination footers. Architectural consistency means matching responsibility boundaries, not forcing a detail-screen layout onto a list.

## View-model conventions

- Use `@MainActor` and `@Observable` for the observable store.
- Expose state as `private(set)`.
- Keep assembly input, dependencies, mapper, owned tasks, and bookkeeping private.
- Mark task and bookkeeping properties with `@ObservationIgnored`.
- Cancel owned tasks in `deinit`.
- Route public events through `trigger(_:)`.
- Cancel superseded work before starting its replacement and set loading state explicitly.
- Treat cancellation as control flow. Check cancellation before committing asynchronous results.
- Keep pagination guards or request identity mechanisms when behavior requires them.

Use structured concurrency only when captured services and returned values are safely `Sendable`. Do not silence concurrency diagnostics with `@unchecked Sendable` without an established thread-safety guarantee.

## Navigation changes

When an assembly input or coordinator signature changes, trace the full route and update every affected contract:

```text
View Input
→ Feature coordinator protocol
→ Flow coordinator
→ Screen factory protocol
→ Screen factory
→ Assembly input
→ Assembly
```

Remove obsolete overloads and placeholder coordinators after verifying there are no remaining callers.

## Completion

Implement the smallest cohesive migration that preserves behavior. Update affected navigation contracts, previews, mocks, and tests when present. Build both `RocketX Mock` and `RocketX Live` after production Swift changes, then report deliberate exceptions separately from unresolved inconsistencies.
