@MainActor
final class AppContainer {
    let networkClient: any INetworkClient
    let launchesService: any ILaunchesService
    let rocketsService: any IRocketsService
    let launchpadsService: any ILaunchpadsService

    convenience init(mode: BackendMode = .current) {
        let networkClient = NetworkClient(baseURL: Core.rocketXBaseURL)

        switch mode {
        case .mock:
            self.init(
                networkClient: networkClient,
                launchesService: MockLaunchesService(),
                rocketsService: MockRocketsService(),
                launchpadsService: MockLaunchpadsService()
            )
        case .live:
            self.init(
                networkClient: networkClient,
                launchesService: LaunchesService(networkClient: networkClient),
                rocketsService: RocketsService(networkClient: networkClient),
                launchpadsService: LaunchpadsService(networkClient: networkClient)
            )
        }
    }

    init(
        networkClient: any INetworkClient,
        launchesService: any ILaunchesService,
        rocketsService: any IRocketsService,
        launchpadsService: any ILaunchpadsService
    ) {
        self.networkClient = networkClient
        self.launchesService = launchesService
        self.rocketsService = rocketsService
        self.launchpadsService = launchpadsService
    }
}
