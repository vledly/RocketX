import Foundation

struct LaunchesViewStateMapper {
    func map(_ item: LaunchWithLaunchpad) -> LaunchesViewState.LaunchItem {
        return LaunchesViewState.LaunchItem(
            id: item.launch.id,
            title: item.launch.name,
            launchSite: item.launchpad.name,
            date: item.launch.date.formatted(date: .long, time: .omitted),
            status: item.launch.status,
            imageURL: item.launch.thumbnailURL
        )
    }
}
