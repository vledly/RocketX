final class LaunchesDependencies {
    weak var coordinator: (any ILaunchesCoordinator)?
    let facade: any ILaunchesFacade

    init(
        coordinator: any ILaunchesCoordinator,
        facade: any ILaunchesFacade
    ) {
        self.coordinator = coordinator
        self.facade = facade
    }
}
