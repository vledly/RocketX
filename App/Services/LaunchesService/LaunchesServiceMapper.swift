import Foundation

enum LaunchesServiceMapperError: Error {
    case invalidDate(String)
}

struct LaunchesServiceMapper {
    func map(
        _ response: QueryResponseDTO<LaunchDTO>
    ) throws -> PaginatedList<Launch> {
        PaginatedList(
            items: try map(response.docs),
            page: response.page,
            perPage: response.limit,
            total: response.totalDocs,
            hasNextPage: response.hasNextPage
        )
    }

    func map(_ dto: LaunchDTO) throws -> Launch {
        guard let date = date(from: dto.dateUTC) else {
            throw LaunchesServiceMapperError.invalidDate(dto.dateUTC)
        }

        let flickrImage = dto.links?.flickr?.original.first.flatMap(URL.init(string:))

        return Launch(
            id: dto.id,
            name: dto.name,
            details: dto.details,
            date: date,
            status: status(success: dto.success, upcoming: dto.upcoming),
            rocketID: dto.rocket,
            launchpadID: dto.launchpad,
            imageURL: flickrImage ?? dto.links?.patch?.large.flatMap(URL.init(string:)),
            thumbnailURL: flickrImage.flatMap(flickrThumbnailURL)
                ?? dto.links?.patch?.small.flatMap(URL.init(string:)),
            webcastURL: dto.links?.webcast.flatMap(URL.init(string:))
        )
    }

    private func map(_ items: [LaunchDTO]) throws -> [Launch] {
        try items.map { try map($0) }
    }

    private func status(success: Bool?, upcoming: Bool) -> Launch.Status {
        if upcoming { return .upcoming }

        switch success {
        case true:
            return .successful
        case false:
            return .failed
        case nil:
            return .unknown
        }
    }

    private func date(from value: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = formatter.date(from: value) {
            return date
        }

        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: value)
    }

    private func flickrThumbnailURL(from originalURL: URL) -> URL? {
        let original = originalURL.absoluteString
        let suffix = "_o.jpg"
        guard original.hasSuffix(suffix) else { return nil }
        return URL(string: String(original.dropLast(suffix.count)) + "_m.jpg")
    }
}
