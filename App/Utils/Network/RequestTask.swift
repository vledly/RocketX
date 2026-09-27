enum RequestTask {
    case requestPlain
    case requestJSONEncodable(any Encodable)
    case requestParameters(
        parameters: [String: String],
        encoding: ParameterEncoding
    )
}
