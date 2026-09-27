import Foundation
import Observation

@MainActor
@Observable
final class LaunchesViewModel: Store {
    private struct PagePayload: Sendable {
        let items: [LaunchesViewState.LaunchItem]
        let suggestedFilterDate: Date?
    }

    private typealias PageLoad = PaginationLoad<LaunchesViewState.LaunchItem>
    private typealias Paginator = PaginationController<PagePayload>

    private(set) var state = LaunchesViewState()

    private let dependencies: LaunchesDependencies
    private let mapper: LaunchesViewStateMapper
    @ObservationIgnored
    private let paginator = Paginator()

    init(dependencies: LaunchesDependencies) {
        self.dependencies = dependencies
        mapper = LaunchesViewStateMapper()
    }

    func trigger(_ input: LaunchesInput) async {
        switch input {
        case .viewDidFirstAppear:
            startFirstPage()
        case .retry:
            startFirstPage()
        case .loadNextPage:
            startNextPage(retry: false)
        case .retryNextPage:
            startNextPage(retry: true)
        case let .applyDateRange(dateRange):
            guard dateRange.isValid, dateRange != state.dateRange else { return }
            state.dateRange = dateRange
            startFirstPage()
        case let .didSelectLaunch(id):
            dependencies.coordinator?.showLaunchDetails(
                input: LaunchDetailsAssemblyInput(launchID: id)
            )
        }
    }
}

private extension LaunchesViewModel {
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

        state.status = .content(LaunchesViewState.Content(
            items: content.items,
            paginationStatus: .loading
        ))
    }

    private func makePageLoader() -> Paginator.Loader {
        let dateRange = state.dateRange
        let facade = dependencies.facade
        let mapper = mapper

        return { page in
            let response = try await facade.fetchList(
                request: LaunchesListRequest(
                    page: page,
                    dateRange: dateRange
                )
            )
            try Task.checkCancellation()

            return Paginator.Page(
                payload: PagePayload(
                    items: response.items.map(mapper.map),
                    suggestedFilterDate: response.items.first?.launch.date
                ),
                number: response.page,
                hasNextPage: response.hasNextPage
            )
        }
    }

    private func finishPage(_ page: Paginator.Page, load: PageLoad) {
        if state.suggestedFilterDate == nil {
            state.suggestedFilterDate = page.payload.suggestedFilterDate
        }

        let items: [LaunchesViewState.LaunchItem]
        switch load {
        case .first:
            items = page.payload.items
        case let .next(existingItems):
            items = existingItems + page.payload.items
        }

        state.status = .content(LaunchesViewState.Content(
            items: items,
            paginationStatus: page.hasNextPage ? .ready : .end
        ))
    }

    private func failPage(load: PageLoad) {
        switch load {
        case .first:
            state.status = .error
        case let .next(existingItems):
            state.status = .content(LaunchesViewState.Content(
                items: existingItems,
                paginationStatus: .failed
            ))
        }
    }
}
