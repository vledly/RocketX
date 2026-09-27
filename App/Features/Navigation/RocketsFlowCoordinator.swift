import Observation

@MainActor
@Observable
final class RocketsFlowCoordinator: IRocketsCoordinator {
    @ObservationIgnored
    private let factory: any IRocketsScreensFactory

    @ObservationIgnored
    lazy var router = Router(
        root: factory.createRockets(coordinator: self)
    )

    init(factory: any IRocketsScreensFactory) {
        self.factory = factory
    }

    func showRocketDetails(id: String) {
        pushIfReady(factory.createRocketDetails(
            input: RocketDetailsAssemblyInput(rocketID: id)
        ))
    }

    private func pushIfReady(_ screen: @autoclosure () -> Screen) {
        guard router.isReady else { return }
        router.push(screen())
    }
}
