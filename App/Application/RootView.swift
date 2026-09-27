import SwiftUI

struct RootView: View {
    @State private var coordinator: AppCoordinator
    @State private var loadingScreen: Screen

    init(container: AppContainer) {
        let rocketsFactory = RocketsScreensFactory(
            rocketsService: container.rocketsService
        )
        let launchesFactory = LaunchesScreensFactory(
            launchesService: container.launchesService,
            rocketsService: container.rocketsService,
            launchpadsService: container.launchpadsService
        )
        let coordinator = AppCoordinator(
            launchesFactory: launchesFactory,
            rocketsFactory: rocketsFactory
        )
        let loadingView = LoadingAssembly.build(
            dependencies: LoadingDependencies(coordinator: coordinator)
        )
        _coordinator = State(initialValue: coordinator)
        _loadingScreen = State(initialValue: Screen { loadingView })
    }

    var body: some View {
        Group {
            switch coordinator.route {
            case .loading:
                loadingScreen.content()
            case let .main(mainCoordinator):
                MainAssembly.build(coordinator: mainCoordinator)
            }
        }
    }
}

#Preview {
    RootView(container: AppContainer())
}
