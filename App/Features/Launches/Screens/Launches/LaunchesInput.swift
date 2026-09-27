enum LaunchesInput: Sendable {
    case viewDidFirstAppear
    case retry
    case loadNextPage
    case retryNextPage
    case applyDateRange(LaunchDateRange)
    case didSelectLaunch(id: String)
}
