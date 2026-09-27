# RocketX

RocketX is a SwiftUI application for browsing SpaceX launches and rockets. It includes launch-date filtering, paginated lists, launch and rocket details, loading and error states, and retry support.

The project can run against bundled mock data or the archived SpaceX v4 API without changing the UI layer.

## Requirements

- Xcode with the iOS 27 SDK
- Swift 6
- iOS 27.0 or later

The project has no third-party package dependencies.

## Running the app

1. Open `RocketX.xcodeproj` in Xcode.
2. Select an iOS simulator or connected device.
3. Choose one of the shared schemes described below.
4. Build and run the app.

`RocketX Mock` is the recommended scheme because it works independently of the archived SpaceX API.

## Schemes

| Scheme | Backend | Purpose |
| --- | --- | --- |
| `RocketX Mock` | Bundled JSON fixtures | Stable development and review mode |
| `RocketX Live` | `https://api.spacexdata.com/v4` | Demonstrates the live network implementation |

The schemes set `ROCKETX_BACKEND` to `mock` or `live` in their Run action. When the variable is absent, the application intentionally falls back to mock mode. Consequently, Profile and Archive actions also use mock mode unless the environment is configured separately.

## Live API availability

The public SpaceX v4 API is archived and is no longer reliably available. On September 28, 2026, both the rockets endpoint and the launches query endpoint returned HTTP 525 (Cloudflare could not complete the SSL handshake with the origin server).

The live implementation remains in the project to demonstrate the network layer and its service contracts. Use `RocketX Mock` for a deterministic application flow.

## Architecture

Feature screens use a unidirectional data flow:

```text
View action
→ Input
→ ViewModel
→ Service or Coordinator
→ StateMapper
→ ViewState
→ View
```

Each non-trivial screen is composed from focused types such as `Assembly`, `Dependencies`, `Input`, `ViewModel`, `StateMapper`, `ViewState`, and `View`.

The main architectural responsibilities are:

- `AppContainer` selects live or mock service implementations.
- Services request or load DTOs and use service mappers to create domain models.
- View models own screen state, asynchronous work, cancellation, retry, and navigation actions.
- State mappers convert domain models into render-ready view state.
- Assemblies and feature dependencies make screen construction explicit.
- Coordinators, screen factories, and a router own navigation for each tab.
- `PaginationController` provides the shared pagination mechanism for list screens.
- `LaunchesFacade` combines launches with their launchpad data and caches resolved launchpads.

The UI is implemented with SwiftUI and Observation. The app does not rely on third-party architecture or networking frameworks.

## Mock data

Mock mode uses bundled launch, rocket, and launchpad JSON fixtures. Their provenance, selection rules, pagination behavior, and intentional image fallback are documented in [MOCK_DATA.md](MOCK_DATA.md).

## Current scope and limitations

- Live mode depends on an archived external API and may fail independently of the application.
- Mock data is a fixed historical snapshot rather than a continuously updated dataset.
- Images are loaded from external URLs and may become unavailable; the UI displays placeholders when loading fails.
- Deep links, persistence, and offline synchronization are outside the current scope.
- A focused unit test covers launch-details state mapping; broader automated coverage is outside the current scope.
