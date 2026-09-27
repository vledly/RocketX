struct RocketDTO: Decodable, Sendable {
    struct EnginesDTO: Decodable, Sendable {
        let number: Int
        let type: String
    }

    let id: String
    let name: String
    let type: String
    let description: String
    let flickrImages: [String]
    let successRate: Int
    let active: Bool
    let stages: Int
    let firstFlight: String
    let engines: EnginesDTO

    enum CodingKeys: String, CodingKey {
        case id, name, type, description, active, stages, engines
        case flickrImages = "flickr_images"
        case successRate = "success_rate_pct"
        case firstFlight = "first_flight"
    }
}
