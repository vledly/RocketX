final class RocketsDependencies {
    weak var coordinator: (any IRocketsCoordinator)?
    let rocketsService: any IRocketsService

    init(
        coordinator: any IRocketsCoordinator,
        rocketsService: any IRocketsService
    ) {
        self.coordinator = coordinator
        self.rocketsService = rocketsService
    }
}
