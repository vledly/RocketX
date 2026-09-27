import Foundation
import Observation

@MainActor
@Observable
final class LaunchDetailsViewModel: Store {
    private(set) var state = LaunchDetailsViewState()
    
    private let input: LaunchDetailsAssemblyInput
    private let dependencies: LaunchDetailsDependencies
    private let mapper: LaunchDetailsStateMapper
    @ObservationIgnored
    private var loadTask: Task<Void, Never>?
    
    init(
        input: LaunchDetailsAssemblyInput,
        dependencies: LaunchDetailsDependencies
    ) {
        self.input = input
        self.dependencies = dependencies
        mapper = LaunchDetailsStateMapper()
    }
    
    deinit {
        loadTask?.cancel()
    }
    
    func trigger(_ input: LaunchDetailsInput) async {
        switch input {
        case .viewDidFirstAppear:
            startLoading()
        case .retry:
            startLoading()
        case let .didSelectRocket(id):
            dependencies.coordinator?.showRocketDetails(id: id)
        }
    }
}

private extension LaunchDetailsViewModel {
    func startLoading() {
        cancelLoading()
        state.status = .loading
        let launchID = input.launchID
        let launchesService = dependencies.launchesService
        let rocketsService = dependencies.rocketsService
        let launchpadsService = dependencies.launchpadsService
        let mapper = mapper

        loadTask = Task { [weak self] in
            do {
                let launch = try await launchesService.detail(id: launchID)
                let rocket = try await rocketsService.detail(id: launch.rocketID)
                let launchpad = try await launchpadsService.detail(id: launch.launchpadID)

                let content = mapper.map(launch: launch, rocket: rocket, launchpad: launchpad)
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
        _ content: LaunchDetailsViewState.Content
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
