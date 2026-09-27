import Foundation

struct LaunchDetailsStateMapper {
    func map(launch: Launch, rocket: Rocket, launchpad: Launchpad) -> LaunchDetailsViewState.Content {
        LaunchDetailsViewState.Content(
            title: launch.name,
            description: launch.details.flatMap { $0.isEmpty ? nil : $0 }
                ?? String(localized: .launchDetailsGeneratedDescription(
                    launch.name,
                    launch.date.formatted(date: .long, time: .omitted),
                    launchpad.fullName,
                    rocket.name
                )),
            imageURL: launch.imageURL,
            launchSite: launchpad.fullName,
            date: launch.date.formatted(date: .long, time: .shortened),
            status: launch.status,
            webcastURL: launch.webcastURL,
            rocketID: rocket.id,
            rocketName: rocket.name,
            rocketType: rocket.type.capitalized,
            rocketImageURL: rocket.imageURL
        )
    }
}
