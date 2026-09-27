enum PaginationLoad<Item: Sendable>: Sendable {
    case first
    case next(existingItems: [Item])
}
