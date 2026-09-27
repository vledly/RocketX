import Foundation

struct RocketsViewState: Sendable {
    enum Status: Sendable {
        case loading
        case content(Content)
        case error
    }

    struct Content: Sendable {
        let items: [RocketItem]
        let paginationStatus: PaginationStatus
    }

    struct RocketItem: Identifiable, Sendable {
        let id: String
        let name: String
        let type: String
        let successRate: String
        let imageURL: URL?
    }

    var status: Status = .loading
}
