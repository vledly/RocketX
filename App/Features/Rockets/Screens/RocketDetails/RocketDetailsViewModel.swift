import Observation

@MainActor
@Observable
final class RocketDetailsViewModel: Store {
    private(set) var state = RocketDetailsViewState()

    private let input: RocketDetailsAssemblyInput
    private let dependencies: RocketDetailsDependencies
    private let mapper: RocketDetailsStateMapper
    @ObservationIgnored
    private var loadTask: Task<Void, Never>?

    init(
        input: RocketDetailsAssemblyInput,
        dependencies: RocketDetailsDependencies
    ) {
        self.input = input
        self.dependencies = dependencies
        mapper = RocketDetailsStateMapper()
    }

    deinit {
        loadTask?.cancel()
    }

    func trigger(_ input: RocketDetailsInput) async {
        switch input {
        case .viewDidFirstAppear:
            startLoading()
        case .retry:
            startLoading()
        }
    }
}

private extension RocketDetailsViewModel {
    func startLoading() {
        cancelLoading()
        state.status = .loading
        let rocketID = input.rocketID
        let rocketsService = dependencies.rocketsService
        let mapper = mapper

        loadTask = Task { [weak self] in
            do {
                let rocket = try await rocketsService.detail(id: rocketID)
                let content = mapper.map(rocket)
                try Task.checkCancellation()
                self?.finishLoading(content)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                self?.failLoading()
            }
        }
    }

    func finishLoading(
        _ content: RocketDetailsViewState.Content
    ) {
        loadTask = nil
        state.status = .content(content)
    }

    func failLoading() {
        loadTask = nil
        state.status = .error
    }

    func cancelLoading() {
        loadTask?.cancel()
        loadTask = nil
    }
}
