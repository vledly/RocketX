final class LaunchDetailsDependencies {
    let launchesService: any ILaunchesService
    let rocketsService: any IRocketsService
    let launchpadsService: any ILaunchpadsService
    weak var coordinator: (any ILaunchDetailsCoordinator)?

    init(
        launchesService: any ILaunchesService,
        rocketsService: any IRocketsService,
        launchpadsService: any ILaunchpadsService,
        coordinator: any ILaunchDetailsCoordinator
    ) {
        self.launchesService = launchesService
        self.rocketsService = rocketsService
        self.launchpadsService = launchpadsService
        self.coordinator = coordinator
    }
}
