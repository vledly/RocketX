import Foundation

struct RocketsStateMapper {
    func map(_ rocket: Rocket) -> RocketsViewState.RocketItem {
        RocketsViewState.RocketItem(
            id: rocket.id,
            name: rocket.name,
            type: rocket.type.capitalized,
            successRate: (Double(rocket.successRate) / 100).formatted(
                .percent.precision(.fractionLength(0))
            ),
            imageURL: rocket.imageURL
        )
    }
}
