struct LaunchDTO: Decodable, Sendable {
    struct LinksDTO: Decodable, Sendable {
        struct PatchDTO: Decodable, Sendable {
            let small: String?
            let large: String?
        }

        struct FlickrDTO: Decodable, Sendable {
            let original: [String]
        }

        let patch: PatchDTO?
        let flickr: FlickrDTO?
        let webcast: String?
    }

    let id: String
    let name: String
    let details: String?
    let dateUTC: String
    let success: Bool?
    let upcoming: Bool
    let rocket: String
    let launchpad: String
    let links: LinksDTO?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case details
        case dateUTC = "date_utc"
        case success
        case upcoming
        case rocket
        case launchpad
        case links
    }
}
