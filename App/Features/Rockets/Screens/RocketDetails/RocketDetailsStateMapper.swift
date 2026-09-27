import Foundation

struct RocketDetailsStateMapper {
    func map(_ rocket: Rocket) -> RocketDetailsViewState.Content {
        RocketDetailsViewState.Content(
            title: rocket.name,
            type: rocket.type.capitalized,
            description: rocket.details,
            imageURL: rocket.imageURL,
            activeStatus: rocket.active ? .rocketStatusActive : .rocketStatusInactive,
            stages: String(rocket.stages),
            engines: String(rocket.engineCount),
            engineType: rocket.engineType.capitalized,
            firstFlight: rocket.firstFlight
        )
    }
}
