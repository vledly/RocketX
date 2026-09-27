import Foundation

struct LaunchesViewState: Sendable {
    enum Status: Sendable {
        case loading
        case content(Content)
        case error
    }

    struct Content: Sendable {
        let items: [LaunchItem]
        let paginationStatus: PaginationStatus
    }

    struct LaunchItem: Identifiable, Sendable {
        let id: String
        let title: String
        let launchSite: String
        let date: String
        let status: Launch.Status
        let imageURL: URL?
    }

    var dateRange: LaunchDateRange = .all
    var suggestedFilterDate: Date?
    var status: Status = .loading
}
