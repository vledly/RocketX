import Foundation

enum LaunchesServiceAPIBuilder {
    private struct QueryBody: Encodable {
        struct DateFilter: Encodable {
            let start: String?
            let endExclusive: String?

            enum CodingKeys: String, CodingKey {
                case start = "$gte"
                case endExclusive = "$lt"
            }
        }

        struct Options: Encodable {
            let page: Int
            let limit: Int
            let sort: [String: String]
        }

        let query: [String: DateFilter]
        let options: Options

        init(request: LaunchesListRequest) {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let range = request.dateRange
            if range.isActive {
                query = ["date_utc": DateFilter(
                    start: range.startInclusive.map(formatter.string(from:)),
                    endExclusive: range.endExclusive.map(formatter.string(from:))
                )]
            } else {
                query = [:]
            }
            options = Options(
                page: request.page,
                limit: request.perPage,
                sort: ["date_utc": "desc"]
            )
        }
    }

    case list(LaunchesListRequest)
    case detail(id: String)

    func build() -> NetworkEndpoint {
        switch self {
        case let .list(request):
            NetworkEndpoint(
                path: "launches/query",
                method: .post,
                task: .requestJSONEncodable(QueryBody(request: request))
            )
        case let .detail(id):
            NetworkEndpoint(path: "launches/\(id)")
        }
    }
}
