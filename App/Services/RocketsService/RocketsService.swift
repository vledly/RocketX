protocol IRocketsService: AnyObject {
    func fetchList(request: RocketsListRequest) async throws -> PaginatedList<Rocket>
    func detail(id: String) async throws -> Rocket
}

final class RocketsService: IRocketsService {
    private let networkClient: any INetworkClient
    private let mapper: RocketsServiceMapper

    init(
        networkClient: any INetworkClient,
        mapper: RocketsServiceMapper = .init()
    ) {
        self.networkClient = networkClient
        self.mapper = mapper
    }

    func fetchList(request: RocketsListRequest) async throws -> PaginatedList<Rocket> {
        let response: QueryResponseDTO<RocketDTO> = try await networkClient.request(
            endpoint: RocketsServiceAPIBuilder.list(request).build()
        )

        return mapper.map(response)
    }

    func detail(id: String) async throws -> Rocket {
        let response: RocketDTO = try await networkClient.request(
            endpoint: RocketsServiceAPIBuilder.detail(id: id).build()
        )

        return mapper.map(response)
    }
}
