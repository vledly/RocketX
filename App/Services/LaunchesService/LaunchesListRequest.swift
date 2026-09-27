struct LaunchesListRequest: Sendable {
    let page: Int
    let perPage: Int
    let dateRange: LaunchDateRange

    init(
        page: Int,
        perPage: Int = 10,
        dateRange: LaunchDateRange = .all
    ) {
        self.page = page
        self.perPage = perPage
        self.dateRange = dateRange
    }
}
