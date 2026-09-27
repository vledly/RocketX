struct QueryResponseDTO<Item: Decodable & Sendable>: Decodable, Sendable {
    let docs: [Item]
    let totalDocs: Int
    let limit: Int
    let page: Int
    let hasNextPage: Bool
}
