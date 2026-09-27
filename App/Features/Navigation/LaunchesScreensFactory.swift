import SwiftUI

@MainActor
struct LaunchesScreensFactory: ILaunchesScreensFactory {
    private let launchesService: any ILaunchesService
    private let rocketsService: any IRocketsService
    private let launchpadsService: any ILaunchpadsService

    init(
        launchesService: any ILaunchesService,
        rocketsService: any IRocketsService,
        launchpadsService: any ILaunchpadsService
    ) {
        self.launchesService = launchesService
        self.rocketsService = rocketsService
        self.launchpadsService = launchpadsService
    }

    func createLaunches(
        coordinator: any ILaunchesCoordinator
    ) -> Screen {
        let facade = LaunchesFacade(
            launchesService: launchesService,
            launchpadsService: launchpadsService
        )
        let dependencies = LaunchesDependencies(
            coordinator: coordinator,
            facade: facade
        )
        let view = LaunchesAssembly.build(dependencies: dependencies)
        return Screen { view }
    }

    func createLaunchDetails(
        input: LaunchDetailsAssemblyInput,
        coordinator: any ILaunchDetailsCoordinator
    ) -> Screen {
        let dependencies = LaunchDetailsDependencies(
            launchesService: launchesService,
            rocketsService: rocketsService,
            launchpadsService: launchpadsService,
            coordinator: coordinator
        )
        let view = LaunchDetailsAssembly.build(
            input: input,
            dependencies: dependencies
        )
        return Screen { view }
    }
}
