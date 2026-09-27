struct LaunchpadDTO: Decodable, Sendable {
    let id: String
    let name: String
    let fullName: String

    private enum CodingKeys: String, CodingKey {
        case id, name
        case fullName = "full_name"
    }
}
