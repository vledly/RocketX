# RocketX repository instructions

## Project

RocketX is a SwiftUI application written in Swift 6 with an iOS 27 deployment target. It has no third-party package dependencies.

The project provides two shared schemes:

- `RocketX Mock` uses bundled JSON fixtures and is the deterministic default.
- `RocketX Live` uses the archived SpaceX v4 API through `NetworkClient`.

Preserve both configurations when changing services, DTOs, mapping, dependency composition, or build settings. If `ROCKETX_BACKEND` is absent, the application must continue to fall back to mock mode.

## Architecture

For work on feature screens, read and follow `.agents/skills/rocketx-screen-architecture/SKILL.md`.

Keep boundaries explicit:

- Views render `ViewState` and translate UI callbacks into `Input` values. They do not call services or coordinators directly.
- View models own state transitions, asynchronous work, cancellation, retry, and navigation actions.
- State mappers convert domain models into render-ready, localized, and formatted view data.
- Service mappers convert DTOs into domain models.
- Assemblies create screens from assembly input and dependencies.
- Coordinators, screen factories, and routers own navigation.
- `AppContainer` selects live or mock service implementations.

Do not move mock-only fallbacks or fixture-specific transformations into shared or live service mappers.

## Verification

After changing production Swift code, build both shared schemes unless the change is demonstrably isolated from one of them:

```sh
xcodebuild -project RocketX.xcodeproj -scheme 'RocketX Mock' -configuration Debug -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO build
xcodebuild -project RocketX.xcodeproj -scheme 'RocketX Live' -configuration Debug -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO build
```

Documentation-only changes do not require an Xcode build. Run the tests affected by the requested change.

## Change discipline

- Preserve unrelated existing changes.
- Prefer the smallest cohesive change that preserves current behavior.
- Do not add third-party dependencies unless explicitly requested.
- Treat cancellation as control flow rather than a user-visible failure.
- Do not use `@unchecked Sendable` unless thread safety has been established and documented.
- Update `MOCK_DATA.md` when fixture contents, provenance, or mock-only transformations change.
