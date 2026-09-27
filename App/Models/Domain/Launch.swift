import Foundation

struct Launch: Identifiable, Sendable {
    enum Status: Sendable {
        case upcoming
        case successful
        case failed
        case unknown
    }

    let id: String
    let name: String
    let details: String?
    let date: Date
    let status: Status
    let rocketID: String
    let launchpadID: String
    let imageURL: URL?
    let thumbnailURL: URL?
    let webcastURL: URL?
}
