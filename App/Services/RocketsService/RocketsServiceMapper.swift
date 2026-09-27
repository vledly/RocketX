import Foundation

struct RocketsServiceMapper {
    func map(
        _ response: QueryResponseDTO<RocketDTO>
    ) -> PaginatedList<Rocket> {
        PaginatedList(
            items: response.docs.map { map($0) },
            page: response.page,
            perPage: response.limit,
            total: response.totalDocs,
            hasNextPage: response.hasNextPage
        )
    }

    func map(_ dto: RocketDTO, imageURLOverride: URL? = nil) -> Rocket {
        return Rocket(
            id: dto.id,
            name: dto.name,
            type: dto.type,
            details: dto.description,
            imageURL: imageURLOverride ?? dto.flickrImages.first.flatMap(URL.init(string:)),
            successRate: dto.successRate,
            active: dto.active,
            stages: dto.stages,
            firstFlight: dto.firstFlight,
            engineCount: dto.engines.number,
            engineType: dto.engines.type
        )
    }
}
