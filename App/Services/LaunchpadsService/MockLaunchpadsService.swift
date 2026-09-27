import Foundation

final class MockLaunchpadsService: ILaunchpadsService {
    enum Failure: Error {
        case missingResource(String)
        case launchpadNotFound(String)
    }

    private let bundle: Bundle
    private let mapper: LaunchpadsServiceMapper

    init(
        bundle: Bundle = .main,
        mapper: LaunchpadsServiceMapper = .init()
    ) {
        self.bundle = bundle
        self.mapper = mapper
    }

    func detail(id: String) async throws -> Launchpad {
        try Task.checkCancellation()
        let launchpads: [LaunchpadDTO] = try load("launchpads")
        guard let dto = launchpads.first(where: { $0.id == id }) else {
            throw Failure.launchpadNotFound(id)
        }
        return mapper.map(dto)
    }

    private func load<Response: Decodable>(_ resource: String) throws -> Response {
        guard let url = bundle.url(forResource: resource, withExtension: "json") else {
            throw Failure.missingResource(resource)
        }
        return try JSONDecoder().decode(Response.self, from: Data(contentsOf: url))
    }
}
