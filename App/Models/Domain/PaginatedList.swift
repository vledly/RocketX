struct PaginatedList<Item: Sendable>: Sendable {
    let items: [Item]
    let page: Int
    let perPage: Int
    let total: Int
    let hasNextPage: Bool
}
