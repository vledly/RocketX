import Foundation

final class MockRocketsService: IRocketsService {
    enum Failure: Error {
        case missingResource(String)
        case rocketNotFound(String)
        case invalidPagination
    }

    private let bundle: Bundle
    private let mapper: RocketsServiceMapper

    private static let falconOneID = "5e9d0d95eda69955f709d1eb"
    private static let falconOnePhoto = "https://upload.wikimedia.org/wikipedia/commons/7/71/Falcon_1_engine_test.jpg"

    init(
        bundle: Bundle = .main,
        mapper: RocketsServiceMapper = .init()
    ) {
        self.bundle = bundle
        self.mapper = mapper
    }

    func fetchList(request: RocketsListRequest) async throws -> PaginatedList<Rocket> {
        try Task.checkCancellation()
        guard request.page > 0, request.perPage > 0 else {
            throw Failure.invalidPagination
        }
        let rockets: [RocketDTO] = try load("rockets")
        let (offset, overflow) = (request.page - 1).multipliedReportingOverflow(by: request.perPage)
        guard !overflow else { throw Failure.invalidPagination }

        let docs = offset >= rockets.count
            ? []
            : Array(rockets.dropFirst(offset).prefix(request.perPage))
        return PaginatedList(
            items: docs.map { map($0) },
            page: request.page,
            perPage: request.perPage,
            total: rockets.count,
            hasNextPage: offset + docs.count < rockets.count
        )
    }

    func detail(id: String) async throws -> Rocket {
        try Task.checkCancellation()
        let rockets: [RocketDTO] = try load("rockets")
        guard let dto = rockets.first(where: { $0.id == id }) else {
            throw Failure.rocketNotFound(id)
        }
        return map(dto)
    }

    private func map(_ dto: RocketDTO) -> Rocket {
        let imageURLOverride = dto.id == Self.falconOneID
            ? URL(string: Self.falconOnePhoto)
            : nil
        return mapper.map(dto, imageURLOverride: imageURLOverride)
    }

    private func load<Response: Decodable>(_ resource: String) throws -> Response {
        guard let url = bundle.url(forResource: resource, withExtension: "json") else {
            throw Failure.missingResource(resource)
        }
        return try JSONDecoder().decode(Response.self, from: Data(contentsOf: url))
    }
}
