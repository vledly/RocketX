import Foundation
import Observation

@MainActor
@Observable
final class AppCoordinator: ILoadingCoordinator {
    private(set) var route: AppRoute = .loading
    private let launchesFactory: any ILaunchesScreensFactory
    private let rocketsFactory: any IRocketsScreensFactory

    init(
        launchesFactory: any ILaunchesScreensFactory,
        rocketsFactory: any IRocketsScreensFactory
    ) {
        self.launchesFactory = launchesFactory
        self.rocketsFactory = rocketsFactory
    }

    func loadingDidFinish() {
        guard case .loading = route else { return }
        let coordinator = MainFlowCoordinator(
            launchesFactory: launchesFactory,
            rocketsFactory: rocketsFactory
        )
        route = .main(coordinator)
    }
}
