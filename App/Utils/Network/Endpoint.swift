protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var task: RequestTask { get }
}

struct NetworkEndpoint: Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    let task: RequestTask

    init(
        path: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        task: RequestTask = .requestPlain
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.task = task
    }
}
