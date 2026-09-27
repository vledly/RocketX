import Observation

@MainActor
@Observable
final class RocketsViewModel: Store {
    typealias PageLoad = PaginationLoad<RocketsViewState.RocketItem>
    typealias Paginator = PaginationController<[RocketsViewState.RocketItem]>

    private(set) var state = RocketsViewState()

    private let dependencies: RocketsDependencies
    private let mapper: RocketsStateMapper
    @ObservationIgnored
    private let paginator = Paginator()

    init(dependencies: RocketsDependencies) {
        self.dependencies = dependencies
        mapper = RocketsStateMapper()
    }

    func trigger(_ input: RocketsInput) async {
        switch input {
        case .viewDidFirstAppear:
            startFirstPage()
        case .loadNextPage:
            startNextPage(retry: false)
        case .retryNextPage:
            startNextPage(retry: true)
        case .retry:
            startFirstPage()
        case let .didSelectRocket(id):
            dependencies.coordinator?.showRocketDetails(id: id)
        }
    }
}

private extension RocketsViewModel {
    func startFirstPage() {
        state.status = .loading
        paginator.loadFirstPage(
            using: makePageLoader(),
            onSuccess: { [weak self] page in
                self?.finishPage(page, load: .first)
            },
            onFailure: { [weak self] in
                self?.failPage(load: .first)
            }
        )
    }

    func startNextPage(retry: Bool) {
        guard case let .content(content) = state.status else { return }
        let expectedStatus: PaginationStatus = retry ? .failed : .ready
        guard content.paginationStatus == expectedStatus else { return }

        let load = PageLoad.next(existingItems: content.items)
        let didStart = paginator.loadNextPage(
            using: makePageLoader(),
            onSuccess: { [weak self] page in
                self?.finishPage(page, load: load)
            },
            onFailure: { [weak self] in
                self?.failPage(load: load)
            }
        )
        guard didStart else { return }

        state.status = .content(RocketsViewState.Content(
            items: content.items,
            paginationStatus: .loading
        ))
    }

    func makePageLoader() -> Paginator.Loader {
        let rocketsService = dependencies.rocketsService
        let mapper = mapper

        return { page in
            let response = try await rocketsService.fetchList(
                request: RocketsListRequest(page: page)
            )
            let items = response.items.map(mapper.map)
            return Paginator.Page(
                payload: items,
                number: response.page,
                hasNextPage: response.hasNextPage
            )
        }
    }

    func finishPage(_ page: Paginator.Page, load: PageLoad) {
        let items: [RocketsViewState.RocketItem]
        switch load {
        case .first:
            items = page.payload
        case let .next(existingItems):
            items = existingItems + page.payload
        }

        state.status = .content(RocketsViewState.Content(
            items: items,
            paginationStatus: page.hasNextPage ? .ready : .end
        ))
    }

    func failPage(load: PageLoad) {
        switch load {
        case .first:
            state.status = .error
        case let .next(existingItems):
            state.status = .content(RocketsViewState.Content(
                items: existingItems,
                paginationStatus: .failed
            ))
        }
    }
}
