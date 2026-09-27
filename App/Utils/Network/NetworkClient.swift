import Foundation

final class NetworkClient: INetworkClient {
    private let baseURL: URL
    private let session: URLSession

    init(
        baseURL: URL,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }

    func request<Response: Decodable>(
        endpoint: any Endpoint
    ) async throws -> Response {
        let request = try makeRequest(endpoint: endpoint)

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            guard !Task.isCancelled else {
                throw CancellationError()
            }
            throw NetworkError.transport(error)
        }
        try Task.checkCancellation()

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.unacceptableStatusCode(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(Response.self, from: data)
        } catch {
            throw NetworkError.responseDecoding(error)
        }
    }

    private func makeRequest(endpoint: any Endpoint) throws -> URLRequest {
        guard let url = makeURL(path: endpoint.path) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        do {
            switch endpoint.task {
            case .requestPlain:
                break
            case let .requestJSONEncodable(value):
                request.httpBody = try JSONEncoder().encode(value)
                setJSONContentTypeIfNeeded(request: &request)
            case let .requestParameters(parameters, encoding):
                try encode(parameters, using: encoding, into: &request)
            }
        } catch {
            throw NetworkError.requestEncoding(error)
        }

        return request
    }

    private func makeURL(path: String) -> URL? {
        guard var components = URLComponents(
            url: baseURL,
            resolvingAgainstBaseURL: false
        ) else { return nil }

        let basePath = components.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let endpointPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        components.path = "/" + [basePath, endpointPath]
            .filter { !$0.isEmpty }
            .joined(separator: "/")

        return components.url
    }

    private func encode(
        _ parameters: [String: String],
        using encoding: ParameterEncoding,
        into request: inout URLRequest
    ) throws {
        switch encoding {
        case .urlQuery:
            guard let url = request.url,
                  var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            else { throw NetworkError.invalidURL }

            components.queryItems = parameters
                .sorted { $0.key < $1.key }
                .map(URLQueryItem.init)

            guard let encodedURL = components.url else {
                throw NetworkError.invalidURL
            }
            request.url = encodedURL

        case .json:
            request.httpBody = try JSONEncoder().encode(parameters)
            setJSONContentTypeIfNeeded(request: &request)
        }
    }

    private func setJSONContentTypeIfNeeded(request: inout URLRequest) {
        guard request.value(forHTTPHeaderField: "Content-Type") == nil else { return }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}
