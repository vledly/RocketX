@MainActor
protocol ILaunchesFacade: AnyObject {
    func fetchList(
        request: LaunchesListRequest
    ) async throws -> PaginatedList<LaunchWithLaunchpad>
}

@MainActor
final class LaunchesFacade: ILaunchesFacade {
    private let launchesService: any ILaunchesService
    private let launchpadsService: any ILaunchpadsService
    private var launchpads: [String: Launchpad] = [:]

    init(
        launchesService: any ILaunchesService,
        launchpadsService: any ILaunchpadsService
    ) {
        self.launchesService = launchesService
        self.launchpadsService = launchpadsService
    }

    func fetchList(
        request: LaunchesListRequest
    ) async throws -> PaginatedList<LaunchWithLaunchpad> {
        let response = try await launchesService.fetchList(request: request)
        try Task.checkCancellation()

        var items: [LaunchWithLaunchpad] = []
        items.reserveCapacity(response.items.count)

        for launch in response.items {
            let launchpad = try await launchpad(id: launch.launchpadID)
            try Task.checkCancellation()
            items.append(LaunchWithLaunchpad(
                launch: launch,
                launchpad: launchpad
            ))
        }

        return PaginatedList(
            items: items,
            page: response.page,
            perPage: response.perPage,
            total: response.total,
            hasNextPage: response.hasNextPage
        )
    }

    private func launchpad(id: String) async throws -> Launchpad {
        if let launchpad = launchpads[id] {
            return launchpad
        }

        let launchpad = try await launchpadsService.detail(id: id)
        try Task.checkCancellation()
        launchpads[id] = launchpad
        return launchpad
    }
}
