protocol ILaunchesService: AnyObject {
    func fetchList(
        request: LaunchesListRequest
    ) async throws -> PaginatedList<Launch>

    func detail(id: String) async throws -> Launch
}

final class LaunchesService: ILaunchesService {
    private let networkClient: any INetworkClient
    private let mapper: LaunchesServiceMapper

    init(
        networkClient: any INetworkClient,
        mapper: LaunchesServiceMapper = .init()
    ) {
        self.networkClient = networkClient
        self.mapper = mapper
    }

    func fetchList(
        request: LaunchesListRequest
    ) async throws -> PaginatedList<Launch> {
        let response: QueryResponseDTO<LaunchDTO> = try await networkClient.request(
            endpoint: LaunchesServiceAPIBuilder.list(request).build()
        )

        return try mapper.map(response)
    }

    func detail(id: String) async throws -> Launch {
        let response: LaunchDTO = try await networkClient.request(
            endpoint: LaunchesServiceAPIBuilder.detail(id: id).build()
        )

        return try mapper.map(response)
    }
}
