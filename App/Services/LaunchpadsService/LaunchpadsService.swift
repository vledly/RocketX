protocol ILaunchpadsService: AnyObject {
    func detail(id: String) async throws -> Launchpad
}

final class LaunchpadsService: ILaunchpadsService {
    private let networkClient: any INetworkClient
    private let mapper: LaunchpadsServiceMapper

    init(
        networkClient: any INetworkClient,
        mapper: LaunchpadsServiceMapper = .init()
    ) {
        self.networkClient = networkClient
        self.mapper = mapper
    }

    func detail(id: String) async throws -> Launchpad {
        let response: LaunchpadDTO = try await networkClient.request(
            endpoint: NetworkEndpoint(path: "launchpads/\(id)")
        )
        return mapper.map(response)
    }
}
