import Foundation

struct Rocket: Identifiable, Sendable {
    let id: String
    let name: String
    let type: String
    let details: String
    let imageURL: URL?
    let successRate: Int
    let active: Bool
    let stages: Int
    let firstFlight: String
    let engineCount: Int
    let engineType: String
}
