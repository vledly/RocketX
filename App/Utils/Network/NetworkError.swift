enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case unacceptableStatusCode(Int)
    case requestEncoding(any Error)
    case responseDecoding(any Error)
    case transport(any Error)
}
