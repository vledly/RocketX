enum RocketsServiceAPIBuilder {
    private struct QueryBody: Encodable {
        struct Options: Encodable {
            let page: Int
            let limit: Int
        }

        let query: [String: String] = [:]
        let options: Options

        init(request: RocketsListRequest) {
            options = Options(
                page: request.page,
                limit: request.perPage
            )
        }
    }

    case list(RocketsListRequest)
    case detail(id: String)

    func build() -> NetworkEndpoint {
        switch self {
        case let .list(request):
            NetworkEndpoint(
                path: "rockets/query",
                method: .post,
                task: .requestJSONEncodable(QueryBody(request: request))
            )
        case let .detail(id):
            NetworkEndpoint(path: "rockets/\(id)")
        }
    }
}
