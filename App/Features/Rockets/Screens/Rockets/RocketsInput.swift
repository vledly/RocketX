enum RocketsInput: Sendable {
    case viewDidFirstAppear
    case loadNextPage
    case retryNextPage
    case retry
    case didSelectRocket(id: String)
}
