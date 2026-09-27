import Foundation

struct LaunchDetailsViewState {
    enum Status {
        case loading
        case content(Content)
        case error
    }

    struct Content {
        let title: String
        let description: String
        let imageURL: URL?
        let launchSite: String
        let date: String
        let status: Launch.Status
        let webcastURL: URL?
        let rocketID: String
        let rocketName: String
        let rocketType: String
        let rocketImageURL: URL?
    }

    var status: Status = .loading
}
