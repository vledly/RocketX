import Observation

@MainActor
@Observable
final class MainFlowCoordinator: IMainCoordinator {
    private(set) var selectedTab: MainTab = .launches

    @ObservationIgnored
    let launchesFlow: LaunchesFlowCoordinator

    @ObservationIgnored
    let rocketsFlow: RocketsFlowCoordinator

    init(
        launchesFactory: any ILaunchesScreensFactory,
        rocketsFactory: any IRocketsScreensFactory
    ) {
        launchesFlow = LaunchesFlowCoordinator(
            factory: launchesFactory,
            rocketDetailsFactory: rocketsFactory
        )
        rocketsFlow = RocketsFlowCoordinator(factory: rocketsFactory)
    }

    func select(_ tab: MainTab) {
        selectedTab = tab
    }
}
