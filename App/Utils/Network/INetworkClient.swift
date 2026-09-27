protocol INetworkClient: AnyObject {
    func request<Response: Decodable>(
        endpoint: any Endpoint
    ) async throws -> Response
}
