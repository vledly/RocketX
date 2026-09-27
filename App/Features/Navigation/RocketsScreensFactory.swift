import SwiftUI

@MainActor
struct RocketsScreensFactory: IRocketsScreensFactory {
    private let rocketsService: any IRocketsService

    init(rocketsService: any IRocketsService) {
        self.rocketsService = rocketsService
    }

    func createRockets(
        coordinator: any IRocketsCoordinator
    ) -> Screen {
        let dependencies = RocketsDependencies(
            coordinator: coordinator,
            rocketsService: rocketsService
        )
        let view = RocketsAssembly.build(dependencies: dependencies)
        return Screen { view }
    }

    func createRocketDetails(
        input: RocketDetailsAssemblyInput
    ) -> Screen {
        let dependencies = RocketDetailsDependencies(
            rocketsService: rocketsService
        )
        let view = RocketDetailsAssembly.build(
            input: input,
            dependencies: dependencies
        )
        return Screen { view }
    }
}
