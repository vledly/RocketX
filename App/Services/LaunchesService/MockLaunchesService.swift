import Foundation

final class MockLaunchesService: ILaunchesService {
    enum Failure: Error {
        case missingResource(String)
        case invalidPagination
        case launchNotFound(String)
    }

    private let bundle: Bundle
    private let mapper: LaunchesServiceMapper

    init(
        bundle: Bundle = .main,
        mapper: LaunchesServiceMapper = .init()
    ) {
        self.bundle = bundle
        self.mapper = mapper
    }

    func fetchList(request: LaunchesListRequest) async throws -> PaginatedList<Launch> {
        try Task.checkCancellation()
        guard request.page > 0, request.perPage > 0 else {
            throw Failure.invalidPagination
        }

        let launches: [LaunchDTO] = try load("launches")
        let matchingLaunches = try launches.filter {
            try request.dateRange.contains(mapper.map($0).date)
        }
        let (offset, overflow) = (request.page - 1).multipliedReportingOverflow(by: request.perPage)
        guard !overflow else { throw Failure.invalidPagination }

        let docs = offset >= matchingLaunches.count
            ? []
            : Array(matchingLaunches.dropFirst(offset).prefix(request.perPage))
        let totalPages = matchingLaunches.count / request.perPage
            + (matchingLaunches.count % request.perPage == 0 ? 0 : 1)
        let hasNextPage = request.page < totalPages

        let page = QueryResponseDTO(
            docs: docs,
            totalDocs: matchingLaunches.count,
            limit: request.perPage,
            page: request.page,
            hasNextPage: hasNextPage
        )
        return try mapper.map(page)
    }

    func detail(id: String) async throws -> Launch {
        try Task.checkCancellation()
        let launches: [LaunchDTO] = try load("launches")
        guard let launch = launches.first(where: { $0.id == id }) else {
            throw Failure.launchNotFound(id)
        }
        return try mapper.map(launch)
    }

    private func load<Response: Decodable>(_ resource: String) throws -> Response {
        guard let url = bundle.url(forResource: resource, withExtension: "json") else {
            throw Failure.missingResource(resource)
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
