import Foundation

struct RocketDetailsViewState {
    enum Status {
        case loading
        case content(Content)
        case error
    }

    struct Content {
        let title: String
        let type: String
        let description: String
        let imageURL: URL?
        let activeStatus: LocalizedStringResource
        let stages: String
        let engines: String
        let engineType: String
        let firstFlight: String
    }

    var status: Status = .loading
}
