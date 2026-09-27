import Observation

@MainActor
@Observable
final class LaunchesFlowCoordinator:
    ILaunchesCoordinator,
    ILaunchDetailsCoordinator
{
    @ObservationIgnored
    private let factory: any ILaunchesScreensFactory

    @ObservationIgnored
    private let rocketDetailsFactory: any IRocketDetailsScreenFactory

    @ObservationIgnored
    lazy var router = Router(
        root: factory.createLaunches(coordinator: self)
    )

    init(
        factory: any ILaunchesScreensFactory,
        rocketDetailsFactory: any IRocketDetailsScreenFactory
    ) {
        self.factory = factory
        self.rocketDetailsFactory = rocketDetailsFactory
    }

    func showLaunchDetails(input: LaunchDetailsAssemblyInput) {
        pushIfReady(factory.createLaunchDetails(
            input: input,
            coordinator: self
        ))
    }

    func showRocketDetails(id: String) {
        pushIfReady(rocketDetailsFactory.createRocketDetails(
            input: RocketDetailsAssemblyInput(rocketID: id)
        ))
    }

    private func pushIfReady(_ screen: @autoclosure () -> Screen) {
        guard router.isReady else { return }
        router.push(screen())
    }
}
