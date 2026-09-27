struct RocketsListRequest: Sendable {
    let page: Int
    let perPage: Int

    init(page: Int, perPage: Int = 10) {
        self.page = page
        self.perPage = perPage
    }
}
